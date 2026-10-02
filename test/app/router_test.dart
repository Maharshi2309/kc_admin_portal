import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';

import '../helpers/fake_auth.dart';

const _desktop = Size(1440, 1000);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

/// Pumps the full app, already signed in, and returns its router.
Future<GoRouter> _pumpApp(
  WidgetTester tester, {
  Size size = _desktop,
  Env env = testEnv,
}) => pumpFullApp(
  tester,
  repository: FakeAuthRepository(sessionUser: testUser),
  size: size,
  env: env,
);

Future<void> _go(WidgetTester tester, GoRouter router, String location) async {
  router.go(location);
  await tester.pumpAndSettle();
}

void main() {
  group('shell navigation adapts to width', () {
    testWidgets('desktop shows the sidebar', (tester) async {
      await _pumpApp(tester);
      expect(find.byType(AppSidebar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tablet shows the navigation rail', (tester) async {
      await _pumpApp(tester, size: _tablet);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(AppSidebar), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('phone shows the bottom navigation bar', (tester) async {
      await _pumpApp(tester, size: _phone);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(AppSidebar), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('starts on the dashboard and switches sections', (tester) async {
    final router = await _pumpApp(tester);
    expect(currentLocation(router), '/dashboard');

    await tester.tap(find.text('Employees').first);
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/employees');

    await tester.tap(find.text('Leaves').first);
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/leave');
  });

  testWidgets('phone bottom bar switches sections', (tester) async {
    final router = await _pumpApp(tester, size: _phone);
    await tester.tap(find.text('Attendance'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/attendance');
  });

  testWidgets('deep links open nested screens', (tester) async {
    final router = await _pumpApp(tester);

    await _go(tester, router, '/employees/1');
    expect(find.text('Aarav Shah'), findsWidgets);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/employees/1/edit');
    expect(find.text('Edit employee'), findsWidgets);
  });

  testWidgets('attendance correction opens as a dialog over the list', (
    tester,
  ) async {
    final router = await _pumpApp(tester);
    await _go(tester, router, '/attendance/7/edit');

    expect(find.byType(AppDialog), findsOneWidget);
    expect(find.text('Attendance'), findsWidgets); // list still underneath

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsNothing);
    expect(currentLocation(router), '/attendance');
  });

  testWidgets('add leave opens as a side sheet', (tester) async {
    final router = await _pumpApp(tester);
    await _go(tester, router, '/leave');
    await tester.tap(find.text('Add leave'));
    await tester.pumpAndSettle();

    expect(find.byType(AppSideSheet), findsOneWidget);
    expect(currentLocation(router), '/leave/add');
  });

  testWidgets('header search opens employees with the query', (tester) async {
    final router = await _pumpApp(tester);
    await tester.enterText(find.byType(TextField), 'KC1001');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(currentLocation(router), '/employees?search=KC1001');
    // The list is filtered to the one matching employee.
    expect(find.text('Aarav Shah'), findsOneWidget);
    expect(find.text('Priya Desai'), findsNothing);
  });

  testWidgets('unknown paths show the not-found page', (tester) async {
    final router = await _pumpApp(tester);
    await _go(tester, router, '/does-not-exist');
    expect(find.text('Page not found'), findsOneWidget);
  });

  group('dev component gallery', () {
    testWidgets('is available outside production', (tester) async {
      final router = await _pumpApp(tester);
      router.go('/dev/components');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Design system'), findsOneWidget);
    });

    testWidgets('is not registered in production', (tester) async {
      final router = await _pumpApp(
        tester,
        env: const Env(
          environment: AppEnvironment.prod,
          apiBaseUrl: 'https://example.invalid/api',
          apiTimeout: Duration(seconds: 30),
        ),
      );
      await _go(tester, router, '/dev/components');
      expect(find.text('Page not found'), findsOneWidget);
    });
  });
}
