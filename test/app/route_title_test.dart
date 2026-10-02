import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth.dart';

/// The title the browser tab shows: the innermost [Title] wins.
String _windowTitle(WidgetTester tester) =>
    tester.widgetList<Title>(find.byType(Title)).last.title;

void main() {
  testWidgets('signed out, the tab reads "Sign in"', (tester) async {
    await pumpFullApp(tester, repository: FakeAuthRepository());
    expect(_windowTitle(tester), 'Sign in · Keshav Admin');
  });

  testWidgets('the window title follows the page, dialogs included', (
    tester,
  ) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );
    expect(_windowTitle(tester), 'Dashboard · Keshav Admin');

    router.go('/employees/1');
    await tester.pumpAndSettle();
    expect(_windowTitle(tester), 'Employee profile · Keshav Admin');

    router.go('/leave');
    await tester.pumpAndSettle();
    // The sheet's result is not needed here.
    unawaited(router.push('/leave/add'));
    await tester.pumpAndSettle();
    expect(_windowTitle(tester), 'Add leave · Keshav Admin');

    // Closing the side sheet brings the page's title back.
    router.pop();
    await tester.pumpAndSettle();
    expect(_windowTitle(tester), 'Leaves · Keshav Admin');

    router.go('/holidays');
    await tester.pumpAndSettle();
    expect(_windowTitle(tester), 'Holidays · Keshav Admin');

    router.go('/no-such-page');
    await tester.pumpAndSettle();
    expect(_windowTitle(tester), 'Page not found · Keshav Admin');
  });
}
