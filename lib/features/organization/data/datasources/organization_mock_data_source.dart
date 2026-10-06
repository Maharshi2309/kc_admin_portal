import 'dart:convert';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_catalogs.dart';
import 'package:kc_admin_portal/shared/mock/mock_directory.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): one organization's profile, settings,
/// departments and positions, playing the backend
/// (docs/ARCHITECTURE_MULTI_ORG.md §F). Reading needs any member; changes
/// need `settings.manage`.
class OrganizationMockDataSource implements OrganizationRemoteDataSource {
  OrganizationMockDataSource({
    required this.organizationId,
    required this.directory,
    required this._employees,
    DateTime Function()? now,
    this.guard = const MockGuard.allowAll(),
    this.latency = Duration.zero,
  }) : _settings = MockCatalogs.settings(organizationId),
       _leavePolicy = MockCatalogs.leavePolicy(
         organizationId,
         now: (now ?? DateTime.now)(),
         paidLeave: directory.paidLeaveFor(organizationId),
       ),
       _lists = {
         for (final kind in CatalogKind.values)
           kind: MockCatalogs.of(organizationId, kind),
       };

  final String organizationId;
  final MockDirectory directory;
  final MockGuard guard;
  final Duration latency;
  final List<EmployeeModel> _employees;
  OrganizationSettingsModel _settings;
  LeavePolicyModel _leavePolicy;
  final Map<CatalogKind, List<CatalogItemModel>> _lists;
  int _nextId = 1;

  static const int nameMaxLength = 60;

  Future<void> _wait() => Future<void>.delayed(latency);

  /// The current settings, for the other mocks (EC numbers, lateness,
  /// default schedule).
  OrganizationSettingsModel get currentSettings => _settings;

  /// The current leave policy, for the leave mock.
  LeavePolicyModel get currentLeavePolicy => _leavePolicy;

  /// A department or position by id, active or not; null if it isn't this
  /// organization's.
  NamedRef? refOf(CatalogKind kind, String id) {
    final item = _lists[kind]!.where((i) => i.id == id).firstOrNull;
    return item == null ? null : NamedRef(id: item.id, name: item.name);
  }

  /// Whether [id] may be given to an employee now (active).
  bool isActive(CatalogKind kind, String id) =>
      _lists[kind]!.any((i) => i.id == id && i.isActive);

  int _countOf(CatalogKind kind, String id) => _employees
      .where(
        (e) =>
            (kind == CatalogKind.departments ? e.department : e.position).id ==
            id,
      )
      .length;

  CatalogItemModel _withCount(CatalogKind kind, CatalogItemModel item) =>
      item.copyWith(employeeCount: _countOf(kind, item.id));

  // Profile

  OrganizationModel get _profile => directory.organization(organizationId)!;

  void _replaceProfile(OrganizationModel updated) {
    final index = directory.organizations.indexWhere(
      (o) => o.id == organizationId,
    );
    directory.organizations[index] = updated;
  }

  @override
  Future<OrganizationModel> profile() async {
    await _wait();
    guard.signedIn();
    return _profile;
  }

  @override
  Future<OrganizationModel> updateProfile({
    required String name,
    required String timezone,
  }) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    final trimmed = name.trim();
    final errors = {
      if (trimmed.isEmpty) 'name': 'Enter the organization name',
      if (trimmed.length > MockDirectory.organizationNameMaxLength)
        'name':
            'Use at most ${MockDirectory.organizationNameMaxLength} '
            'characters',
      if (timezone.trim().isEmpty) 'timezone': 'Choose a time zone',
    };
    _throwIfAny(errors);
    final updated = _profile.copyWith(name: trimmed, timezone: timezone);
    _replaceProfile(updated);
    return updated;
  }

  @override
  Future<OrganizationModel> uploadLogo(List<int> bytes, String fileName) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    // Like the server: check the content, never the file name.
    final type = _imageType(bytes);
    if (type == null) {
      throw const ValidationException(
        'Use a PNG or JPEG image.',
        fieldErrors: {'logo': 'Use a PNG or JPEG image.'},
      );
    }
    if (bytes.length > maxLogoBytes) {
      throw const ValidationException(
        'The logo must be 1 MB or smaller.',
        fieldErrors: {'logo': 'The logo must be 1 MB or smaller.'},
      );
    }
    final updated = _profile.copyWith(
      logoUrl: 'data:$type;base64,${base64Encode(bytes)}',
    );
    _replaceProfile(updated);
    return updated;
  }

  /// `image/png` or `image/jpeg` from the file's first bytes.
  static String? _imageType(List<int> bytes) {
    const png = [0x89, 0x50, 0x4E, 0x47];
    const jpeg = [0xFF, 0xD8, 0xFF];
    bool startsWith(List<int> magic) =>
        bytes.length >= magic.length &&
        [for (var i = 0; i < magic.length; i++) bytes[i]].join() ==
            magic.join();
    if (startsWith(png)) return 'image/png';
    if (startsWith(jpeg)) return 'image/jpeg';
    return null;
  }

  @override
  Future<OrganizationModel> removeLogo() async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    final updated = _profile.copyWith(logoUrl: null);
    _replaceProfile(updated);
    return updated;
  }

  // Settings

  @override
  Future<OrganizationSettingsModel> settings() async {
    await _wait();
    guard.signedIn();
    return _settings;
  }

  static final RegExp _prefixPattern = RegExp(r'^[A-Za-z]{0,6}$');

  @override
  Future<OrganizationSettingsModel> updateSettings(
    OrganizationSettingsModel settings,
  ) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    final schedule = settings.defaultSchedule;
    final errors = {
      if (!_prefixPattern.hasMatch(settings.ecNumberPrefix.trim()))
        'ecNumberPrefix': 'Use up to 6 letters, e.g. KC',
      if (settings.lateGraceMinutes < 0 || settings.lateGraceMinutes > 120)
        'lateGraceMinutes': 'Use 0 to 120 minutes',
      if (schedule.endTime.compareTo(schedule.startTime) <= 0)
        'defaultSchedule.endTime': 'The end must be after the start',
      if (schedule.weeklyOffDays.length >= DateTime.daysPerWeek)
        'defaultSchedule.weeklyOffDays': 'Leave at least one working day',
    };
    _throwIfAny(errors);
    return _settings = settings.copyWith(
      ecNumberPrefix: settings.ecNumberPrefix.trim().toUpperCase(),
    );
  }

  // Leave policy

  @override
  Future<LeavePolicyModel> leavePolicy() async {
    await _wait();
    guard.signedIn();
    return _leavePolicy;
  }

  static const int _typeNameMaxLength = 40;
  static const double _maxDaysPerMonth = 5;
  static const double _maxCap = 365;

  @override
  Future<LeavePolicyModel> updateLeavePolicy(LeavePolicyModel policy) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    final paid = policy.paidLeaveName.trim();
    final unpaid = policy.unpaidLeaveName.trim();
    final perMonth = policy.daysPerMonth;
    final cap = policy.carryForwardCap;
    bool halfSteps(double value) => (value * 2) == (value * 2).roundToDouble();
    final errors = {
      if (paid.isEmpty || paid.length > _typeNameMaxLength)
        'paidLeaveName': 'Use 1 to $_typeNameMaxLength characters',
      if (unpaid.isEmpty || unpaid.length > _typeNameMaxLength)
        'unpaidLeaveName': 'Use 1 to $_typeNameMaxLength characters'
      else if (unpaid.toLowerCase() == paid.toLowerCase())
        'unpaidLeaveName': 'Use a different name from the paid leave',
      if (perMonth <= 0 || perMonth > _maxDaysPerMonth || !halfSteps(perMonth))
        'daysPerMonth': 'Use 0.5 to $_maxDaysPerMonth days, in half days',
      if (cap != null && (cap < perMonth || cap > _maxCap || !halfSteps(cap)))
        'carryForwardCap':
            'Use at least the days earned in a month, up to $_maxCap',
      if (policy.accrualStartMonth.day != 1)
        'accrualStartMonth': 'Choose a month',
    };
    _throwIfAny(errors);
    return _leavePolicy = policy.copyWith(
      paidLeaveName: paid,
      unpaidLeaveName: unpaid,
    );
  }

  // Departments and positions

  @override
  Future<List<CatalogItemModel>> catalog(CatalogKind kind) async {
    await _wait();
    guard.signedIn();
    return [
      for (final item in _lists[kind]!..sort(_byName)) _withCount(kind, item),
    ];
  }

  static int _byName(CatalogItemModel a, CatalogItemModel b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  String? _nameProblem(CatalogKind kind, String name, {String? exceptId}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Enter a name';
    if (trimmed.length > nameMaxLength) {
      return 'Use at most $nameMaxLength characters';
    }
    final taken = _lists[kind]!.any(
      (i) => i.id != exceptId && i.name.toLowerCase() == trimmed.toLowerCase(),
    );
    return taken ? '${kind.singular} "$trimmed" already exists' : null;
  }

  @override
  Future<CatalogItemModel> addCatalogItem(CatalogKind kind, String name) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    _throwIfAny({'name': ?_nameProblem(kind, name)});
    final item = CatalogItemModel(
      id: '$organizationId-${kind.name}-${_nextId++}',
      name: name.trim(),
    );
    _lists[kind]!.add(item);
    return item;
  }

  @override
  Future<CatalogItemModel> updateCatalogItem(
    CatalogKind kind,
    String id, {
    String? name,
    bool? isActive,
  }) async {
    await _wait();
    guard.require(AppPermission.settingsManage);
    final list = _lists[kind]!;
    final index = list.indexWhere((i) => i.id == id);
    if (index < 0) {
      throw NotFoundException(
        'This ${kind.singular.toLowerCase()} was not found.',
      );
    }
    if (name != null) {
      _throwIfAny({'name': ?_nameProblem(kind, name, exceptId: id)});
    }
    final updated = list[index].copyWith(
      name: name?.trim() ?? list[index].name,
      isActive: isActive ?? list[index].isActive,
    );
    list[index] = updated;
    // Like the server: employees show the new name everywhere.
    if (name != null) _renameOnEmployees(kind, updated);
    return _withCount(kind, updated);
  }

  void _renameOnEmployees(CatalogKind kind, CatalogItemModel item) {
    final ref = NamedRef(id: item.id, name: item.name);
    for (var i = 0; i < _employees.length; i++) {
      final e = _employees[i];
      if (kind == CatalogKind.departments && e.department.id == item.id) {
        _employees[i] = e.copyWith(department: ref);
      } else if (kind == CatalogKind.positions && e.position.id == item.id) {
        _employees[i] = e.copyWith(position: ref);
      }
    }
  }

  static void _throwIfAny(Map<String, String> errors) {
    if (errors.isEmpty) return;
    throw ValidationException(errors.values.first, fieldErrors: errors);
  }
}
