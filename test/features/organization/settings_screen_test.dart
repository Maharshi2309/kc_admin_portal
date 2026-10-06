// The Settings page (2026-10-06): each organization's name, logo, time
// zone, departments, positions and working defaults.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/router/app_router.dart';
import 'package:kc_admin_portal/core/files/file_picking.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/widgets/organization_logo.dart';

import '../../helpers/fake_auth.dart';

Finder _field(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(KeshavAdminApp)));

Future<void> _go(WidgetTester tester, String path) async {
  _container(tester).read(routerProvider).go(path);
  await tester.pumpAndSettle();
}

/// Signs in through the dev mock, so profile changes reach the sidebar.
Future<void> _signIn(WidgetTester tester, String email) async {
  Finder input(String hint) => find.byWidgetPredicate(
    (w) =>
        w is TextField &&
        w.autofillHints != null &&
        w.autofillHints!.contains(hint),
  );
  await tester.enterText(input(AutofillHints.email), email);
  await tester.enterText(
    input(AutofillHints.password),
    AuthMockDataSource.password,
  );
  await _tap(tester, find.widgetWithText(FilledButton, 'Sign in'));
}

final _png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A]);

void main() {
  testWidgets('only with "Manage organization settings"', (tester) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(
        sessionUser: testUser.copyWith(
          permissions: [
            for (final p in AppPermission.values)
              if (p != AppPermission.settingsManage) p.key,
          ],
        ),
      ),
    );
    expect(find.text('Settings'), findsNothing);
    router.go('/settings');
    await tester.pumpAndSettle();
    expect(currentLocation(router), startsWith('/no-access'));
  });

  testWidgets('a new department is offered for employees', (tester) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    await _tap(tester, find.text('Settings').first);
    expect(currentLocation(router), '/settings');
    expect(find.text('Graphic Designer'), findsWidgets);

    final newDepartment = find.descendant(
      of: find.byWidgetPredicate(
        (w) => w is AppTextField && w.hintText == 'New department',
      ),
      matching: find.byType(TextField),
    );
    await tester.enterText(newDepartment, 'Production');
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Add').first);
    expect(find.text('Department "Production" added'), findsOneWidget);
    expect(find.text('Production'), findsOneWidget);

    // A duplicate is refused on the field.
    await tester.enterText(newDepartment, 'production');
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Add').first);
    expect(find.textContaining('already exists'), findsOneWidget);

    // The employee form offers it.
    router.go('/employees/add');
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Select department'));
    expect(find.text('Production'), findsWidgets);
  });

  testWidgets('renaming the organization updates the menu; logo upload', (
    tester,
  ) async {
    await pumpFullApp(
      tester,
      repository: null,
      overrides: [
        fileChooserProvider.overrideWithValue(
          ({required extensions}) async => (name: 'logo.png', bytes: _png),
        ),
      ],
    );
    await _signIn(tester, 'admin@keshav.in');
    expect(find.text('Keshav Clothing'), findsWidgets);

    await _go(tester, '/settings');
    await tester.enterText(_field('Organization name'), 'Keshav Clothing Co.');
    await _tap(tester, find.widgetWithText(FilledButton, 'Save details'));
    expect(find.text('Organization details saved'), findsOneWidget);
    expect(find.text('Keshav Clothing Co.'), findsWidgets);

    await _tap(tester, find.text('Change logo'));
    expect(find.text('Logo updated'), findsOneWidget);
    final logos = tester.widgetList<OrganizationLogo>(
      find.byType(OrganizationLogo),
    );
    expect(logos.every((l) => l.logoUrl!.startsWith('data:image/png')), isTrue);
  });

  testWidgets("a new employee starts with the organization's schedule", (
    tester,
  ) async {
    await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    final organization = _container(
      tester,
    ).read(mockTenantProvider(MockSession.keshavId)).organization;
    // The mock answers after a timer: run it for real.
    await tester.runAsync(() async {
      final settings = await organization.settings();
      await organization.updateSettings(
        settings.copyWith(
          defaultSchedule: settings.defaultSchedule.copyWith(
            startTime: const ClockTime.hm(10, 0),
            endTime: const ClockTime.hm(19, 0),
          ),
        ),
      );
    });

    await _go(tester, '/employees/add');
    expect(find.text('10:00'), findsWidgets);
    expect(find.text('19:00'), findsWidgets);
  });

  testWidgets("another organization's lists and EC numbers", (tester) async {
    await pumpFullApp(tester, repository: null);
    await _signIn(tester, 'ravi.mehta@sunrise.in');
    await _go(tester, '/settings');
    expect(find.text('Stitching'), findsWidgets);
    expect(find.text('Graphic Designer'), findsNothing);

    await _go(tester, '/employees/add');
    expect(find.text('SG106'), findsWidgets); // field + preview; after SG105
  });

  testWidgets("leave shows the organization's own names and rules", (
    tester,
  ) async {
    await pumpFullApp(tester, repository: null);
    await _signIn(tester, 'ravi.mehta@sunrise.in');
    await _go(tester, '/employees/s1');
    expect(find.text('Paid leave'), findsWidgets);
    expect(
      find.text('1.5 days earned each month · up to 12 days'),
      findsOneWidget,
    );
    expect(find.text('Casual leave'), findsNothing);

    await _go(tester, '/leave?view=balances');
    expect(find.bySemanticsLabel(RegExp('^Paid leave earned')), findsOneWidget);
  });

  testWidgets('saving the leave policy renames the paid leave', (tester) async {
    await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    await _go(tester, '/settings');
    await tester.enterText(_field('Paid leave name'), 'Earned leave');
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Save leave settings'),
    );
    expect(
      find.text('Leave settings saved. Balances are recalculated.'),
      findsOneWidget,
    );

    await _go(tester, '/leave?view=balances');
    expect(
      find.bySemanticsLabel(RegExp('^Earned leave earned')),
      findsOneWidget,
    );
  });

  testWidgets('unpaid leave only: no balances to show', (tester) async {
    await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    await _go(tester, '/settings');
    await _tap(tester, find.text('Unpaid only'));
    expect(find.text('Paid leave name'), findsNothing);
    await _tap(
      tester,
      find.widgetWithText(FilledButton, 'Save leave settings'),
    );

    await _go(tester, '/leave?view=balances');
    expect(find.text('No paid leave in this organization'), findsOneWidget);
    await _go(tester, '/employees/1');
    expect(find.text('Casual leave'), findsNothing);
    expect(find.text('Unpaid leave'), findsOneWidget);
  });
}
