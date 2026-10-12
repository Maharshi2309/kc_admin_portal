import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_mock_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_mock_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';

import '../../helpers/fake_dashboard.dart';

Matcher _failsWith(String code) =>
    throwsA(isA<ValidationException>().having((e) => e.code, 'code', code));

Matcher _fieldError(String field, Object message) => throwsA(
  isA<ValidationException>().having(
    (e) => e.fieldErrors[field],
    '$field error',
    message,
  ),
);

final String _manage = AppPermission.permissionManage.key;

void main() {
  final employees = EmployeeMockDataSource.seed(testNow);
  late MockAccessStore store;
  late AccessMockDataSource access;
  late UserMockDataSource users;

  void open({String currentUserId = MockAccessStore.defaultCurrentUserId}) {
    store = MockAccessStore(
      employees: employees,
      now: () => testNow,
      currentUserId: currentUserId,
    );
    access = AccessMockDataSource(store: store);
    users = UserMockDataSource(store: store);
  }

  setUp(open);

  UserAccountUpdate same(UserAccountModel u, {bool? isActive}) =>
      UserAccountUpdate(
        name: u.name,
        email: u.email,
        employeeId: u.employee?.id,
        isActive: isActive,
      );

  group('permissions (mock)', () {
    test('the catalogue covers every permission the app knows', () async {
      final keys = {
        for (final m in await access.permissions())
          for (final p in m.permissions) p.key,
      };
      expect(keys, {for (final p in AppPermission.values) p.key});
    });

    test("replaces a user's own permissions", () async {
      final saved = await users.setPermissions('u5', [
        'dashboard.view',
        'attendance.view',
        'attendance.view', // duplicates are ignored
      ]);
      expect(
        saved.permissions,
        unorderedEquals(['dashboard.view', 'attendance.view']),
      );
      expect((await users.getById('u5')).permissions, hasLength(2));
      // Others are untouched: no roles shared between people.
      expect((await users.getById('u4')).permissions, isNot(hasLength(2)));
    });

    test('refuses unknown keys', () async {
      await expectLater(
        users.setPermissions('u4', ['employee.fly']),
        throwsA(isA<ValidationException>()),
      );
    });

    test("can't take Manage users and permissions from yourself", () async {
      final mine = (await users.getById('u1')).permissions;
      await expectLater(
        users.setPermissions('u1', [
          for (final k in mine)
            if (k != _manage) k,
        ]),
        _failsWith(ApiConstants.cannotChangeOwnAccessCode),
      );
    });

    test('someone must always be able to manage permissions', () async {
      open(currentUserId: 'u3'); // limited access, so both admins can go
      await users.update('u2', same(store.user('u2'), isActive: false));
      await expectLater(
        users.update('u1', same(store.user('u1'), isActive: false)),
        _failsWith(ApiConstants.lastPermissionManagerCode),
      );
      await expectLater(
        users.setPermissions('u1', const ['dashboard.view']),
        _failsWith(ApiConstants.lastPermissionManagerCode),
      );
    });
  });

  group('users (mock)', () {
    test('lists by name, with search and pages', () async {
      final all = await users.list(const UserQuery());
      expect(all.items.map((u) => u.name), [
        'Admin',
        'Arjun Joshi',
        'Kunal Desai',
        'Mansi Rao',
        'Nisha Solanki',
      ]);
      expect(all.items[4].employee?.name, 'Nisha Solanki');
      expect(all.items[2].employee, isNull);
      expect(
        all.items.first.permissions,
        hasLength(AppPermission.values.length),
      );
      expect((await users.list(const UserQuery(search: 'nisha'))).total, 1);
      final second = await users.list(const UserQuery(page: 2, pageSize: 2));
      expect(second.items.map((u) => u.name), ['Kunal Desai', 'Mansi Rao']);
    });

    test('adds a user, with no permissions unless given', () async {
      final meera = employees.firstWhere((e) => e.name == 'Meera Rathod');
      final added = await users.create(
        UserAccountInput(
          name: ' Meera Rathod ',
          email: ' Meera.Rathod@Keshav.in ',
          password: 'meera-pass',
          employeeId: meera.id,
        ),
      );
      expect(added.name, 'Meera Rathod');
      expect(added.email, 'meera.rathod@keshav.in');
      expect(added.permissions, isEmpty);
      expect(added.employee?.ecNumber, meera.ecNumber);

      final withAccess = await users.create(
        const UserAccountInput(
          name: 'Ravi',
          email: 'ravi@keshav.in',
          password: 'ravi-pass',
          permissions: ['leave.view'],
        ),
      );
      expect(withAccess.permissions, ['leave.view']);
    });

    test('emails are unique; an employee links to one user', () async {
      await expectLater(
        users.create(
          const UserAccountInput(
            name: 'X',
            email: 'ADMIN@keshav.in',
            password: 'password1',
          ),
        ),
        _fieldError('email', 'Already used by Admin'),
      );
      await expectLater(
        users.create(
          const UserAccountInput(name: 'X', email: 'x@', password: 'password1'),
        ),
        _fieldError('email', 'Enter a valid email address'),
      );
      final nisha = (await users.getById('u3')).employee!;
      await expectLater(
        users.create(
          UserAccountInput(
            name: 'X',
            email: 'x@keshav.in',
            password: 'password1',
            employeeId: nisha.id,
          ),
        ),
        _fieldError('employeeId', 'Already linked to Nisha Solanki'),
      );
    });

    test('edits and unlinks the employee', () async {
      final updated = await users.update(
        'u3',
        const UserAccountUpdate(
          name: 'Nisha S.',
          email: 'nisha.solanki@keshav.in',
        ),
      );
      expect(updated.name, 'Nisha S.');
      expect(updated.employee, isNull);
      expect(updated.permissions, isNotEmpty); // unchanged
    });

    test("can't deactivate yourself; others can be", () async {
      await expectLater(
        users.update('u1', same(store.user('u1'), isActive: false)),
        _failsWith(ApiConstants.cannotChangeOwnAccessCode),
      );
      final off = await users.update(
        'u5',
        same(store.user('u5'), isActive: false),
      );
      expect(off.isActive, isFalse);
      expect(off.employee?.name, 'Arjun Joshi');
    });

    test('a new user signs in with their own password', () async {
      final auth = AuthMockDataSource(store: store);
      await expectLater(
        users.create(
          const UserAccountInput(
            name: 'X',
            email: 'x@keshav.in',
            password: '123',
          ),
        ),
        _fieldError('password', 'Use at least 8 characters'),
      );
      final ravi = await users.create(
        const UserAccountInput(
          name: 'Ravi',
          email: 'ravi@keshav.in',
          password: 'ravi-pass',
          permissions: ['leave.view'],
        ),
      );

      await expectLater(
        auth.login(email: 'ravi@keshav.in', password: 'password'),
        throwsA(isA<UnauthorizedException>()),
      );
      final session = await auth.login(
        email: 'ravi@keshav.in',
        password: 'ravi-pass',
      );
      expect(session.user.permissions, ['leave.view']);

      open();
      await users.create(
        const UserAccountInput(
          name: 'Ravi',
          email: 'ravi@keshav.in',
          password: 'ravi-pass',
        ),
      );
      final id = store.userByEmail('ravi@keshav.in')!.id;
      await users.update(
        id,
        const UserAccountUpdate(
          name: 'Ravi',
          email: 'ravi@keshav.in',
          password: 'new-pass-1',
        ),
      );
      expect(store.passwordMatches(id, 'ravi-pass'), isFalse);
      expect(store.passwordMatches(id, 'new-pass-1'), isTrue);
      expect(ravi.id, isNotEmpty);
    });
  });
}
