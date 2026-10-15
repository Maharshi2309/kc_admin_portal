import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_mock_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_catalogs.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): an in-memory employee store that behaves
/// like the assumed API (search, filters, paging, duplicate checks), so the
/// screens can be built and tried before the backend exists. Sample data is
/// illustrative. Changes last until the app restarts.
class EmployeeMockDataSource implements EmployeeRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  EmployeeMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    this.latency = Duration.zero,
    List<EmployeeModel>? store,
    this.leaves,
    MockScheduleBook? schedules,
    this.holidays,
    this.attendance,
    this.organization,
  }) : _employees = store ?? seed(now()),
       _schedules = schedules ?? _seededBook(now, store ?? seed(now()));

  final DateTime Function() now;
  final Duration latency;

  /// Shared with the other dev mocks (see [mockEmployeeStoreProvider]).
  final List<EmployeeModel> _employees;

  /// When set, balances and history come from the leave mock, so they
  /// change as leave is added.
  final LeaveMockDataSource? leaves;

  /// Schedule versions (shared with the attendance mock in the app).
  final MockScheduleBook _schedules;

  /// The organization's departments, positions and settings, when shared
  /// (the app); tests without it get Keshav Clothing's.
  final OrganizationMockDataSource? organization;

  /// Company holidays, when shared with the holiday mock.
  final MockHolidayStore? holidays;

  /// When set, each employee's current-year overtime comes from the same
  /// attendance records the Attendance page shows.
  final AttendanceMockDataSource? attendance;

  static MockScheduleBook _seededBook(
    DateTime Function() now,
    List<EmployeeModel> employees,
  ) =>
      MockScheduleBook(now: now)
        ..seed([for (final e in employees) (id: e.id, joined: e.joiningDate)]);

  /// The employee as the API returns it: today's schedule, and this year's
  /// overtime for callers who may see overtime.
  EmployeeModel _withSchedule(EmployeeModel employee) => employee.copyWith(
    schedule: _schedules.on(employee.id, now()),
    overtimeMinutesThisYear: guard.has(AppPermission.overtimeView)
        ? _overtimeThisYear(employee.id)
        : null,
  );

  /// 1 January of the current year to today, from the attendance records.
  int? _overtimeThisYear(String employeeId) {
    final source = attendance;
    if (source == null) return null;
    final today = now().dateOnly;
    return source
        .recordsBetween(employeeId, DateTime(today.year), today)
        .fold<int>(0, (sum, r) => sum + (r.overtimeMinutes ?? 0));
  }

  static const String _defaultEcPrefix = 'KC';

  // (name, department, position, mobile, joined, active)
  static final List<(String, String, String, String, DateTime, bool)> _people =
      [
        (
          'Aarav Shah',
          'Graphic Designer',
          'Graphic Designer',
          '9825011234',
          DateTime(2021, 1, 12),
          true,
        ),
        (
          'Priya Desai',
          'Tailor',
          'Tailor',
          '9879520417',
          DateTime(2021, 6, 3),
          true,
        ),
        (
          'Rohan Patel',
          'Graphic Designer',
          'Graphic Designer',
          '9909044120',
          DateTime(2022, 11, 18),
          true,
        ),
        (
          'Kavya Mehta',
          'Accountant',
          'Accountant',
          '9727730981',
          DateTime(2023, 3, 9),
          true,
        ),
        (
          'Harsh Vaghela',
          'Graphic Designer',
          'Graphic Designer',
          '9099081264',
          DateTime(2023, 5, 22),
          true,
        ),
        (
          'Meera Rathod',
          'Accountant',
          'Accountant',
          '9898056310',
          DateTime(2023, 8, 1),
          true,
        ),
        (
          'Arjun Joshi',
          'Tailor',
          'Tailor',
          '9327011845',
          DateTime(2023, 12, 14),
          true,
        ),
        (
          'Dhruv Parmar',
          'Graphic Designer',
          'Tailor',
          '9714062209',
          DateTime(2024, 2, 5),
          true,
        ),
        (
          'Nisha Solanki',
          'Accountant',
          'Accountant',
          '9824177053',
          DateTime(2024, 6, 17),
          true,
        ),
        (
          'Sanjay Makwana',
          'Accountant',
          'Accountant',
          '9662048117',
          DateTime(2024, 9, 2),
          true,
        ),
        (
          'Ishaan Trivedi',
          'Graphic Designer',
          'Graphic Designer',
          '9825502211',
          DateTime(2022, 4, 11),
          true,
        ),
        (
          'Ananya Bhatt',
          'Graphic Designer',
          'Tailor',
          '9978812345',
          DateTime(2022, 7, 25),
          true,
        ),
        (
          'Vivek Chauhan',
          'Tailor',
          'Tailor',
          '9426055123',
          DateTime(2020, 10, 5),
          true,
        ),
        (
          'Riya Pandya',
          'Accountant',
          'Accountant',
          '9737011122',
          DateTime(2021, 12, 1),
          true,
        ),
        (
          'Karan Thakkar',
          'Graphic Designer',
          'Graphic Designer',
          '9898765432',
          DateTime(2024, 1, 15),
          true,
        ),
        (
          'Pooja Jadeja',
          'Accountant',
          'Accountant',
          '9510022334',
          DateTime(2025, 3, 3),
          true,
        ),
        (
          'Manav Dave',
          'Tailor',
          'Tailor',
          '9624412233',
          DateTime(2025, 6, 9),
          true,
        ),
        (
          'Sneha Raval',
          'Graphic Designer',
          'Graphic Designer',
          '9909911223',
          DateTime(2019, 8, 19),
          true,
        ),
        (
          'Yash Gohil',
          'Tailor',
          'Tailor',
          '9825133221',
          DateTime(2025, 9, 1),
          true,
        ),
        (
          'Tanvi Oza',
          'Accountant',
          'Accountant',
          '9879001122',
          DateTime(2022, 2, 14),
          false,
        ),
        (
          'Nirav Shukla',
          'Graphic Designer',
          'Graphic Designer',
          '9428011233',
          DateTime(2020, 5, 4),
          false,
        ),
        (
          'Hetal Vyas',
          'Graphic Designer',
          'Tailor',
          '9537744556',
          DateTime(2021, 9, 20),
          false,
        ),
      ];

  static const List<AttendanceDayStatus> _todayCycle = [
    AttendanceDayStatus.present,
    AttendanceDayStatus.present,
    AttendanceDayStatus.absent,
    AttendanceDayStatus.present,
    AttendanceDayStatus.onLeave,
    AttendanceDayStatus.present,
    AttendanceDayStatus.late,
    AttendanceDayStatus.halfDay,
  ];

  /// The sample employees, also used by other dev mocks (attendance) so
  /// they show the same people.
  static List<EmployeeModel> seed(DateTime today) => [
    for (var i = 0; i < _people.length; i++)
      _build(
        organizationId: MockSession.keshavId,
        id: '${i + 1}',
        ecNumber: '$_defaultEcPrefix${1001 + i * 3}',
        person: _people[i],
        today: _people[i].$6 ? _todayCycle[i % _todayCycle.length] : null,
        updatedAt: today.subtract(Duration(days: 10 + i)),
      ),
  ];

  /// The second sample organization's employees (Sunrise Garments), with
  /// their own ids, so one organization's ids never match the other's.
  ///
  static List<EmployeeModel> seedSunrise(DateTime today) => [
    for (var i = 0; i < _sunrisePeople.length; i++)
      _build(
        organizationId: MockSession.sunriseId,
        id: 's${i + 1}',
        ecNumber: 'SG${101 + i}',
        person: _sunrisePeople[i],
        today: _sunrisePeople[i].$6
            ? _todayCycle[i % _todayCycle.length]
            : null,
        updatedAt: today.subtract(Duration(days: 4 + i)),
      ),
  ];

  static final List<(String, String, String, String, DateTime, bool)>
  _sunrisePeople = [
    (
      'Ravi Mehta',
      'Accounts',
      'Accountant',
      '9824012345',
      DateTime(2022, 6, 1),
      true,
    ),
    (
      'Farah Khan',
      'Stitching',
      'Tailor',
      '9879023456',
      DateTime(2023, 2, 13),
      true,
    ),
    (
      'Dev Malhotra',
      'Stitching',
      'Tailor',
      '9909034567',
      DateTime(2024, 1, 8),
      true,
    ),
    (
      'Isha Kapoor',
      'Design',
      'Designer',
      '9725045678',
      DateTime(2025, 3, 3),
      true,
    ),
    (
      'Mohit Sharma',
      'Stitching',
      'Tailor',
      '9638056789',
      DateTime(2021, 11, 22),
      false,
    ),
  ];

  static EmployeeModel _build({
    required String organizationId,
    required String id,
    required String ecNumber,
    required (String, String, String, String, DateTime, bool) person,
    AttendanceDayStatus? today,
    DateTime? updatedAt,
  }) {
    final (name, department, position, mobile, joined, active) = person;
    return EmployeeModel(
      id: id,
      ecNumber: ecNumber,
      name: name,
      mobile: mobile,
      department: MockCatalogs.ref(
        organizationId,
        CatalogKind.departments,
        department,
      ),
      position: MockCatalogs.ref(
        organizationId,
        CatalogKind.positions,
        position,
      ),
      joiningDate: joined,
      status: active ? EmployeeStatus.active : EmployeeStatus.inactive,
      todayStatus: today,
      updatedAt: updatedAt,
      updatedBy: 'Admin',
    );
  }

  /// The organization's department or position [id]: it must be one of
  /// its own, and active unless the employee already has it.
  NamedRef _choice(CatalogKind kind, String id, {NamedRef? current}) {
    final field = kind == CatalogKind.departments
        ? 'departmentId'
        : 'positionId';
    final label = kind.singular.toLowerCase();
    final organization = this.organization;
    final ref = organization != null
        ? organization.refOf(kind, id)
        : MockCatalogs.of(MockSession.keshavId, kind)
              .where((i) => i.id == id)
              .map((i) => NamedRef(id: i.id, name: i.name))
              .firstOrNull;
    final usable =
        ref != null &&
        (current?.id == id || (organization?.isActive(kind, id) ?? true));
    if (!usable) {
      throw ValidationException(
        'Choose a $label',
        fieldErrors: {field: 'Choose a $label'},
      );
    }
    return ref;
  }

  /// Letters every EC number starts with (the organization's setting).
  String get _ecPrefix =>
      organization?.currentSettings.ecNumberPrefix ?? _defaultEcPrefix;

  /// Mobile numbers without a country code are read in this country.
  String get _phoneCountry =>
      organization?.currentSettings.defaultCountry ?? PhoneUtils.defaultCountry;

  /// [mobile] as stored: international (`+919825011234`).
  String _storedMobile(String mobile) =>
      PhoneUtils.toStored(mobile, country: _phoneCountry) ?? mobile;

  Future<void> _wait() => Future<void>.delayed(latency);

  EmployeeModel _find(String id) {
    final employee = _employees.where((e) => e.id == id).firstOrNull;
    if (employee == null) {
      throw const NotFoundException('This employee could not be found.');
    }
    return employee;
  }

  /// Rejects duplicate EC numbers, like a real server would.
  void _checkUnique(EmployeeFormData data, {String? exceptId}) {
    final others = _employees.where((e) => e.id != exceptId);
    final format = RegExp('^${RegExp.escape(_ecPrefix)}\\d+\$');
    final errors = <String, String>{
      if (!format.hasMatch(data.ecNumber))
        'ecNumber': 'Use $_ecPrefix followed by numbers, e.g. ${_ecPrefix}1001'
      else if (others.any((e) => e.ecNumber == data.ecNumber))
        'ecNumber': 'This EC number is already in use',
      'mobile': ?PhoneUtils.validate(data.mobile, country: _phoneCountry),
    };
    if (errors.isNotEmpty) {
      throw ValidationException(errors.values.first, fieldErrors: errors);
    }
  }

  @override
  Future<EmployeeListModel> list(EmployeeQuery query) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    final search = query.search.trim().toLowerCase();
    final joinedFrom = query.joinedFrom;
    final joinedTo = query.joinedTo;
    final filtered = _employees
        .where(
          (e) =>
              search.isEmpty ||
              e.name.toLowerCase().contains(search) ||
              e.ecNumber.toLowerCase().contains(search),
        )
        .where(
          (e) =>
              query.departmentId == null ||
              e.department.id == query.departmentId,
        )
        .where(
          (e) => query.positionId == null || e.position.id == query.positionId,
        )
        .where(
          (e) =>
              (joinedFrom == null || !e.joiningDate.isBefore(joinedFrom)) &&
              (joinedTo == null || !e.joiningDate.isAfter(joinedTo)),
        )
        .toList();
    final matches =
        filtered
            .where((e) => query.status == null || e.status == query.status)
            .toList()
          ..sort((a, b) => a.ecNumber.compareTo(b.ecNumber));

    final start = math.min((query.page - 1) * query.pageSize, matches.length);
    final end = math.min(start + query.pageSize, matches.length);
    return EmployeeListModel(
      items: matches.sublist(start, end).map(_withSchedule).toList(),
      total: matches.length,
      page: query.page,
      pageSize: query.pageSize,
      counts: EmployeeStatusCounts(
        active: filtered.where((e) => e.status == EmployeeStatus.active).length,
        inactive: filtered
            .where((e) => e.status == EmployeeStatus.inactive)
            .length,
      ),
    );
  }

  @override
  Future<EmployeeModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    return _withSchedule(_find(id));
  }

  @override
  Future<String> nextEcNumber() async {
    await _wait();
    guard.require(AppPermission.employeeView);
    final highest = _employees
        .map((e) => int.tryParse(e.ecNumber.substring(_ecPrefix.length)) ?? 0)
        .fold(0, math.max);
    return '$_ecPrefix${highest + 1}';
  }

  @override
  Future<EmployeeModel> create(EmployeeFormData data) async {
    await _wait();
    guard.require(AppPermission.employeeCreate);
    _checkUnique(data);
    final schedule = data.schedule;
    if (schedule == null) {
      throw const ValidationException(
        'Set the working schedule',
        fieldErrors: {'schedule': 'Set the working schedule'},
      );
    }
    final problems = scheduleProblems(schedule);
    if (problems.isNotEmpty) {
      throw ValidationException(
        problems.values.first,
        fieldErrors: {
          for (final MapEntry(:key, :value) in problems.entries)
            'schedule.$key': value,
        },
      );
    }
    final employee = EmployeeModel(
      id: '${_employees.length + 1}',
      ecNumber: data.ecNumber,
      name: data.name,
      mobile: _storedMobile(data.mobile),
      department: _choice(CatalogKind.departments, data.departmentId),
      position: _choice(CatalogKind.positions, data.positionId),
      joiningDate: data.joiningDate,
      status: data.status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees.add(employee);
    _schedules.add(employee.id, schedule);
    return _withSchedule(employee);
  }

  @override
  Future<EmployeeModel> update(String id, EmployeeFormData data) async {
    await _wait();
    guard.require(AppPermission.employeeEdit);
    final current = _find(id);
    _checkUnique(data, exceptId: id);
    final updated = current.copyWith(
      ecNumber: data.ecNumber,
      name: data.name,
      mobile: _storedMobile(data.mobile),
      department: _choice(
        CatalogKind.departments,
        data.departmentId,
        current: current.department,
      ),
      position: _choice(
        CatalogKind.positions,
        data.positionId,
        current: current.position,
      ),
      joiningDate: data.joiningDate,
      status: data.status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees[_employees.indexOf(current)] = updated;
    return _withSchedule(updated);
  }

  @override
  Future<EmployeeModel> setStatus(String id, EmployeeStatus status) async {
    await _wait();
    guard.require(AppPermission.employeeDeactivate);
    final current = _find(id);
    final updated = current.copyWith(
      status: status,
      updatedAt: now(),
      updatedBy: 'Admin',
    );
    _employees[_employees.indexOf(current)] = updated;
    return _withSchedule(updated);
  }

  @override
  Future<LeaveBalanceModel> leaveBalance(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    final employee = _find(id);
    final source = leaves;
    if (source != null) return source.balance(id);
    // Without the leave mock: earned since January (no leave taken).
    final today = now().dateOnly;
    final accrued = LeaveMockDataSource.accrual.accruedThrough(
      employee.joiningDate,
      today,
    );
    return LeaveBalanceModel(
      asOf: today,
      accrued: accrued,
      used: 0,
      remaining: accrued,
    );
  }

  @override
  Future<List<LeaveHistoryItemModel>> leaveHistory(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    _find(id);
    final source = leaves;
    if (source != null) return source.history(id);
    final year = now().year;
    LeaveHistoryItemModel item(
      int n,
      DateTime start,
      DateTime end,
      String type,
      double days,
      String reason,
    ) => LeaveHistoryItemModel(
      id: '$id-$n',
      startDate: start,
      endDate: end,
      leaveType: type,
      days: days,
      reason: reason,
      status: LeaveStatus.approved,
      isPaid: type != 'Unpaid',
    );
    return [
      item(
        1,
        DateTime(year, 9, 21),
        DateTime(year, 9, 22),
        'Casual',
        2,
        'Family function',
      ),
      item(
        2,
        DateTime(year, 8, 11),
        DateTime(year, 8, 11),
        'Casual',
        1,
        'Personal work',
      ),
      item(
        3,
        DateTime(year, 7, 4),
        DateTime(year, 7, 4),
        'Casual',
        1,
        'Medical',
      ),
      item(
        4,
        DateTime(year, 5, 14),
        DateTime(year, 5, 15),
        'Unpaid',
        2,
        'Travel',
      ),
      item(
        5,
        DateTime(year, 3, 2),
        DateTime(year, 3, 3),
        'Casual',
        2,
        'Family function',
      ),
      item(
        6,
        DateTime(year, 2, 16),
        DateTime(year, 2, 16),
        'Casual',
        1,
        'Medical',
      ),
    ];
  }

  @override
  Future<List<WorkScheduleModel>> schedules(String id) async {
    await _wait();
    guard.require(AppPermission.employeeView);
    _find(id);
    return _schedules.versions(id);
  }

  @override
  Future<WorkScheduleModel> addSchedule(
    String id,
    WorkScheduleInput input,
  ) async {
    await _wait();
    guard.require(AppPermission.scheduleEdit);
    _find(id);
    return _schedules.add(id, input);
  }
}

/// DEV ONLY: the active organization's sample employees, shared by the
/// employee, attendance and leave mocks, so changes in one show up in the
/// others.
final mockEmployeeStoreProvider = Provider<List<EmployeeModel>>(
  (ref) => ref.watch(mockActiveTenantProvider).employees,
);
