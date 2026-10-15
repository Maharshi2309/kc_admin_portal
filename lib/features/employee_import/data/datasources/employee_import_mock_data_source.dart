import 'dart:math' as math;
import 'dart:typed_data';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_remote_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/mock_excel.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_mock_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): employee import, playing the backend
/// (docs/ARCHITECTURE_MULTI_ORG.md §D). The file is read, checked row by row
/// against this organization's data, and imported through the same rules as
/// the Add employee form. The file itself isn't kept.
///
/// - Rows with errors are never imported; the rest are, each on its own (a
///   row that fails at the last moment is reported, never half-written).
/// - Existing EC numbers: skipped, or updated with only the mapped,
///   non-empty cells (never the schedule).
class EmployeeImportMockDataSource implements EmployeeImportRemoteDataSource {
  EmployeeImportMockDataSource({
    required this.organization,
    required this.employeeSource,
    required this._employees,
    this.guard = const MockGuard.allowAll(),
    this.latency = Duration.zero,
  });

  final OrganizationMockDataSource organization;
  final EmployeeMockDataSource employeeSource;
  final MockGuard guard;
  final Duration latency;
  final List<EmployeeModel> _employees;
  final Map<String, _Import> _imports = {};
  int _nextId = 1;

  Future<void> _wait() => Future<void>.delayed(latency);

  // ---------------------------------------------------------------- template

  @override
  Future<Uint8List> template() async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    List<String> active(List<CatalogItemModel> items) => [
      for (final item in items)
        if (item.isActive) item.name,
    ];
    return MockExcel.template(
      ecNumberPrefix: organization.currentSettings.ecNumberPrefix,
      departments: active(await organization.catalog(CatalogKind.departments)),
      positions: active(await organization.catalog(CatalogKind.positions)),
    );
  }

  // ------------------------------------------------------------------ upload

  @override
  Future<EmployeeImportModel> upload(Uint8List bytes, String fileName) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    final sheet = MockExcel.read(bytes);
    final id = 'imp${_nextId++}';
    final entry = _Import(id: id, fileName: fileName, sheet: sheet);
    _imports[id] = entry;
    return _model(entry);
  }

  /// Header words for each field, compared without case, spaces or signs.
  static const Map<ImportField, List<String>> _synonyms = {
    ImportField.name: [
      'employeename',
      'name',
      'fullname',
      'employee',
      'staffname',
    ],
    ImportField.ecNumber: [
      'ecnumber',
      'ecno',
      'ec',
      'employeecode',
      'empcode',
      'employeeid',
      'empid',
      'employeeno',
      'employeenumber',
      'code',
      'staffid',
    ],
    ImportField.mobile: [
      'mobilenumber',
      'mobile',
      'phone',
      'phonenumber',
      'mobileno',
      'contact',
      'contactnumber',
      'cell',
    ],
    ImportField.department: ['department', 'dept', 'division'],
    ImportField.position: [
      'position',
      'designation',
      'jobtitle',
      'title',
      'role',
      'post',
    ],
    ImportField.joiningDate: [
      'joiningdate',
      'dateofjoining',
      'doj',
      'joined',
      'joindate',
      'startdate',
      'datejoined',
    ],
    ImportField.status: ['status', 'employeestatus', 'active'],
    ImportField.shiftStart: [
      'shiftstart',
      'starttime',
      'start',
      'intime',
      'from',
    ],
    ImportField.shiftEnd: ['shiftend', 'endtime', 'end', 'outtime', 'to'],
    ImportField.breakMinutes: [
      'breakminutes',
      'break',
      'breaktime',
      'lunch',
      'lunchminutes',
    ],
    ImportField.weeklyOffs: [
      'weeklyoff',
      'weeklyoffs',
      'weekoff',
      'weekoffs',
      'dayoff',
      'daysoff',
      'offday',
      'offdays',
    ],
  };

  static String _plain(String text) =>
      text.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

  /// Each header's best guess; a field is guessed for one header at most.
  static Map<String, String?> _suggest(List<String> headers) {
    final taken = <ImportField>{};
    return {
      for (final header in headers)
        header: () {
          final plain = _plain(header);
          for (final MapEntry(key: field, value: words) in _synonyms.entries) {
            if (!taken.contains(field) && words.contains(plain)) {
              taken.add(field);
              return field.name;
            }
          }
          return null;
        }(),
    };
  }

  // ------------------------------------------------------------------- check

  _Import _find(String id) {
    final entry = _imports[id];
    if (entry == null) {
      throw const NotFoundException(
        'This import was not found. It may have expired: upload the file '
        'again.',
      );
    }
    return entry;
  }

  @override
  Future<EmployeeImportModel> check(
    String id,
    ImportOptionsModel options,
  ) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    if (options.duplicateStrategy == DuplicateStrategy.update) {
      guard.require(AppPermission.employeeEdit);
    }
    final entry = _find(id);
    if (entry.status != ImportStatus.uploaded &&
        entry.status != ImportStatus.validated) {
      throw const ValidationException('This import has already run.');
    }
    final mapping = <ImportField, int>{};
    for (final (index, header) in entry.sheet.headers.indexed) {
      final field = ImportField.fromKey(options.mapping[header]);
      if (field == null) continue;
      if (mapping.containsKey(field)) {
        throw ValidationException(
          '"${field.label}" is chosen for more than one column.',
          fieldErrors: {'mapping': '"${field.label}" is chosen twice'},
        );
      }
      mapping[field] = index;
    }
    // Updating existing employees needs only the EC number: required
    // values are then checked on each row that would be new.
    final updating = options.duplicateStrategy == DuplicateStrategy.update;
    final missing = [
      for (final field in ImportField.values)
        if (field.isRequired &&
            !mapping.containsKey(field) &&
            !(field == ImportField.ecNumber && options.assignEcNumbers) &&
            !(updating && field != ImportField.ecNumber))
          field.label,
    ];
    if (missing.isNotEmpty) {
      throw ValidationException(
        'Choose a column for: ${missing.join(', ')}.',
        fieldErrors: {'mapping': 'Missing: ${missing.join(', ')}'},
      );
    }
    entry
      ..options = options
      ..mapping = mapping
      ..checks = await _checkAll(entry)
      ..status = ImportStatus.validated;
    return _model(entry);
  }

  Future<List<_RowCheck>> _checkAll(_Import entry) async {
    final options = entry.options!;
    final departments = await organization.catalog(CatalogKind.departments);
    final positions = await organization.catalog(CatalogKind.positions);
    final prefix = organization.currentSettings.ecNumberPrefix;
    final ecPattern = RegExp('^${RegExp.escape(prefix)}\\d+\$');
    final firstRowOf = <String, int>{};
    final checks = <_RowCheck>[];

    for (final (index, cells) in entry.sheet.rows.indexed) {
      final rowNumber = index + 2; // The header is row 1.
      String cell(ImportField field) {
        final column = entry.mapping![field];
        return column == null ? '' : cells[column].trim();
      }

      final errors = <String>[];
      final warnings = <String>[];
      final check = _RowCheck(rowNumber: rowNumber, cells: cells);

      // EC number
      final ec = cell(ImportField.ecNumber).toUpperCase();
      if (ec.isEmpty) {
        if (options.assignEcNumbers) {
          warnings.add('Gets the next EC number');
        } else {
          errors.add('EC number is missing');
        }
      } else if (!ecPattern.hasMatch(ec)) {
        errors.add('EC number must be $prefix followed by numbers');
      } else if (firstRowOf[ec] case final first?) {
        errors.add('EC number $ec is also on row $first');
      } else {
        firstRowOf[ec] = rowNumber;
      }
      check.ecNumber = ec.isEmpty ? null : ec;
      final existing = ec.isEmpty
          ? null
          : _employees.where((e) => e.ecNumber == ec).firstOrNull;

      // Name (an existing employee keeps theirs when the cell is empty)
      final name = cell(ImportField.name);
      if (name.isEmpty) {
        if (existing == null) errors.add('Employee name is missing');
      } else if (name.length < 2 || name.length > 100) {
        errors.add('Employee name must be 2 to 100 characters');
      }
      check.name = name;

      // Mobile
      final mobileText = cell(ImportField.mobile);
      final mobile = _mobile(mobileText);
      if (mobileText.isEmpty) {
        if (existing == null) errors.add('Mobile number is missing');
      } else if (mobile == null) {
        errors.add(
          PhoneUtils.validate(mobileText, country: _phoneCountry) ??
              'Mobile number is not valid',
        );
      }

      // Department and position
      String? catalogId(CatalogKind kind, ImportField field) {
        final value = cell(field);
        final label = kind.singular;
        if (value.isEmpty) {
          if (existing == null) errors.add('$label is missing');
          return null;
        }
        final items = kind == CatalogKind.departments ? departments : positions;
        final match = items
            .where((i) => i.name.toLowerCase() == value.toLowerCase())
            .firstOrNull;
        if (match == null) {
          if (options.createMissing) {
            warnings.add('$label "$value" will be created');
            return _toCreate(kind, value);
          }
          errors.add(
            '$label "$value" isn\'t in Settings (add it, or tick '
            '"Create missing")',
          );
          return null;
        }
        if (!match.isActive) {
          errors.add('$label "${match.name}" is deactivated');
          return null;
        }
        return match.id;
      }

      final departmentId = catalogId(
        CatalogKind.departments,
        ImportField.department,
      );
      final positionId = catalogId(CatalogKind.positions, ImportField.position);

      // Joining date
      final dateText = cell(ImportField.joiningDate);
      final joining = _date(dateText);
      if (dateText.isEmpty) {
        if (existing == null) errors.add('Joining date is missing');
      } else if (joining == null) {
        errors.add('Joining date "$dateText" isn\'t a date (use dd/mm/yyyy)');
      }

      // Status
      final statusText = cell(ImportField.status).toLowerCase();
      final status = switch (statusText) {
        '' || 'active' || 'yes' => EmployeeStatus.active,
        'inactive' || 'no' => EmployeeStatus.inactive,
        _ => null,
      };
      if (status == null) errors.add('Status must be Active or Inactive');

      // Schedule (new employees only; updates never change it)
      WorkScheduleInput? schedule;
      if (existing == null && joining != null) {
        schedule = _schedule(cell, joining, errors);
      }

      check
        ..mobile = mobile
        ..departmentId = departmentId
        ..positionId = positionId
        ..joiningDate = joining
        ..status = status ?? EmployeeStatus.active
        ..statusGiven = statusText.isNotEmpty
        ..schedule = schedule
        ..existingId = existing?.id;

      if (existing != null && errors.isEmpty) {
        if (options.duplicateStrategy == DuplicateStrategy.skip) {
          check
            ..status_ = ImportRowStatus.skipped
            ..messages = ['$ec already exists: left as it is'];
          checks.add(check);
          continue;
        }
        check.changes = _changes(existing, check, departments, positions);
        if (check.changes.isEmpty) {
          check
            ..status_ = ImportRowStatus.skipped
            ..messages = ['$ec already exists with the same details'];
          checks.add(check);
          continue;
        }
        warnings.add('Updates $ec (${existing.name})');
      } else if (existing == null && mobile != null) {
        final twin = _employees
            .where(
              (e) =>
                  _mobile(e.mobile) == mobile &&
                  e.name.toLowerCase() == name.toLowerCase(),
            )
            .firstOrNull;
        if (twin != null) {
          warnings.add(
            'Possible duplicate: ${twin.name} (${twin.ecNumber}) has the same '
            'name and mobile',
          );
        }
      }

      check
        ..status_ = errors.isNotEmpty
            ? ImportRowStatus.error
            : warnings.isNotEmpty
            ? ImportRowStatus.warning
            : ImportRowStatus.valid
        ..messages = [...errors, ...warnings];
      checks.add(check);
    }
    return checks;
  }

  /// Departments and positions to create, keyed by their lower-case name.
  final Map<String, String> _pending = {};

  String _toCreate(CatalogKind kind, String name) =>
      'new:${kind.name}:${name.trim()}';

  String get _phoneCountry => organization.currentSettings.defaultCountry;

  /// International form (`+919825011234`): "+44 7400 123456", "98250 11234"
  /// or "098250 11234" (the organization's country), or null if invalid.
  String? _mobile(String text) =>
      PhoneUtils.toStored(text, country: _phoneCountry);

  /// `yyyy-mm-dd` (Excel dates arrive like that), `dd/mm/yyyy`,
  /// `dd-mm-yyyy` or `dd.mm.yyyy`. Anything else is an error, never a guess.
  static DateTime? _date(String text) {
    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})( .*)?$').firstMatch(text);
    final dmy = RegExp(
      r'^(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{4})$',
    ).firstMatch(text);
    final (y, m, d) = iso != null
        ? (iso[1]!, iso[2]!, iso[3]!)
        : dmy != null
        ? (dmy[3]!, dmy[2]!, dmy[1]!)
        : (null, null, null);
    if (y == null) return null;
    final date = DateTime(int.parse(y), int.parse(m!), int.parse(d!));
    // 31/02 rolls over in DateTime: refuse it.
    return date.month == int.parse(m) && date.day == int.parse(d) ? date : null;
  }

  /// `09:30`, `9:30`, `9:30 AM`, `6 PM`, `18:30:00`.
  static ClockTime? _time(String text) {
    final match = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?(?::\d{2})?\s*([ap]\.?m\.?)?$',
      caseSensitive: false,
    ).firstMatch(text.trim());
    if (match == null) return null;
    var hour = int.parse(match[1]!);
    final minute = int.tryParse(match[2] ?? '0')!;
    final half = match[3]?.toLowerCase().replaceAll('.', '');
    if (half != null) {
      if (hour < 1 || hour > 12) return null;
      hour = hour % 12 + (half == 'pm' ? 12 : 0);
    }
    if (hour > 23 || minute > 59) return null;
    return ClockTime.hm(hour, minute);
  }

  static const Map<String, int> _days = {
    'mon': DateTime.monday,
    'tue': DateTime.tuesday,
    'wed': DateTime.wednesday,
    'thu': DateTime.thursday,
    'fri': DateTime.friday,
    'sat': DateTime.saturday,
    'sun': DateTime.sunday,
  };

  static List<int>? _weekdays(String text) {
    final parts = text
        .toLowerCase()
        .split(RegExp(r'[,/;&]|\band\b'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length == 1 && parts.single == 'none') return const [];
    final days = <int>{};
    for (final part in parts) {
      final day = part.length >= 3 ? _days[part.substring(0, 3)] : null;
      if (day == null) return null;
      days.add(day);
    }
    return days.toList()..sort();
  }

  WorkScheduleInput? _schedule(
    String Function(ImportField) cell,
    DateTime joining,
    List<String> errors,
  ) {
    final defaults = organization.currentSettings.defaultSchedule;
    final startText = cell(ImportField.shiftStart);
    final endText = cell(ImportField.shiftEnd);
    final breakText = cell(ImportField.breakMinutes);
    final offText = cell(ImportField.weeklyOffs);
    final start = startText.isEmpty ? defaults.startTime : _time(startText);
    final end = endText.isEmpty ? defaults.endTime : _time(endText);
    final breakMinutes = breakText.isEmpty
        ? defaults.breakMinutes
        : int.tryParse(breakText);
    final offs = offText.isEmpty ? defaults.weeklyOffDays : _weekdays(offText);
    if (start == null) errors.add('Shift start "$startText" isn\'t a time');
    if (end == null) errors.add('Shift end "$endText" isn\'t a time');
    if (breakMinutes == null || breakMinutes < 0) {
      errors.add('Break must be a number of minutes');
    }
    if (offs == null) {
      errors.add('Weekly off "$offText" must be day names, e.g. Sat, Sun');
    } else if (offs.length >= DateTime.daysPerWeek) {
      errors.add('Weekly off leaves no working day');
    }
    if (start == null || end == null || breakMinutes == null || offs == null) {
      return null;
    }
    if (end.compareTo(start) <= 0) {
      errors.add('Shift end must be after the start');
      return null;
    }
    if (breakMinutes >= end.minutes - start.minutes) {
      errors.add('The break is longer than the shift');
      return null;
    }
    return WorkScheduleInput(
      effectiveFrom: joining,
      startTime: start,
      endTime: end,
      breakMinutes: breakMinutes,
      weeklyOffDays: offs,
    );
  }

  /// What an update would change: only the mapped, non-empty cells.
  List<ImportChangeModel> _changes(
    EmployeeModel existing,
    _RowCheck row,
    List<CatalogItemModel> departments,
    List<CatalogItemModel> positions,
  ) {
    String nameOf(List<CatalogItemModel> items, String? id) => id == null
        ? ''
        : id.startsWith('new:')
        ? id.split(':').last
        : items.where((i) => i.id == id).firstOrNull?.name ?? '';
    String date(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return [
      if (row.name.isNotEmpty && row.name != existing.name)
        ImportChangeModel(
          field: 'Name',
          before: existing.name,
          after: row.name,
        ),
      // The same number, saved before without its country code, is no
      // change.
      if (row.mobile != null &&
          row.mobile != (_mobile(existing.mobile) ?? existing.mobile))
        ImportChangeModel(
          field: 'Mobile number',
          before: PhoneUtils.format(existing.mobile, country: _phoneCountry),
          after: PhoneUtils.format(row.mobile!, country: _phoneCountry),
        ),
      if (row.departmentId != null &&
          row.departmentId != existing.department.id)
        ImportChangeModel(
          field: 'Department',
          before: existing.department.name,
          after: nameOf(departments, row.departmentId),
        ),
      if (row.positionId != null && row.positionId != existing.position.id)
        ImportChangeModel(
          field: 'Position',
          before: existing.position.name,
          after: nameOf(positions, row.positionId),
        ),
      if (row.joiningDate != null && row.joiningDate != existing.joiningDate)
        ImportChangeModel(
          field: 'Joining date',
          before: date(existing.joiningDate),
          after: date(row.joiningDate!),
        ),
      if (row.statusGiven && row.status != existing.status)
        ImportChangeModel(
          field: 'Status',
          before: existing.status.label,
          after: row.status.label,
        ),
    ];
  }

  // -------------------------------------------------------------------- rows

  @override
  Future<ImportRowsPageModel> rows(
    String id, {
    ImportRowFilter filter = ImportRowFilter.problems,
    int page = 1,
    int pageSize = 20,
  }) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    final entry = _find(id);
    bool keep(ImportRowStatus s) => switch (filter) {
      ImportRowFilter.problems =>
        s == ImportRowStatus.error ||
            s == ImportRowStatus.warning ||
            s == ImportRowStatus.failed,
      ImportRowFilter.errors =>
        s == ImportRowStatus.error || s == ImportRowStatus.failed,
      ImportRowFilter.warnings => s == ImportRowStatus.warning,
      ImportRowFilter.all => true,
    };
    final matching = [
      for (final row in entry.checks)
        if (keep(row.status_)) row,
    ];
    final start = math.min((page - 1) * pageSize, matching.length);
    final end = math.min(start + pageSize, matching.length);
    return ImportRowsPageModel(
      items: [for (final row in matching.sublist(start, end)) row.model],
      total: matching.length,
      page: page,
      pageSize: pageSize,
    );
  }

  // ----------------------------------------------------------------- confirm

  @override
  Future<EmployeeImportModel> confirm(String id) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    final entry = _find(id);
    if (entry.status != ImportStatus.validated) {
      throw const ValidationException(
        'Check the rows first, then confirm the import.',
      );
    }
    // Data may have changed since the preview: check again.
    entry
      ..checks = await _checkAll(entry)
      ..status = ImportStatus.importing;

    for (final row in entry.checks) {
      if (!row.status_.willBeImported) continue;
      try {
        if (row.existingId case final existingId?) {
          await _update(existingId, row);
          row
            ..status_ = ImportRowStatus.updated
            ..messages = ['Updated'];
        } else {
          final created = await _create(row);
          row
            ..status_ = ImportRowStatus.imported
            ..ecNumber = created.ecNumber
            ..messages = ['Imported as ${created.ecNumber}'];
        }
      } on AppException catch (error) {
        row
          ..status_ = ImportRowStatus.failed
          ..messages = [error.message];
      }
      entry.processed++;
    }
    for (final row in entry.checks) {
      if (row.status_ == ImportRowStatus.error) {
        row.status_ = ImportRowStatus.failed;
      }
    }
    entry.status = ImportStatus.completed;
    return _model(entry);
  }

  Future<String> _catalogId(CatalogKind kind, String id) async {
    if (!id.startsWith('new:')) return id;
    final name = id.split(':').last;
    final key = '${kind.name}:${name.toLowerCase()}';
    final known = _pending[key];
    if (known != null) return known;
    final created = await organization.addCatalogItem(kind, name);
    return _pending[key] = created.id;
  }

  Future<EmployeeModel> _create(_RowCheck row) async {
    final ecNumber = row.ecNumber ?? await employeeSource.nextEcNumber();
    return employeeSource.create(
      EmployeeFormData(
        ecNumber: ecNumber,
        name: row.name,
        mobile: row.mobile!,
        departmentId: await _catalogId(
          CatalogKind.departments,
          row.departmentId!,
        ),
        positionId: await _catalogId(CatalogKind.positions, row.positionId!),
        joiningDate: row.joiningDate!,
        status: row.status,
        schedule: row.schedule,
      ),
    );
  }

  Future<void> _update(String id, _RowCheck row) async {
    final current = await employeeSource.getById(id);
    await employeeSource.update(
      id,
      EmployeeFormData(
        ecNumber: current.ecNumber,
        name: row.name.isEmpty ? current.name : row.name,
        mobile: row.mobile ?? current.mobile,
        departmentId: row.departmentId == null
            ? current.department.id
            : await _catalogId(CatalogKind.departments, row.departmentId!),
        positionId: row.positionId == null
            ? current.position.id
            : await _catalogId(CatalogKind.positions, row.positionId!),
        joiningDate: row.joiningDate ?? current.joiningDate,
        status: row.statusGiven ? row.status : current.status,
      ),
    );
  }

  @override
  Future<EmployeeImportModel> get(String id) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    return _model(_find(id));
  }

  // ------------------------------------------------------------------ report

  @override
  Future<Uint8List> report(String id) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    final entry = _find(id);
    return MockExcel.report(
      headers: entry.sheet.headers,
      rows: [
        for (final row in entry.checks)
          if (row.status_ == ImportRowStatus.failed ||
              row.status_ == ImportRowStatus.error ||
              row.status_ == ImportRowStatus.skipped)
            (row.rowNumber, row.cells, row.messages.join('; ')),
      ],
    );
  }

  @override
  Future<void> cancel(String id) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    final entry = _find(id);
    if (entry.status == ImportStatus.importing) {
      throw const ValidationException('This import is already running.');
    }
    _imports.remove(id);
  }

  // ------------------------------------------------------------------ models

  EmployeeImportModel _model(_Import entry) {
    int count(bool Function(ImportRowStatus s) test) =>
        entry.checks.where((r) => test(r.status_)).length;
    final checked = entry.options != null;
    final done = entry.status == ImportStatus.completed;
    return EmployeeImportModel(
      id: entry.id,
      fileName: entry.fileName,
      status: entry.status,
      headers: entry.sheet.headers,
      sampleRows: entry.sheet.rows.take(3).toList(),
      rowCount: entry.sheet.rows.length,
      suggestedMapping: _suggest(entry.sheet.headers),
      mapping: entry.options?.mapping,
      duplicateStrategy: entry.options?.duplicateStrategy,
      createMissing: entry.options?.createMissing ?? false,
      assignEcNumbers: entry.options?.assignEcNumbers ?? false,
      counts: checked && !done
          ? ImportCountsModel(
              valid: count((s) => s == ImportRowStatus.valid),
              warnings: count((s) => s == ImportRowStatus.warning),
              errors: count((s) => s == ImportRowStatus.error),
              skipped: count((s) => s == ImportRowStatus.skipped),
            )
          : null,
      processed: entry.processed,
      result: done
          ? ImportResultModel(
              imported: count((s) => s == ImportRowStatus.imported),
              updated: count((s) => s == ImportRowStatus.updated),
              skipped: count((s) => s == ImportRowStatus.skipped),
              failed: count((s) => s == ImportRowStatus.failed),
            )
          : null,
    );
  }
}

class _Import {
  _Import({required this.id, required this.fileName, required this.sheet});

  final String id;
  final String fileName;
  final SheetText sheet;
  ImportStatus status = ImportStatus.uploaded;
  ImportOptionsModel? options;
  Map<ImportField, int>? mapping;
  List<_RowCheck> checks = const [];
  int processed = 0;
}

class _RowCheck {
  _RowCheck({required this.rowNumber, required this.cells});

  final int rowNumber;
  final List<String> cells;
  ImportRowStatus status_ = ImportRowStatus.valid;
  List<String> messages = const [];
  List<ImportChangeModel> changes = const [];
  String name = '';
  String? ecNumber;
  String? mobile;
  String? departmentId;
  String? positionId;
  DateTime? joiningDate;
  EmployeeStatus status = EmployeeStatus.active;
  bool statusGiven = false;
  WorkScheduleInput? schedule;
  String? existingId;

  ImportRowModel get model => ImportRowModel(
    rowNumber: rowNumber,
    status: status_,
    ecNumber: ecNumber,
    name: name.isEmpty ? null : name,
    messages: messages,
    changes: changes,
  );
}
