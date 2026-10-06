// Organization A must never see organization B's data
// (docs/ARCHITECTURE_MULTI_ORG.md §H). The dev mock plays the backend here:
// the organization comes from the session, and each organization's data
// answers only to sessions working in it.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/router/app_router.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

import '../../helpers/fake_auth.dart';

const _keshav = MockSession.keshavId;
const _sunrise = MockSession.sunriseId;

Future<List<String>> _employeeNames(MockTenant tenant) async => [
  for (final e in (await tenant.employeeSource.list(
    const EmployeeQuery(pageSize: 50),
  )).items)
    e.name,
];

void main() {
  group('the mock server keeps organizations apart', () {
    late ProviderContainer container;
    late MockSession session;
    MockTenant tenant(String id) => container.read(mockTenantProvider(id));

    setUp(() {
      container = createTestContainer();
      session = container.read(mockSessionProvider);
    });

    test(
      'a session only reaches its own organization (404 otherwise)',
      () async {
        // The dev session starts in Keshav Clothing.
        expect(await _employeeNames(tenant(_keshav)), contains('Aarav Shah'));
        await expectLater(
          tenant(_sunrise).employeeSource.list(const EmployeeQuery()),
          throwsA(isA<NotFoundException>()),
        );
        await expectLater(
          tenant(_sunrise).holidaySource.list(),
          throwsA(isA<NotFoundException>()),
        );

        session.start('u1', _sunrise);
        final sunrise = await _employeeNames(tenant(_sunrise));
        expect(sunrise, containsAll(['Ravi Mehta', 'Farah Khan']));
        expect(sunrise, isNot(contains('Aarav Shah')));
        await expectLater(
          tenant(_keshav).employeeSource.list(const EmployeeQuery()),
          throwsA(isA<NotFoundException>()),
        );
      },
    );

    test("another organization's ids are not found", () async {
      session.start('u1', _sunrise);
      // Employee 1 is Aarav Shah of Keshav Clothing.
      await expectLater(
        tenant(_sunrise).employeeSource.getById('1'),
        throwsA(isA<NotFoundException>()),
      );
      expect(
        (await tenant(_sunrise).employeeSource.getById('s1')).name,
        'Ravi Mehta',
      );
    });

    test('changes stay in their organization', () async {
      session.start('u1', _sunrise);
      await tenant(_sunrise).holidaySource.create(
        HolidayInput(date: DateTime(2026, 11, 20), name: 'Sunrise Picnic'),
      );
      final sunrise = await tenant(_sunrise).holidaySource.list(year: 2026);
      expect(sunrise.map((h) => h.name), contains('Sunrise Picnic'));

      session.start('u1', _keshav);
      final keshav = await tenant(_keshav).holidaySource.list(year: 2026);
      expect(keshav.map((h) => h.name), isNot(contains('Sunrise Picnic')));
      expect(keshav.map((h) => h.name), isNot(contains('Foundation Day')));
    });

    test('permissions are per organization', () {
      // Farah Khan only takes attendance at Sunrise; she isn't a member of
      // Keshav Clothing at all.
      session.start('u21', _sunrise);
      expect(tenant(_sunrise).guard.has(AppPermission.attendancePunch), true);
      expect(tenant(_sunrise).guard.has(AppPermission.employeeEdit), false);
      expect(tenant(_keshav).access.isActiveMember('u21'), isFalse);
      expect(
        () => tenant(_sunrise).guard.require(AppPermission.employeeEdit),
        throwsA(isA<ForbiddenException>()),
      );
    });
  });

  group('sign-in and switching', () {
    late ProviderContainer container;
    late AuthMockDataSource auth;
    String? token;

    setUp(() {
      container = createTestContainer();
      token = null;
      auth = AuthMockDataSource(
        accessOf: (id) => container.read(mockTenantProvider(id)).access,
        directory: container.read(mockDirectoryProvider),
        readToken: () async => token,
      );
    });

    test('a member of two organizations can switch between them', () async {
      final login = await auth.login(
        email: 'admin@keshav.in',
        password: AuthMockDataSource.password,
      );
      expect(login.user.organization?.id, _keshav);
      expect(login.user.memberships!.map((m) => m.name), [
        'Keshav Clothing',
        'Sunrise Garments',
      ]);
      expect(login.user.canSwitchOrganization, isTrue);

      final switched = await auth.switchOrganization(_sunrise);
      expect(switched.accessToken, 'mock-dev-token.u1.$_sunrise');
      expect(switched.user.organization?.name, 'Sunrise Garments');
      expect(container.read(mockSessionProvider).organizationId, _sunrise);

      // A restart restores the organization from the token.
      token = switched.accessToken;
      expect((await auth.me()).organization?.id, _sunrise);
    });

    test(
      "nobody can switch into an organization they don't belong to",
      () async {
        final login = await auth.login(
          email: 'ravi.mehta@sunrise.in',
          password: AuthMockDataSource.password,
        );
        expect(login.user.organization?.id, _sunrise);
        expect(login.user.canSwitchOrganization, isFalse);
        await expectLater(
          auth.switchOrganization(_keshav),
          throwsA(isA<NotFoundException>()),
        );
        expect(container.read(mockSessionProvider).organizationId, _sunrise);

        // Nor with a hand-made token.
        token = 'mock-dev-token.u20.$_keshav';
        await expectLater(auth.me(), throwsA(isA<UnauthorizedException>()));
      },
    );
  });

  group('in the app', () {
    Finder field(String hint) => find.byWidgetPredicate(
      (w) =>
          w is TextField &&
          w.autofillHints != null &&
          w.autofillHints!.contains(hint),
    );

    Future<void> signIn(WidgetTester tester, String email) async {
      await tester.enterText(field(AutofillHints.email), email);
      await tester.enterText(
        field(AutofillHints.password),
        AuthMockDataSource.password,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
    }

    String location(WidgetTester tester) => currentLocation(
      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).read(routerProvider),
    );

    Future<void> open(WidgetTester tester, String path) async {
      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).read(routerProvider).go(path);
      await tester.pumpAndSettle();
    }

    Future<void> switchTo(WidgetTester tester, String name) async {
      await tester.tap(find.text('Organizations'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel(name));
      await tester.pumpAndSettle();
    }

    testWidgets('switching shows only the chosen organization', (tester) async {
      await pumpFullApp(tester, repository: null, mockDashboard: true);
      await signIn(tester, 'admin@keshav.in');
      expect(find.text('Keshav Clothing'), findsWidgets);

      await open(tester, '/employees?search=Aarav');
      expect(find.text('Aarav Shah'), findsWidgets);

      await switchTo(tester, 'Sunrise Garments');
      expect(find.text('Now working in Sunrise Garments'), findsOneWidget);
      // A fresh start in the new organization: back on the home page.
      expect(location(tester), '/dashboard');
      expect(find.text('Sunrise Garments'), findsWidgets);

      await open(tester, '/employees');
      expect(find.text('Ravi Mehta'), findsWidgets);
      expect(find.text('Aarav Shah'), findsNothing);
      // The search typed in Keshav Clothing didn't follow.
      expect(find.widgetWithText(TextField, 'Aarav'), findsNothing);

      await switchTo(tester, 'Keshav Clothing');
      await open(tester, '/employees');
      expect(find.text('Aarav Shah'), findsWidgets);
      expect(find.text('Ravi Mehta'), findsNothing);
    });

    testWidgets('a member of one organization sees only it', (tester) async {
      await pumpFullApp(tester, repository: null, mockDashboard: true);
      await signIn(tester, 'ravi.mehta@sunrise.in');
      expect(find.text('Sunrise Garments'), findsWidgets);
      await tester.tap(find.text('Organizations'));
      await tester.pumpAndSettle();
      expect(find.text('Your organizations'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Sunrise Garments, current'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel(RegExp('^Keshav Clothing')), findsNothing);
      // They can still start another one.
      expect(
        find.widgetWithText(OutlinedButton, 'Create organization'),
        findsOneWidget,
      );
    });
  });
}
