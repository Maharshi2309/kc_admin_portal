import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';

import '../../helpers/fake_auth.dart';

Future<GoRouter> _open(
  WidgetTester tester,
  String location, {
  Size size = const Size(1440, 1000),
}) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    size: size,
  );
  router.go(location);
  await tester.pumpAndSettle();
  return router;
}

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

/// Picks [day] in the date picker, [monthsAhead] months after the one it
/// opens on (today's), and confirms.
Future<void> _pickDay(
  WidgetTester tester,
  int day, {
  int monthsAhead = 0,
}) async {
  await tester.tap(find.text('Select date'));
  await tester.pumpAndSettle();
  for (var i = 0; i < monthsAhead; i++) {
    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('$day').last);
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("lists the year's holidays with when they are", (tester) async {
    await _open(tester, '/holidays');
    expect(find.text('Holidays'), findsWidgets);
    expect(find.text('3 holidays'), findsOneWidget);
    expect(find.text('Republic Day'), findsOneWidget);
    expect(find.text('Fri, 2 Oct 2026'), findsOneWidget);
    expect(find.text('In 4 days'), findsOneWidget); // today is 28 Sep
    expect(find.text('Past'), findsNWidgets(2));
  });

  testWidgets('year switcher and search', (tester) async {
    await _open(tester, '/holidays');
    await tester.tap(find.byTooltip('Next year'));
    await tester.pumpAndSettle();
    expect(find.text('2027'), findsOneWidget);
    expect(find.text('Sat, 2 Oct 2027'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'republic');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('1 holiday'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'zzz');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('No holidays match "zzz"'), findsOneWidget);
  });

  testWidgets('adding a holiday, and a date that is taken', (tester) async {
    final router = await _open(tester, '/holidays');
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/holidays/add');

    // Required fields first.
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday').last);
    await tester.pumpAndSettle();
    expect(find.text('Date is required'), findsOneWidget);
    expect(find.text('Holiday name is required'), findsOneWidget);

    // 2 Oct is Gandhi Jayanti already.
    await _pickDay(tester, 2, monthsAhead: 1);
    await tester.enterText(_input('Holiday name'), 'Company Holiday');
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday').last);
    await tester.pumpAndSettle();
    expect(find.text('Gandhi Jayanti is already on this date'), findsOneWidget);
    expect(find.byType(AppDialog), findsOneWidget);

    await tester.tap(find.text('Fri, 2 Oct 2026').last); // the field
    await tester.pumpAndSettle();
    await tester.tap(find.text('9').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday').last);
    await tester.pumpAndSettle();

    expect(currentLocation(router), '/holidays');
    expect(
      find.text('Company Holiday added for Fri, 9 Oct 2026'),
      findsOneWidget,
    );
    expect(find.text('4 holidays'), findsOneWidget);
  });

  testWidgets('editing a holiday', (tester) async {
    await _open(tester, '/holidays');
    await tester.tap(find.byTooltip('Edit Gandhi Jayanti'));
    await tester.pumpAndSettle();
    expect(find.text('Edit holiday'), findsOneWidget);
    await tester.enterText(_input('Holiday name'), 'Gandhi Jayanti (office)');
    await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Gandhi Jayanti (office)'), findsOneWidget);
  });

  testWidgets('deleting asks first', (tester) async {
    await _open(tester, '/holidays');
    await tester.tap(find.byTooltip('Delete Republic Day'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Republic Day?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Republic Day'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete Republic Day'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete holiday').last);
    await tester.pumpAndSettle();
    expect(find.text('Republic Day deleted'), findsOneWidget);
    expect(find.text('2 holidays'), findsOneWidget);
  });

  testWidgets('a new holiday shows on attendance with no absences', (
    tester,
  ) async {
    final router = await _open(tester, '/holidays');
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday'));
    await tester.pumpAndSettle();
    // Friday 25 Sep: a normal working day until now.
    await tester.tap(find.text('Select date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('25').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(_input('Holiday name'), 'Office closed');
    await tester.tap(find.widgetWithText(FilledButton, 'Add holiday').last);
    await tester.pumpAndSettle();

    router.go('/attendance');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Previous day'));
    await tester.pumpAndSettle();
    expect(find.text('Fri, 25 Sep 2026'), findsOneWidget);
    expect(find.textContaining('Absent'), findsWidgets); // the tile label
    expect(find.text('Holiday'), findsWidgets);
  });
}
