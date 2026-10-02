import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/calendar/presentation/widgets/employee_calendar_card.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

Future<GoRouter> _open(WidgetTester tester, String location) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    size: const Size(1440, 1100),
  );
  router.go(location);
  await tester.pumpAndSettle();
  return router;
}

/// Only what is inside the day sheet (the profile is behind it).
Finder _inSheet(Finder finder) =>
    find.descendant(of: find.byType(AppSideSheet), matching: finder);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('change history (mock audit log)', () {
    test('day filter: own changes and company-wide ones, newest first', () {
      final log = MockAuditLog(now: () => testNow)
        ..record(
          action: 'attendance.correct',
          summary: 'first',
          employeeId: '1',
          from: DateTime(2026, 9, 25),
        )
        ..record(
          action: 'leave.create',
          summary: 'leave',
          employeeId: '1',
          from: DateTime(2026, 9, 24),
          to: DateTime(2026, 9, 26),
        )
        ..record(
          action: 'holiday.create',
          summary: 'holiday',
          from: DateTime(2026, 9, 25),
        )
        ..record(
          action: 'attendance.correct',
          summary: 'someone else',
          employeeId: '2',
          from: DateTime(2026, 9, 25),
        );
      expect(log.forDay('1', DateTime(2026, 9, 25)).map((e) => e.summary), [
        'holiday',
        'leave',
        'first',
      ]);
      expect(log.forDay('1', DateTime(2026, 9, 27)), isEmpty);
    });
  });

  testWidgets('tapping a calendar day opens its sheet', (tester) async {
    final router = await _open(tester, '/employees/1');
    await _tap(
      tester,
      find.descendant(
        of: find.byType(EmployeeCalendarCard),
        matching: find.bySemanticsLabel(RegExp(r'^Fri, 25 Sep 2026')),
      ),
    );
    expect(currentLocation(router), '/employees/1/calendar/2026-09-25');
    expect(find.byType(AppSideSheet), findsOneWidget);
    expect(find.text('ATTENDANCE'), findsOneWidget);
    expect(find.text('LEAVE'), findsOneWidget);
    expect(find.text('COMPANY HOLIDAY'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
    expect(find.text('No changes recorded for this day.'), findsOneWidget);
  });

  testWidgets('correcting attendance from a day records who changed what', (
    tester,
  ) async {
    final router = await _open(tester, '/employees/1/calendar/2026-09-25');
    await _tap(
      tester,
      find.widgetWithText(OutlinedButton, 'Correct attendance'),
    );
    expect(
      currentLocation(router),
      '/employees/1/calendar/2026-09-25/attendance/1-20260925',
    );
    await _tap(
      tester,
      find.widgetWithText(OutlinedButton, 'Shift start 09:00'),
    );
    await _tap(tester, find.text('Wrong time recorded'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Save correction'));

    // Back on the day, with the change in its history.
    expect(currentLocation(router), '/employees/1/calendar/2026-09-25');
    expect(find.text('Corrected attendance'), findsOneWidget);
    expect(find.textContaining('Punch in:'), findsOneWidget);
    expect(find.textContaining('Wrong time recorded'), findsOneWidget);
    expect(_inSheet(find.text('Corrected')), findsOneWidget);
  });

  testWidgets('recording work on a weekly off from the calendar', (
    tester,
  ) async {
    final router = await _open(tester, '/employees/1/calendar/2026-09-20');
    expect(_inSheet(find.text('Weekly off')), findsOneWidget);
    await _tap(
      tester,
      find.widgetWithText(OutlinedButton, 'Record week-off work'),
    );
    expect(
      currentLocation(router),
      '/employees/1/calendar/2026-09-20/attendance',
    );
    expect(
      find.textContaining('This is a weekly off for Aarav Shah'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Set time').first);
    await _tap(tester, find.text('OK'));
    await _tap(tester, find.text('On field duty'));
    await _tap(tester, find.widgetWithText(FilledButton, 'Save attendance'));

    expect(currentLocation(router), '/employees/1/calendar/2026-09-20');
    expect(_inSheet(find.text('Week off worked')), findsOneWidget);
    expect(find.text('Added attendance'), findsOneWidget);
  });

  testWidgets('approving pending leave from its day', (tester) async {
    // Kavya Mehta (4): pending sick leave on Tue 15 Sep.
    await _open(tester, '/employees/4/calendar/2026-09-15');
    expect(_inSheet(find.text('Pending')), findsOneWidget);
    await _tap(tester, find.widgetWithText(FilledButton, 'Approve'));

    expect(find.text('Leave approved for Kavya Mehta'), findsOneWidget);
    expect(_inSheet(find.text('Approved')), findsOneWidget);
    expect(find.text('Sick leave approved'), findsOneWidget);
    expect(find.textContaining('Status: Pending → Approved'), findsOneWidget);
  });

  testWidgets('marking a company holiday from a day', (tester) async {
    final router = await _open(tester, '/employees/1/calendar/2026-09-25');
    await _tap(
      tester,
      find.widgetWithText(OutlinedButton, 'Mark as company holiday'),
    );
    expect(
      currentLocation(router),
      '/employees/1/calendar/2026-09-25/holiday/new',
    );
    // The date comes from the day.
    expect(find.text('Fri, 25 Sep 2026'), findsWidgets);
    await tester.enterText(
      find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is AppTextField && w.label == 'Holiday name',
        ),
        matching: find.byType(TextField),
      ),
      'Office closed',
    );
    await _tap(tester, find.widgetWithText(FilledButton, 'Add holiday').last);

    expect(currentLocation(router), '/employees/1/calendar/2026-09-25');
    expect(
      find.textContaining('Company holiday · Office closed'),
      findsOneWidget,
    );
    expect(find.text('Company holiday added: Office closed'), findsOneWidget);
  });

  testWidgets('adding leave from a day starts on that day', (tester) async {
    final router = await _open(tester, '/employees/10/calendar/2026-10-06');
    await _tap(tester, find.widgetWithText(OutlinedButton, 'Add leave'));
    expect(
      currentLocation(router),
      '/employees/10/calendar/2026-10-06/leave/new',
    );
    expect(find.text('Sanjay Makwana'), findsWidgets);
    await _tap(tester, find.bySemanticsLabel(RegExp('^Casual')));
    expect(find.text('Tue 6 Oct'), findsWidgets);
  });
}
