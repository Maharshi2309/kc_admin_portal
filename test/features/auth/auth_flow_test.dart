import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';

import '../../helpers/fake_auth.dart';

Finder _field(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is TextField &&
      widget.autofillHints != null &&
      widget.autofillHints!.contains(label),
);

Future<void> _signIn(
  WidgetTester tester, {
  String email = 'admin@keshav.in',
  String password = FakeAuthRepository.validPassword,
}) async {
  await tester.enterText(_field(AutofillHints.email), email);
  await tester.enterText(_field(AutofillHints.password), password);
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('signed-out users land on login', (tester) async {
    final router = await pumpFullApp(tester, repository: FakeAuthRepository());
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(currentLocation(router), startsWith('/login'));
  });

  testWidgets('invalid input is caught before calling the server', (
    tester,
  ) async {
    await pumpFullApp(tester, repository: FakeAuthRepository());
    await _signIn(tester, email: 'not-an-email', password: '');

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('a wrong password shows the server message', (tester) async {
    await pumpFullApp(tester, repository: FakeAuthRepository());
    await _signIn(tester, password: 'wrong');

    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('signing in opens the dashboard with the admin card', (
    tester,
  ) async {
    final router = await pumpFullApp(tester, repository: FakeAuthRepository());
    await _signIn(tester);

    expect(currentLocation(router), '/dashboard');
    expect(find.byType(AppSidebar), findsOneWidget);
    expect(find.text('Test Admin'), findsOneWidget);
  });

  testWidgets('"Keep me signed in" is on by default and can be turned off', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    await pumpFullApp(tester, repository: repository);

    final checkbox = find.byType(Checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);

    await tester.tap(find.text('Keep me signed in on this device'));
    await tester.pump();
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);

    await _signIn(tester);
    expect(repository.lastKeepSignedIn, isFalse);
  });

  testWidgets('a deep link survives the trip through login', (tester) async {
    final router = await pumpFullApp(tester, repository: FakeAuthRepository());
    router.go('/employees/42');
    await tester.pumpAndSettle();
    expect(currentLocation(router), startsWith('/login?from='));

    await _signIn(tester);
    expect(currentLocation(router), '/employees/42');
  });

  testWidgets('a stored session skips login', (tester) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    expect(currentLocation(router), '/dashboard');
  });

  testWidgets('offline at start-up offers a retry instead of signing out', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      sessionUser: testUser,
      restoreError: const NetworkException(),
    );
    final router = await pumpFullApp(tester, repository: repository);

    expect(find.text('Could not check your session'), findsOneWidget);
    expect(currentLocation(router), startsWith('/splash'));

    repository.restoreError = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/dashboard');
  });

  testWidgets('sign out returns to login', (tester) async {
    final repository = FakeAuthRepository(sessionUser: testUser);
    final router = await pumpFullApp(tester, repository: repository);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();

    expect(repository.signOutCalls, 1);
    // No return path: the next person to sign in may be someone else.
    expect(currentLocation(router), '/login');
  });

  testWidgets('after an expired session, the page is kept for signing in', (
    tester,
  ) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    router.go('/holidays');
    await tester.pumpAndSettle();
    ProviderScope.containerOf(
      tester.element(find.byType(AppSidebar)),
    ).read(sessionEventsProvider).notifyExpired();
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/login?from=%2Fholidays');
  });

  testWidgets('phone users sign out from the account menu', (tester) async {
    final repository = FakeAuthRepository(sessionUser: testUser);
    final router = await pumpFullApp(
      tester,
      repository: repository,
      size: const Size(390, 844),
    );

    await tester.tap(find.byTooltip('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(currentLocation(router), startsWith('/login'));
  });

  testWidgets('an expired session returns to login with a notice', (
    tester,
  ) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(AppSidebar)),
    );

    container.read(sessionEventsProvider).notifyExpired();
    await tester.pumpAndSettle();

    expect(currentLocation(router), startsWith('/login'));
    expect(
      find.text('Your session has expired. Please sign in again.'),
      findsOneWidget,
    );
  });

  testWidgets('login fits the smallest phones', (tester) async {
    await pumpFullApp(
      tester,
      repository: FakeAuthRepository(),
      size: const Size(320, 640),
    );
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
