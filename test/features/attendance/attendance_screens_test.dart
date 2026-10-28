import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/features/attendance/presentation/widgets/attendance_log_list.dart';

import '../../helpers/fake_auth.dart';

Future<GoRouter> _open(
  WidgetTester tester,
  String location, {
  Size size = const Size(1440, 1200),
  bool mockDashboard = false,
}) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    size: size,
    mockDashboard: mockDashboard,
  );
  router.go(location);
  await tester.pumpAndSettle();
  return router;
}

/// The status tile labelled [label].
Finder _tile(String label) => find.bySemanticsLabel(RegExp('^$label: '));

void main() {
  group('daily attendance', () {
    testWidgets('shows shift, tiles, banner and rows', (tester) async {
      await _open(tester, '/attendance');

      expect(
        find.text("Hours follow each employee's own schedule"),
        findsOneWidget,
      );
      expect(find.text('Today · Mon, 28 Sep 2026'), findsOneWidget);
      expect(find.text('3 employees have not punched in yet'), findsOneWidget);
      expect(find.text('Rohan Patel'), findsOneWidget);
      expect(find.text('Late by 38 Minutes'), findsWidgets);
      // Each row shows that employee's own hours.
      expect(find.textContaining('10:00–18:30'), findsWidgets);
      expect(find.textContaining('09:00–17:30'), findsWidgets);
    });

    testWidgets('a status tile filters the list', (tester) async {
      await _open(tester, '/attendance');
      await tester.tap(_tile('On leave'));
      await tester.pumpAndSettle();

      expect(find.text('Harsh Vaghela'), findsOneWidget);
      expect(find.text('Rohan Patel'), findsNothing);
    });

    testWidgets('punching in updates the row', (tester) async {
      await _open(tester, '/attendance');
      await tester.tap(find.widgetWithText(FilledButton, 'Punch in').first);
      await tester.pumpAndSettle();

      // Absentees are listed by name, so Ishaan Trivedi is first.
      expect(find.text('Ishaan Trivedi punched in'), findsOneWidget);
      expect(find.text('2 employees have not punched in yet'), findsOneWidget);
    });

    testWidgets('punch in all asks first, then clears the banner', (
      tester,
    ) async {
      await _open(tester, '/attendance');
      await tester.tap(find.widgetWithText(FilledButton, 'Punch in all'));
      await tester.pumpAndSettle();
      expect(find.text('Punch in 3 employees?'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.widgetWithText(FilledButton, 'Punch in all'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 employees punched in'), findsOneWidget);
      expect(find.textContaining('not punched in yet'), findsNothing);
    });

    testWidgets('past days have no punch buttons and next is limited', (
      tester,
    ) async {
      await _open(tester, '/attendance');
      final next = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Next day'),
          matching: find.byType(IconButton),
        ),
      );
      expect(next.onPressed, isNull);

      await tester.tap(find.byTooltip('Previous day'));
      await tester.pumpAndSettle();
      expect(find.text('Sun, 27 Sep 2026'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Punch in'), findsNothing);
    });
  });

  group('correction dialog', () {
    testWidgets('requires a reason, then saves', (tester) async {
      final router = await _open(tester, '/attendance');
      await tester.tap(find.byTooltip('Correct attendance for Arjun Joshi'));
      await tester.pumpAndSettle();
      expect(find.byType(AppDialog), findsOneWidget);
      expect(find.text('Recorded: in 10:38 · out —'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Save correction'));
      await tester.pumpAndSettle();
      expect(find.text('Choose a reason'), findsOneWidget);

      await tester.tap(find.text('Device issue'));
      // Arjun's own start time, not a company-wide shift.
      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Shift start 10:00'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save correction'));
      await tester.pumpAndSettle();

      expect(find.byType(AppDialog), findsNothing);
      expect(currentLocation(router), '/attendance');
      expect(find.text('Attendance corrected for Arjun Joshi'), findsOneWidget);
      expect(find.text('Corrected: Device issue'), findsOneWidget);
    });

    testWidgets('adds a missing record for someone not punched in', (
      tester,
    ) async {
      final router = await _open(tester, '/attendance');
      final add = find.byTooltip('Add attendance for Rohan Patel');
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();

      expect(currentLocation(router), startsWith('/attendance/new?'));
      expect(find.text('Add attendance'), findsOneWidget);
      expect(find.text('No record yet'), findsOneWidget);

      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Shift start 10:00'),
      );
      await tester.tap(find.text('Forgot to punch'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Attendance added for Rohan Patel'), findsOneWidget);
    });

    testWidgets('recording work on a weekly off', (tester) async {
      // Sunday 27 Sep is Aarav Shah's weekly off.
      await _open(tester, '/attendance');
      await tester.tap(find.byTooltip('Previous day'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Add attendance for Aarav Shah'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('This is a weekly off for Aarav Shah'),
        findsOneWidget,
      );

      await tester.tap(find.text('Set time').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('On field duty'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save attendance'));
      await tester.pumpAndSettle();

      expect(find.text('Attendance added for Aarav Shah'), findsOneWidget);
    });

    testWidgets('an invalid add link returns to the list', (tester) async {
      final router = await _open(tester, '/attendance/new?employeeId=1');
      expect(currentLocation(router), '/attendance');
    });
  });

  testWidgets('dashboard punch in works and updates the dashboard', (
    tester,
  ) async {
    await _open(tester, '/dashboard', mockDashboard: true);
    expect(find.text('3 not punched in'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Punch in').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('punched in'), findsWidgets);
    expect(find.text('2 not punched in'), findsOneWidget);
  });

  testWidgets('profile shows the attendance log tab', (tester) async {
    await _open(tester, '/employees/1');
    await tester.tap(find.textContaining('Attendance log'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AttendanceLogList),
        matching: find.text('Mon, 28 Sep 2026'),
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Correct 28 Sep 2026'), findsOneWidget);
  });

  testWidgets('the attendance log opens the correction for that day', (
    tester,
  ) async {
    final router = await _open(tester, '/employees/1');
    await tester.tap(find.textContaining('Attendance log'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Correct 28 Sep 2026'));
    await tester.pumpAndSettle();

    expect(
      currentLocation(router),
      matches(RegExp(r'^/attendance/[^/]+/edit$')),
    );
    expect(find.text('Correct attendance'), findsWidgets);
  });

  testWidgets('the attendance log works as a list on phones', (tester) async {
    await _open(tester, '/employees/1', size: const Size(390, 844));
    final tab = find.textContaining('Attendance log');
    await tester.ensureVisible(tab);
    await tester.pumpAndSettle();
    await tester.tap(tab);
    await tester.pumpAndSettle();

    final log = find.byType(AttendanceLogList);
    await tester.ensureVisible(log);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: log, matching: find.textContaining('In ')),
      findsWidgets,
    );
  });

  group('no overflow', () {
    const sizes = {
      'smallest phone': Size(320, 640),
      'tablet': Size(820, 1180),
      'large desktop': Size(1920, 1080),
    };
    for (final size in sizes.entries) {
      for (final location in ['/attendance', '/attendance/7-20260928/edit']) {
        testWidgets('$location on ${size.key}', (tester) async {
          await _open(tester, location, size: size.value);
          await tester.drag(
            find.byType(Scrollable).last,
            const Offset(0, -3000),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
