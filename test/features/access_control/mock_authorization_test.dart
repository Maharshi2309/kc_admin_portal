import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_remote_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_remote_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

Matcher _denied(String action) => throwsA(
  isA<ForbiddenException>()
      .having((e) => e.code, 'code', ApiConstants.permissionDeniedCode)
      .having(
        (e) => e.message,
        'message',
        'You do not have permission to $action.',
      ),
);

void main() {
  group('MockGuard', () {
    late MockAccessStore store;
    late SessionEvents events;
    late MockGuard guard;
    var expired = 0;

    setUp(() {
      store = MockAccessStore(currentUserId: 'u5'); // attendance desk
      events = SessionEvents();
      expired = 0;
      events.onExpired.listen((_) => expired++);
      guard = MockGuard(store: store, sessionEvents: events);
    });
    tearDown(() => events.dispose());

    test("passes with the role's permission, else 403", () {
      guard.require(AppPermission.attendancePunch);
      expect(
        () => guard.require(AppPermission.employeeEdit),
        _denied('edit employees'),
      );
      guard.requireAny(const [
        AppPermission.leaveCreate,
        AppPermission.leaveView,
      ]);
    });

    test('allowAll checks nothing', () {
      const MockGuard.allowAll().require(AppPermission.permissionManage);
    });

    test('a deactivated user, or no session, ends it (401)', () async {
      store
        ..resume('u1')
        ..updateUser(
          'u5',
          const UserAccountUpdate(
            name: 'Arjun Joshi',
            email: 'arjun.joshi@keshav.in',
            isActive: false,
          ),
        )
        ..resume('u5');
      expect(
        () => guard.require(AppPermission.dashboardView),
        throwsA(isA<UnauthorizedException>()),
      );

      store
        ..resume('u3')
        ..signOut();
      expect(() => guard.signedIn(), throwsA(isA<UnauthorizedException>()));
      await Future<void>.delayed(Duration.zero);
      expect(expired, 2);
    });
  });

  group('dev login', () {
    late MockAccessStore store;
    String? token;
    late AuthMockDataSource auth;

    setUp(() {
      store = MockAccessStore(now: () => testNow, currentUserId: null);
      token = null;
      auth = AuthMockDataSource(store: store, readToken: () async => token);
    });

    test('signs in as a staff user, with their own permissions', () async {
      final response = await auth.login(
        email: ' Nisha.Solanki@keshav.in ',
        password: AuthMockDataSource.password,
      );
      expect(response.user.id, 'u3');
      expect(response.user.can(AppPermission.leaveApprove), isTrue);
      expect(response.user.can(AppPermission.permissionManage), isFalse);
      expect(response.accessToken, 'mock-dev-token.u3');
      expect(store.currentUserId, 'u3');
      expect(store.user('u3').lastSignInAt, testNow);
    });

    test(
      'rejects unknown emails, wrong passwords and inactive users',
      () async {
        await expectLater(
          auth.login(email: 'x@keshav.in', password: 'password'),
          throwsA(isA<UnauthorizedException>()),
        );
        await expectLater(
          auth.login(email: 'admin@keshav.in', password: 'nope'),
          throwsA(isA<UnauthorizedException>()),
        );
        store
          ..resume('u1')
          ..updateUser(
            'u4',
            const UserAccountUpdate(
              name: 'Kunal Desai',
              email: 'kunal.desai@keshav.in',
              isActive: false,
            ),
          );
        await expectLater(
          auth.login(email: 'kunal.desai@keshav.in', password: 'password'),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'This account has been deactivated.',
            ),
          ),
        );
      },
    );

    test('a saved token restores the same user; sign-out ends it', () async {
      token = 'mock-dev-token.u5';
      final user = await auth.me();
      expect(user.name, 'Arjun Joshi');
      expect(store.currentUserId, 'u5');

      await auth.logout();
      expect(store.currentUserId, isNull);

      token = 'mock-dev-token.nobody';
      await expectLater(auth.me(), throwsA(isA<UnauthorizedException>()));
    });
  });

  group('every mock endpoint checks permissions', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
      container.read(mockAccessStoreProvider).resume('u5'); // attendance desk
    });

    test('what the attendance desk may do', () async {
      await container
          .read(employeeRemoteDataSourceProvider)
          .list(const EmployeeQuery());
      // Allowed to punch; the business rule answers, not a 403.
      await expectLater(
        container.read(attendanceRemoteDataSourceProvider).punchIn('7'),
        throwsA(isA<ValidationException>()),
      );
      await container.read(holidayRemoteDataSourceProvider).list(year: 2026);
      await container.read(dashboardRemoteDataSourceProvider).summary(testNow);
      await container
          .read(calendarRemoteDataSourceProvider)
          .month('1', DateTime(2026, 9));
    });

    test('and what it may not', () async {
      await expectLater(
        container
            .read(holidayRemoteDataSourceProvider)
            .create(HolidayInput(date: DateTime(2026, 11, 9), name: 'Diwali')),
        _denied('add holidays'),
      );
      await expectLater(
        container
            .read(leaveRemoteDataSourceProvider)
            .setStatus('1', LeaveStatus.approved),
        _denied('approve and reject'),
      );
      await expectLater(
        container
            .read(leaveRemoteDataSourceProvider)
            .setStatus('1', LeaveStatus.cancelled),
        _denied('cancel leave'),
      );
      await expectLater(
        container
            .read(employeeRemoteDataSourceProvider)
            .setStatus('1', EmployeeStatus.inactive),
        _denied('deactivate employees'),
      );
      await expectLater(
        container
            .read(overtimeRemoteDataSourceProvider)
            .report('1', from: DateTime(2026, 9), to: DateTime(2026, 9, 28)),
        _denied('view overtime'),
      );
      await expectLater(
        container.read(userRemoteDataSourceProvider).list(const UserQuery()),
        _denied('manage users and permissions'),
      );
      await expectLater(
        container.read(accessRemoteDataSourceProvider).permissions(),
        _denied('manage users and permissions'),
      );
    });
  });
}
