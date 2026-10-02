import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';

/// End-to-end: the real app (real routing, storage and platform plugins)
/// on a device or browser, against the built-in dev mock API.
///
/// Run on any device:
///   flutter test integration_test -d DEVICE_ID
/// Web (needs chromedriver running on port 4444):
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/app_flow_test.dart -d chrome
const _mockEnv = Env(
  environment: AppEnvironment.dev,
  apiBaseUrl: 'http://localhost:3000/api',
  apiTimeout: Duration(seconds: 30),
  useMockApi: true,
);

/// Short but real delays, so loading states are exercised.
const _latency = Duration(milliseconds: 50);

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

/// Scrolls [finder] to the middle of the screen, then taps it. Centring
/// matters for dropdowns: a field at the very edge scrolls a little when it
/// takes focus, and scrolling closes an open menu.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Opens a section from the sidebar, rail or bottom bar (whichever the
/// device's width shows).
Future<void> _openSection(WidgetTester tester, String label) async {
  final destination = find.descendant(
    of: find.byWidgetPredicate(
      (w) => w is AppSidebar || w is NavigationRail || w is NavigationBar,
    ),
    matching: find.text(label),
  );
  await _tap(tester, destination);
}

Future<void> _choose(WidgetTester tester, String hint, String option) async {
  final dropdown = find.byWidgetPredicate(
    (w) => w is DropdownMenu<String> && w.hintText == hint,
  );
  await _tap(tester, dropdown);
  await _tap(tester, find.text(option).last);
}

Future<void> _startApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        envProvider.overrideWithValue(_mockEnv),
        mockLatencyProvider.overrideWithValue(_latency),
      ],
      child: const KeshavAdminApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Signs in without keeping the session, so the device stays clean.
Future<void> _signIn(WidgetTester tester, String email) async {
  await tester.enterText(_input('Email address'), email);
  await tester.enterText(_input('Password'), AuthMockDataSource.password);
  final keep = find.byType(Checkbox);
  if (tester.widget<Checkbox>(keep).value ?? false) {
    await _tap(tester, find.text('Keep me signed in on this device'));
  }
  expect(tester.widget<Checkbox>(keep).value, isFalse);
  await _tap(tester, find.widgetWithText(FilledButton, 'Sign in'));
}

Future<void> _signOut(WidgetTester tester) async {
  final signOut = find.byTooltip('Sign out');
  if (signOut.evaluate().isNotEmpty) {
    await _tap(tester, signOut.first);
  } else {
    // Phones and tablets: from the account menu.
    await _tap(tester, find.byTooltip('Account'));
    await _tap(tester, find.text('Sign out').last);
  }
  expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
}

Finder _section(String label) => find.descendant(
  of: find.byWidgetPredicate(
    (w) => w is AppSidebar || w is NavigationRail || w is NavigationBar,
  ),
  matching: find.text(label),
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('admin day: sign in, add employee, punch in, approve leave, '
      'sign out', (tester) async {
    await _startApp(tester);
    await _signIn(tester, 'admin@keshav.in');
    expect(find.textContaining('Good '), findsOneWidget);

    // Add an employee: EC number and email are suggested.
    await _openSection(tester, 'Employees');
    await _tap(tester, find.widgetWithText(FilledButton, 'Add employee'));
    await tester.enterText(_input('Full name'), 'Ravi Patel');
    await tester.enterText(_input('Mobile number'), '9876543210');
    await tester.pumpAndSettle();
    final ecNumber = tester
        .widget<TextField>(_input('EC number'))
        .controller!
        .text;
    expect(ecNumber, matches(RegExp(r'^KC\d+$')));
    expect(
      tester.widget<TextField>(_input('Email address')).controller!.text,
      'ravi.patel@keshav.in',
    );
    await _choose(tester, 'Select department', 'IT');
    await _choose(tester, 'Select designation', 'QA engineer');
    await _tap(tester, find.text('Select date'));
    await _tap(tester, find.text('OK'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Save employee'));
    expect(find.text('Ravi Patel added'), findsOneWidget);
    expect(find.text(ecNumber), findsWidgets);

    // Punch the new employee in.
    await _openSection(tester, 'Attendance');
    await tester.enterText(find.byType(TextField).last, 'Ravi');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    final punchIn = find.widgetWithText(FilledButton, 'Punch in');
    if (punchIn.evaluate().isNotEmpty) {
      // Not offered on weekly offs and holidays.
      await _tap(tester, punchIn.first);
      expect(find.widgetWithText(FilledButton, 'Punch in'), findsNothing);
    }

    // Approve the first pending leave request.
    await _openSection(tester, 'Leaves');
    await _tap(tester, find.textContaining('Pending').first);
    final approve = find.widgetWithText(FilledButton, 'Approve');
    final pendingBefore = approve.evaluate().length;
    expect(pendingBefore, greaterThan(0));
    await _tap(tester, approve.first);
    expect(approve.evaluate().length, pendingBefore - 1);

    await _signOut(tester);
  });

  testWidgets('access: an admin limits a user, who then sees only that', (
    tester,
  ) async {
    await _startApp(tester);
    await _signIn(tester, 'admin@keshav.in');

    // Kunal may view holidays; take that away.
    await _openSection(tester, 'Access control');
    await _tap(tester, find.byTooltip('Permissions of Kunal Desai'));
    await _tap(tester, find.text('View holidays'));
    await _tap(tester, find.text('Save permissions').first);
    expect(find.text('Permissions of Kunal Desai saved'), findsOneWidget);
    await _signOut(tester);

    // Kunal signs in: no Holidays, and no Access control.
    await _signIn(tester, 'kunal.desai@keshav.in');
    expect(find.textContaining('Good '), findsOneWidget);
    expect(_section('Leaves'), findsOneWidget);
    expect(_section('Holidays'), findsNothing);
    expect(_section('Access control'), findsNothing);
    await _signOut(tester);
  });
}
