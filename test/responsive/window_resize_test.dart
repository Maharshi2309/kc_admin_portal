import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';

import '../helpers/fake_auth.dart';

/// Resizing a browser window (or rotating a tablet) across breakpoints
/// switches the navigation but keeps the page, its route and what the
/// admin has typed.
const _desktop = Size(1440, 900);
const _tablet = Size(820, 1180);
const _phone = Size(390, 844);

Future<void> _resize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  await tester.pumpAndSettle();
}

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

String _text(WidgetTester tester, String label) =>
    tester.widget<TextField>(_input(label)).controller!.text;

void main() {
  testWidgets(
    'a half-filled form survives desktop → phone → tablet → desktop',
    (tester) async {
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: testUser),
        size: _desktop,
      );
      router.go('/employees/add');
      await tester.pumpAndSettle();
      await tester.enterText(_input('Full name'), 'Ravi Patel');
      await tester.enterText(_input('Mobile number'), '9876543210');
      await tester.pump();

      for (final (size, nav) in [
        (_phone, NavigationBar),
        (_tablet, NavigationRail),
        (_desktop, AppSidebar),
      ]) {
        await _resize(tester, size);
        expect(find.byType(nav), findsOneWidget, reason: '$size');
        expect(currentLocation(router), '/employees/add');
        expect(_text(tester, 'Full name'), 'Ravi Patel');
        expect(_text(tester, 'Mobile number'), '9876543210');
        expect(_text(tester, 'Email address'), 'ravi.patel@example.com');
      }
    },
  );

  testWidgets('an open dialog becomes full screen on a phone and back', (
    tester,
  ) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
      size: _desktop,
    );
    router.go('/attendance/7-20260928/edit');
    await tester.pumpAndSettle();
    final dialog = find.text('Correct attendance');
    expect(dialog, findsWidgets);

    await _resize(tester, _phone);
    expect(dialog, findsWidgets);
    expect(currentLocation(router), '/attendance/7-20260928/edit');

    await _resize(tester, _desktop);
    expect(dialog, findsWidgets);
  });

  testWidgets('list filters and search survive a resize', (tester) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
      size: _desktop,
    );
    router.go('/employees?search=patel');
    await tester.pumpAndSettle();
    final before = find.textContaining('Patel').evaluate().length;
    expect(before, greaterThan(0));

    await _resize(tester, _phone);
    expect(currentLocation(router), '/employees?search=patel');
    expect(find.textContaining('Patel'), findsWidgets);

    await _resize(tester, _desktop);
    expect(find.textContaining('Patel').evaluate().length, before);
  });
}
