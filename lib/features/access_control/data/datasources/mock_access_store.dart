import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_permission_catalogue.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): staff users and their own permissions,
/// playing the backend (docs/DATABASE_V2.md §2.4 and §4.3): unique emails,
/// one user per employee, and never leaving nobody able to manage users and
/// permissions.
class MockAccessStore {
  MockAccessStore({
    this._employees = const [],
    DateTime Function()? now,
    this._currentUserId = defaultCurrentUserId,
  }) : _now = now ?? DateTime.now {
    final today = _now();
    _users.addAll([
      _user(
        'u1',
        'Admin',
        'admin@keshav.in',
        _all,
        lastSignIn: today.subtract(const Duration(hours: 2)),
      ),
      _user(
        'u2',
        'Mansi Rao',
        'mansi.rao@keshav.in',
        _all,
        lastSignIn: today.subtract(const Duration(days: 3)),
      ),
      _user(
        'u3',
        'Nisha Solanki',
        'nisha.solanki@keshav.in',
        _hr,
        employeeName: 'Nisha Solanki',
        lastSignIn: today.subtract(const Duration(days: 1)),
      ),
      _user('u4', 'Kunal Desai', 'kunal.desai@keshav.in', _hr),
      _user(
        'u5',
        'Arjun Joshi',
        'arjun.joshi@keshav.in',
        _attendanceDesk,
        employeeName: 'Arjun Joshi',
        lastSignIn: today.subtract(const Duration(days: 9)),
      ),
    ]);
  }

  /// Signed in before the dev login runs (and in tests that skip it): the
  /// dev admin, who has every permission.
  static const String defaultCurrentUserId = 'u1';

  static final List<String> _all = [
    for (final p in AppPermission.values) p.key,
  ];

  static final List<String> _hr = _keys(const [
    AppPermission.dashboardView,
    AppPermission.employeeView,
    AppPermission.employeeCreate,
    AppPermission.employeeEdit,
    AppPermission.scheduleEdit,
    AppPermission.attendanceView,
    AppPermission.overtimeView,
    AppPermission.leaveView,
    AppPermission.leaveCreate,
    AppPermission.leaveEdit,
    AppPermission.leaveCancel,
    AppPermission.leaveApprove,
    AppPermission.calendarView,
    AppPermission.holidayView,
    AppPermission.holidayCreate,
    AppPermission.holidayEdit,
  ]);

  static final List<String> _attendanceDesk = _keys(const [
    AppPermission.dashboardView,
    AppPermission.employeeView,
    AppPermission.attendanceView,
    AppPermission.attendancePunch,
    AppPermission.attendanceCorrect,
    AppPermission.leaveView,
    AppPermission.calendarView,
    AppPermission.holidayView,
  ]);

  /// The signed-in mock user, for permission checks and "your own access"
  /// rules; null when signed out.
  String? get currentUserId => _currentUserId;
  String? _currentUserId;

  final List<EmployeeModel> _employees;
  final DateTime Function() _now;
  final List<UserAccountModel> _users = [];
  int _nextId = 1;

  static List<String> _keys(List<AppPermission> permissions) => [
    for (final p in permissions) p.key,
  ];

  UserAccountModel _user(
    String id,
    String name,
    String email,
    List<String> permissions, {
    String? employeeName,
    DateTime? lastSignIn,
  }) => UserAccountModel(
    id: id,
    name: name,
    email: email,
    permissions: permissions,
    employee: employeeName == null
        ? null
        : _employees
              .where((e) => e.name == employeeName)
              .map(_summary)
              .firstOrNull,
    lastSignInAt: lastSignIn,
  );

  static EmployeeSummaryModel _summary(EmployeeModel e) => EmployeeSummaryModel(
    id: e.id,
    name: e.name,
    ecNumber: e.ecNumber,
    department: e.department.name,
    designation: e.designation.name,
  );

  List<UserAccountModel> get users => List.unmodifiable(_users);

  // Permissions

  List<PermissionModuleModel> catalogue() => mockPermissionCatalogue;

  static final Set<String> _knownKeys = {
    for (final module in mockPermissionCatalogue)
      for (final p in module.permissions) p.key,
  };

  static final String _manage = AppPermission.permissionManage.key;

  /// `PUT /users/{id}/permissions`: replaces the user's permissions.
  UserAccountModel setPermissions(String userId, List<String> keys) {
    final current = user(userId);
    _knownOnly(keys);
    final next = current.copyWith(permissions: keys.toSet().toList());
    if (current.permissions.contains(_manage) && !keys.contains(_manage)) {
      if (userId == currentUserId) {
        throw const ValidationException(
          'You cannot remove "Manage users and permissions" from yourself.',
          code: ApiConstants.cannotChangeOwnAccessCode,
        );
      }
      _keepsAPermissionManager(_replaced(userId, next));
    }
    _users[_users.indexWhere((u) => u.id == userId)] = next;
    return next;
  }

  static void _knownOnly(List<String> keys) {
    final unknown = keys.where((k) => !_knownKeys.contains(k)).toList();
    if (unknown.isNotEmpty) {
      throw ValidationException('Unknown permission: ${unknown.join(', ')}');
    }
  }

  /// At least one active user must keep `permission.manage` (§4.3).
  static void _keepsAPermissionManager(List<UserAccountModel> users) {
    final anyLeft = users.any(
      (u) => u.isActive && u.permissions.contains(_manage),
    );
    if (!anyLeft) {
      throw const ValidationException(
        'Nobody else could manage users and permissions after this change.',
        code: ApiConstants.lastPermissionManagerCode,
      );
    }
  }

  List<UserAccountModel> _replaced(String id, UserAccountModel updated) => [
    for (final u in _users) u.id == id ? updated : u,
  ];

  // Session (the dev login)

  /// The user with [email], active or not, ignoring case.
  UserAccountModel? userByEmail(String email) {
    final wanted = email.trim().toLowerCase();
    return _users.where((u) => u.email.toLowerCase() == wanted).firstOrNull;
  }

  /// Starts a session for [userId] and records the sign-in time.
  void signIn(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    _users[index] = _users[index].copyWith(lastSignInAt: _now());
    _currentUserId = userId;
  }

  /// Picks up a session restored from a saved token, without counting it as
  /// a new sign-in.
  void resume(String userId) => _currentUserId = user(userId).id;

  void signOut() => _currentUserId = null;

  /// Why the current session is no longer valid, or null if it is (§4.2:
  /// signed out, or the user deactivated).
  String? sessionProblem() {
    final own = _own;
    if (own == null) return 'Please sign in.';
    if (!own.isActive) return 'Your account has been deactivated.';
    return null;
  }

  /// The permission keys [userId] holds now.
  List<String> permissionsOf(String userId) => user(userId).permissions;

  // Users

  UserAccountModel? get _own =>
      _users.where((u) => u.id == currentUserId).firstOrNull;

  /// `GET /users`: by name; search on name and email.
  UserAccountListModel listUsers(UserQuery query) {
    final search = query.search.trim().toLowerCase();
    final matching =
        _users
            .where(
              (u) =>
                  search.isEmpty ||
                  u.name.toLowerCase().contains(search) ||
                  u.email.toLowerCase().contains(search),
            )
            .toList()
          ..sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
    final start = (query.page - 1) * query.pageSize;
    return UserAccountListModel(
      items: matching.skip(start).take(query.pageSize).toList(),
      total: matching.length,
      page: query.page,
      pageSize: query.pageSize,
    );
  }

  UserAccountModel user(String id) {
    final found = _users.where((u) => u.id == id).firstOrNull;
    if (found == null) {
      throw const NotFoundException('This user was not found.');
    }
    return found;
  }

  UserAccountModel createUser(UserAccountInput input) {
    _throwIfAny(
      _userProblems(
        name: input.name,
        email: input.email,
        employeeId: input.employeeId,
      ),
    );
    _knownOnly(input.permissions);
    final created = UserAccountModel(
      id: 'u${100 + _nextId++}',
      name: input.name.trim(),
      email: input.email.trim().toLowerCase(),
      permissions: input.permissions.toSet().toList(),
      employee: _employeeSummary(input.employeeId),
    );
    _users.add(created);
    return created;
  }

  UserAccountModel updateUser(String id, UserAccountUpdate input) {
    final current = user(id);
    _throwIfAny(
      _userProblems(
        name: input.name,
        email: input.email,
        employeeId: input.employeeId,
        exceptUserId: id,
      ),
    );
    final active = input.isActive ?? current.isActive;
    final updated = current.copyWith(
      name: input.name.trim(),
      email: input.email.trim().toLowerCase(),
      employee: _employeeSummary(input.employeeId),
      isActive: active,
    );
    if (current.isActive && !active) {
      if (id == currentUserId) {
        throw const ValidationException(
          'You cannot deactivate your own account.',
          code: ApiConstants.cannotChangeOwnAccessCode,
        );
      }
      _keepsAPermissionManager(_replaced(id, updated));
    }
    _users[_users.indexWhere((u) => u.id == id)] = updated;
    return updated;
  }

  EmployeeSummaryModel? _employeeSummary(String? employeeId) =>
      employeeId == null
      ? null
      : _employees.where((e) => e.id == employeeId).map(_summary).firstOrNull;

  Map<String, String> _userProblems({
    required String name,
    required String email,
    required String? employeeId,
    String? exceptUserId,
  }) {
    final trimmedEmail = email.trim().toLowerCase();
    final emailOwner = _users
        .where(
          (u) => u.id != exceptUserId && u.email.toLowerCase() == trimmedEmail,
        )
        .firstOrNull;
    final linkedTo = employeeId == null
        ? null
        : _users
              .where(
                (u) => u.id != exceptUserId && u.employee?.id == employeeId,
              )
              .firstOrNull;
    return {
      if (name.trim().isEmpty) 'name': 'Enter a name',
      if (trimmedEmail.isEmpty)
        'email': 'Enter an email address'
      else if (!_emailPattern.hasMatch(trimmedEmail))
        'email': 'Enter a valid email address'
      else if (emailOwner != null)
        'email': 'Already used by ${emailOwner.name}',
      if (employeeId != null && _employeeSummary(employeeId) == null)
        'employeeId': 'This employee was not found'
      else if (linkedTo != null)
        'employeeId': 'Already linked to ${linkedTo.name}',
    };
  }

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static void _throwIfAny(Map<String, String> errors) {
    if (errors.isEmpty) return;
    throw ValidationException(errors.values.first, fieldErrors: errors);
  }
}

/// DEV ONLY: the staff users shared by the access and user mocks.
final mockAccessStoreProvider = Provider<MockAccessStore>(
  (ref) => MockAccessStore(
    employees: ref.watch(mockEmployeeStoreProvider),
    now: ref.watch(clockProvider),
  ),
);
