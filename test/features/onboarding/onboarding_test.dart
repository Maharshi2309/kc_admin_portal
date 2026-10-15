// Public sign-up and onboarding (2026-10-06): anyone may create a free
// account, verify their email with a code, then create an organization or
// join one by invitation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/router/app_router.dart';
import 'package:kc_admin_portal/app/router/route_guards.dart';
import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_directory.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

import '../../helpers/fake_auth.dart';

const _code = MockDirectory.verificationCode;

void main() {
  group('accounts on the mock server', () {
    late ProviderContainer container;
    late AuthMockDataSource auth;

    setUp(() {
      container = createTestContainer();
      auth = AuthMockDataSource(
        accessOf: (id) =>
            container.read(mockDirectoryProvider).organization(id) == null
            ? null
            : container.read(mockTenantProvider(id)).access,
        directory: container.read(mockDirectoryProvider),
      );
    });

    MockTenant tenant(String id) => container.read(mockTenantProvider(id));

    test('sign up, verify, and start with no organization', () async {
      await auth.register(
        name: 'Asha Iyer',
        email: ' Asha@Bright.in ',
        password: 'long-enough',
      );
      // Not before verifying the email.
      await expectLater(
        auth.login(email: 'asha@bright.in', password: 'long-enough'),
        throwsA(
          isA<ForbiddenException>().having(
            (e) => e.code,
            'code',
            ApiConstants.emailNotVerifiedCode,
          ),
        ),
      );
      await expectLater(
        auth.verifyEmail(email: 'asha@bright.in', code: '000000'),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors.keys,
            'field',
            contains('code'),
          ),
        ),
      );

      final session = await auth.verifyEmail(
        email: 'asha@bright.in',
        code: _code,
      );
      expect(session.user.name, 'Asha Iyer');
      expect(session.user.organization, isNull);
      expect(session.user.memberships, isEmpty);
      expect(session.user.needsOrganization, isTrue);
      expect(session.user.permissions, isEmpty);
    });

    test('sign-up checks the password and existing accounts', () async {
      await expectLater(
        auth.register(name: 'Asha', email: 'asha@bright.in', password: 'short'),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors.keys,
            'field',
            contains('password'),
          ),
        ),
      );
      await expectLater(
        auth.register(
          name: 'Admin',
          email: 'admin@keshav.in',
          password: 'long-enough',
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors['email'],
            'email',
            contains('already exists'),
          ),
        ),
      );
    });

    test(
      'a new organization: the creator owns it, and it starts empty',
      () async {
        await auth.register(
          name: 'Asha Iyer',
          email: 'asha@bright.in',
          password: 'long-enough',
        );
        await auth.verifyEmail(email: 'asha@bright.in', code: _code);
        final created = await auth.createOrganization(
          name: '  Bright Bakery ',
          timezone: 'Asia/Dubai',
        );
        final organization = created.user.organization!;
        expect(organization.name, 'Bright Bakery');
        expect(organization.timezone, 'Asia/Dubai');
        expect(created.user.hasFullAccess, isTrue);
        expect(created.user.memberships!.single.name, 'Bright Bakery');

        // Its own, empty data; nothing of the sample organizations.
        final employees = await tenant(
          organization.id,
        ).employeeSource.list(const EmployeeQuery());
        expect(employees.total, 0);
        await expectLater(
          tenant(
            MockSession.keshavId,
          ).employeeSource.list(const EmployeeQuery()),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test('an invitation: sign up with that email, then join', () async {
      // Admin (in Keshav Clothing) invites Asha to take attendance.
      tenant(MockSession.keshavId).access.createUser(
        UserAccountInput(
          name: 'Asha Iyer',
          email: 'asha@bright.in',
          permissions: [AppPermission.attendanceView.key],
        ),
      );
      final invited = tenant(
        MockSession.keshavId,
      ).access.users.firstWhere((u) => u.email == 'asha@bright.in');
      expect(invited.invitationPending, isTrue);

      await auth.register(
        name: 'Asha Iyer',
        email: 'asha@bright.in',
        password: 'long-enough',
      );
      await auth.verifyEmail(email: 'asha@bright.in', code: _code);
      final invitations = await auth.invitations();
      expect(invitations.single.organization.name, 'Keshav Clothing');
      expect(invitations.single.invitedBy, 'Admin');

      final joined = await auth.acceptInvitation(invitations.single.id);
      expect(joined.user.organization?.name, 'Keshav Clothing');
      expect(joined.user.permissions, [AppPermission.attendanceView.key]);
      expect(await auth.invitations(), isEmpty);
      final member = tenant(
        MockSession.keshavId,
      ).access.users.firstWhere((u) => u.email == 'asha@bright.in');
      expect(member.invitationPending, isFalse);
      expect(member.id, joined.user.id);
    });

    test('a declined invitation is gone', () async {
      tenant(MockSession.sunriseId).access.createUser(
        const UserAccountInput(name: 'Asha Iyer', email: 'asha@bright.in'),
      );
      await auth.register(
        name: 'Asha Iyer',
        email: 'asha@bright.in',
        password: 'long-enough',
      );
      await auth.verifyEmail(email: 'asha@bright.in', code: _code);
      final invitation = (await auth.invitations()).single;
      await auth.declineInvitation(invitation.id);
      expect(await auth.invitations(), isEmpty);
      await expectLater(
        auth.acceptInvitation(invitation.id),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('a cancelled invitation is gone for the invitee', () async {
      final access = tenant(MockSession.sunriseId).access;
      final invited = access.createUser(
        const UserAccountInput(name: 'Asha Iyer', email: 'asha@bright.in'),
      );
      await auth.register(
        name: 'Asha Iyer',
        email: 'asha@bright.in',
        password: 'long-enough',
      );
      await auth.verifyEmail(email: 'asha@bright.in', code: _code);
      final invitation = (await auth.invitations()).single;

      access.cancelInvitation(invited.id);
      expect(await auth.invitations(), isEmpty);
      await expectLater(
        auth.acceptInvitation(invitation.id),
        throwsA(
          isA<NotFoundException>().having(
            (e) => e.message,
            'message',
            'This invitation is no longer valid.',
          ),
        ),
      );
    });

    test('a forgotten password is reset with the emailed code', () async {
      await auth.forgotPassword('nisha.solanki@keshav.in');
      await expectLater(
        auth.resetPassword(
          email: 'nisha.solanki@keshav.in',
          code: '999999',
          password: 'a-new-password',
        ),
        throwsA(isA<ValidationException>()),
      );
      await auth.resetPassword(
        email: 'nisha.solanki@keshav.in',
        code: _code,
        password: 'a-new-password',
      );
      await expectLater(
        auth.login(email: 'nisha.solanki@keshav.in', password: 'password'),
        throwsA(isA<UnauthorizedException>()),
      );
      final session = await auth.login(
        email: 'nisha.solanki@keshav.in',
        password: 'a-new-password',
      );
      expect(session.user.organization?.name, 'Keshav Clothing');
    });
  });

  group('routing for a person without an organization', () {
    test('only the welcome and create pages', () {
      String? go(String path) => organizationRedirect(
        needsOrganization: true,
        path: path,
        homeLocation: AppRoutePaths.welcome,
      );
      expect(go(AppRoutePaths.dashboard), AppRoutePaths.welcome);
      expect(go('/employees/1'), AppRoutePaths.welcome);
      expect(go(AppRoutePaths.welcome), isNull);
      expect(go(AppRoutePaths.createOrganization), isNull);
    });

    test('members skip the welcome page, but may create another', () {
      String? go(String path) => organizationRedirect(
        needsOrganization: false,
        path: path,
        homeLocation: AppRoutePaths.dashboard,
      );
      expect(go(AppRoutePaths.welcome), AppRoutePaths.dashboard);
      expect(go(AppRoutePaths.createOrganization), isNull);
      expect(go(AppRoutePaths.employees), isNull);
    });

    test('sign-up pages are public, and not for signed-in users', () {
      for (final path in [
        AppRoutePaths.register,
        AppRoutePaths.verifyEmail,
        AppRoutePaths.forgotPassword,
        AppRoutePaths.resetPassword,
      ]) {
        expect(
          authRedirect(
            status: AuthStatus.signedOut,
            location: Uri(path: path),
          ),
          isNull,
          reason: path,
        );
        expect(
          authRedirect(
            status: AuthStatus.signedIn,
            location: Uri(path: path),
          ),
          AppRoutePaths.dashboard,
          reason: path,
        );
      }
    });
  });

  group('in the app', () {
    Finder field(String label) => find.descendant(
      of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
      matching: find.byType(TextField),
    );

    String location(WidgetTester tester) => currentLocation(
      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).read(routerProvider),
    );

    Future<void> tap(WidgetTester tester, Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Future<void> signUp(WidgetTester tester, {required String email}) async {
      await tap(tester, find.text('Create an account'));
      expect(location(tester), AppRoutePaths.register);
      await tester.enterText(field('Your name'), 'Asha Iyer');
      await tester.enterText(field('Email address'), email);
      await tester.enterText(field('Password'), 'long-enough');
      await tap(tester, find.widgetWithText(FilledButton, 'Create account'));

      expect(find.text('Check your email'), findsOneWidget);
      expect(find.textContaining('The code is $_code'), findsOneWidget);
      await tester.enterText(field('Code'), _code);
      await tap(tester, find.widgetWithText(FilledButton, 'Verify email'));
    }

    testWidgets('sign up, create an organization, and start empty', (
      tester,
    ) async {
      await pumpFullApp(tester, repository: null, mockDashboard: true);
      await signUp(tester, email: 'asha@bright.in');

      // Signed in, in no organization: only the welcome page.
      expect(location(tester), AppRoutePaths.welcome);
      expect(find.text('Welcome, Asha'), findsOneWidget);
      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).read(routerProvider).go(AppRoutePaths.employees);
      await tester.pumpAndSettle();
      expect(location(tester), AppRoutePaths.welcome);

      await tap(tester, find.text('Create your organization'));
      await tester.enterText(field('Organization name'), 'Bright Bakery');
      await tap(
        tester,
        find.widgetWithText(FilledButton, 'Create organization'),
      );

      // A new, empty organization, with the first step offered.
      expect(location(tester), AppRoutePaths.dashboard);
      expect(find.text('Bright Bakery'), findsWidgets);
      expect(find.text('No employees added yet'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Add employee'), findsWidgets);
    });

    testWidgets('a new organization can start with unpaid leave only', (
      tester,
    ) async {
      await pumpFullApp(tester, repository: null, mockDashboard: true);
      await signUp(tester, email: 'asha@bright.in');
      await tap(tester, find.text('Create your organization'));
      await tester.enterText(field('Organization name'), 'Quiet Studio');
      expect(find.text('Start with paid leave'), findsOneWidget);
      await tap(tester, find.text('Start with paid leave'));
      expect(find.textContaining('Only unpaid leave for now'), findsOneWidget);
      await tap(
        tester,
        find.widgetWithText(FilledButton, 'Create organization'),
      );

      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).read(routerProvider).go('/leave?view=balances');
      await tester.pumpAndSettle();
      expect(find.text('No paid leave in this organization'), findsOneWidget);
    });

    testWidgets("a new organization's phone country starts from the device", (
      tester,
    ) async {
      await pumpFullApp(
        tester,
        repository: null,
        mockDashboard: true,
        deviceCountry: 'AE',
      );
      await signUp(tester, email: 'asha@bright.in');
      await tap(tester, find.text('Create your organization'));
      expect(find.text('United Arab Emirates (+971)'), findsWidgets);
      await tester.enterText(field('Organization name'), 'Desert Threads');
      await tap(
        tester,
        find.widgetWithText(FilledButton, 'Create organization'),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      );
      final settings = await tester.runAsync(
        () => container.read(mockActiveTenantProvider).organization.settings(),
      );
      expect(settings!.defaultCountry, 'AE');
    });

    testWidgets('an invited person joins their organization', (tester) async {
      await pumpFullApp(tester, repository: null, mockDashboard: true);
      ProviderScope.containerOf(tester.element(find.byType(KeshavAdminApp)))
          .read(mockTenantProvider(MockSession.sunriseId))
          .access
          .createUser(
            UserAccountInput(
              name: 'Asha Iyer',
              email: 'asha@bright.in',
              permissions: [for (final p in AppPermission.values) p.key],
            ),
          );

      await signUp(tester, email: 'asha@bright.in');
      expect(find.text('Sunrise Garments'), findsOneWidget);
      expect(find.textContaining('Invited by'), findsOneWidget);
      await tap(tester, find.text('Join Sunrise Garments'));

      expect(find.text('You joined Sunrise Garments'), findsOneWidget);
      expect(location(tester), AppRoutePaths.dashboard);
      expect(find.text('Sunrise Garments'), findsWidgets);
    });

    testWidgets('an unverified account is offered the code page', (
      tester,
    ) async {
      await pumpFullApp(tester, repository: null);
      ProviderScope.containerOf(tester.element(find.byType(KeshavAdminApp)))
          .read(mockDirectoryProvider)
          .register(
            name: 'Asha Iyer',
            email: 'asha@bright.in',
            password: 'long-enough',
          );
      await tester.enterText(field('Email address'), 'asha@bright.in');
      await tester.enterText(field('Password'), 'long-enough');
      await tap(tester, find.widgetWithText(FilledButton, 'Sign in'));

      expect(find.textContaining('Verify your email address'), findsOneWidget);
      await tap(tester, find.text('Enter the code'));
      expect(location(tester), '/verify-email?email=asha%40bright.in');
      expect(find.text('Check your email'), findsOneWidget);
    });

    testWidgets('forgot password: a code, a new password, sign in', (
      tester,
    ) async {
      await pumpFullApp(tester, repository: null);
      await tester.enterText(field('Email address'), 'nisha.solanki@keshav.in');
      await tap(tester, find.text('Forgot password?'));
      expect(find.text('Forgot your password?'), findsOneWidget);
      await tap(tester, find.widgetWithText(FilledButton, 'Send code'));

      expect(find.text('Choose a new password'), findsOneWidget);
      await tester.enterText(field('Code'), _code);
      await tester.enterText(field('New password'), 'a-new-password');
      await tap(tester, find.widgetWithText(FilledButton, 'Change password'));

      expect(location(tester), AppRoutePaths.login);
      expect(
        find.text('Password changed. Sign in with your new password.'),
        findsOneWidget,
      );
      await tester.enterText(field('Email address'), 'nisha.solanki@keshav.in');
      await tester.enterText(field('Password'), 'a-new-password');
      await tap(tester, find.widgetWithText(FilledButton, 'Sign in'));
      expect(find.text('Keshav Clothing'), findsWidgets);
      expect(location(tester), isNot(AppRoutePaths.login));
    });
  });
}
