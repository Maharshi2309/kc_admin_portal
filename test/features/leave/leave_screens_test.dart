import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';
import 'package:kc_admin_portal/features/leave/data/repositories/leave_repository_impl.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_auth.dart';

Future<GoRouter> _open(
  WidgetTester tester,
  String location, {
  Size size = const Size(1440, 1200),
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

Finder _day(String label) => find.bySemanticsLabel(RegExp('^$label'));

/// Scrolls [finder] into view inside the drawer, then taps it.
Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('leave list', () {
    // The design's desktop table; on touch screens "Added by" gives way to
    // the larger action buttons.
    testWidgets(
      'shows tabs with counts and the design rows',
      variant: TargetPlatformVariant.only(TargetPlatform.macOS),
      (tester) async {
        await _open(tester, '/leave');

        expect(find.bySemanticsLabel('Pending, 3'), findsOneWidget);
        expect(find.text('Dhruv Parmar'), findsOneWidget);
        expect(find.text('Employee request'), findsWidgets);
        expect(find.widgetWithText(FilledButton, 'Approve'), findsWidgets);
      },
    );

    testWidgets('a tab filters by status', (tester) async {
      await _open(tester, '/leave');
      await tester.tap(find.bySemanticsLabel('Rejected, 1'));
      await tester.pumpAndSettle();

      expect(find.text('Rohan Patel'), findsOneWidget);
      expect(find.text('Dhruv Parmar'), findsNothing);
    });

    testWidgets('approving a pending request', (tester) async {
      await _open(tester, '/leave');
      await tester.tap(find.bySemanticsLabel('Pending, 3'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Approve').first);
      await tester.pumpAndSettle();

      expect(find.textContaining('Leave approved for'), findsOneWidget);
      expect(find.bySemanticsLabel('Pending, 2'), findsOneWidget);
    });

    testWidgets('rejecting asks for confirmation', (tester) async {
      await _open(tester, '/leave');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reject').first);
      await tester.pumpAndSettle();
      expect(find.text('Reject this leave?'), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Reject leave'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Leave rejected for'), findsOneWidget);
    });

    testWidgets('cancelling approved leave keeps it as cancelled', (
      tester,
    ) async {
      await _open(tester, '/leave');
      await tester.tap(find.byTooltip('More actions for leave of Priya Desai'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel leave'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel leave'));
      await tester.pumpAndSettle();

      expect(find.text('Leave cancelled for Priya Desai'), findsOneWidget);
      expect(find.bySemanticsLabel('Cancelled, 2'), findsOneWidget);
    });
  });

  group('add leave drawer', () {
    testWidgets('full flow: employee, type, dates, summary, save', (
      tester,
    ) async {
      final router = await _open(tester, '/leave/add');
      expect(find.byType(AppSideSheet), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Search by name or EC number'),
        'Sanjay',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sanjay Makwana'));
      await tester.pumpAndSettle();
      // 1 Casual day earned per month since January.
      expect(find.bySemanticsLabel('Casual, 9 days available'), findsOneWidget);
      expect(find.bySemanticsLabel('Unpaid, No fixed balance'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Casual, 9 days available'));
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('Holiday · 2 Oct Gandhi Jayanti'), findsOneWidget);
      await _tapVisible(tester, _day('Mon, 5 Oct 2026'));
      await _tapVisible(tester, _day('Wed, 7 Oct 2026'));

      expect(find.text('Mon 5 – Wed 7 Oct'), findsOneWidget);
      expect(find.text('3 days · calculated'), findsOneWidget);
      // October's day is earned by then.
      expect(find.text('10 days'), findsOneWidget);
      expect(find.text('Not enough Casual leave'), findsNothing);

      await _tapVisible(tester, find.text('Travel'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();

      expect(find.byType(AppSideSheet), findsNothing);
      expect(currentLocation(router), '/leave');
      expect(find.text('Leave added for Sanjay Makwana'), findsOneWidget);
    });

    testWidgets("an employee's own weekly offs are not counted", (
      tester,
    ) async {
      await _open(tester, '/leave/add');
      await tester.enterText(
        find.widgetWithText(TextField, 'Search by name or EC number'),
        'Rohan',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rohan Patel').last); // the picker's match
      await tester.pumpAndSettle();
      // Rohan has Saturday and Sunday off.
      expect(
        find.text('Saturdays and Sundays are not counted'),
        findsOneWidget,
      );

      await tester.tap(find.bySemanticsLabel(RegExp('^Casual')));
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      await _tapVisible(tester, _day('Sat, 3 Oct 2026'));
      await _tapVisible(tester, _day('Mon, 5 Oct 2026'));
      expect(find.text('1 day · calculated'), findsOneWidget);
    });

    testWidgets('shows what is missing', (tester) async {
      await _open(tester, '/leave/add');
      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();

      expect(find.text('Choose an employee'), findsOneWidget);
      expect(find.text('Choose a leave type'), findsOneWidget);
      expect(find.text('Choose the leave dates'), findsOneWidget);
      expect(find.text('Choose a reason'), findsOneWidget);
    });

    testWidgets('profile "Add leave" pre-selects the employee', (tester) async {
      await _open(tester, '/employees/1');
      await tester.tap(find.widgetWithText(FilledButton, 'Add leave'));
      await tester.pumpAndSettle();

      expect(find.byType(AppSideSheet), findsOneWidget);
      expect(find.text('KC1001 · Graphic Designer'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(r'^Casual, \d+ days? available$')),
        findsOneWidget,
      );
    });

    testWidgets('Casual beyond the balance: refused, or split when asked', (
      tester,
    ) async {
      final router = await _open(tester, '/leave/add');
      await tester.enterText(
        find.widgetWithText(TextField, 'Search by name or EC number'),
        'Sanjay',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sanjay Makwana'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel(RegExp('^Casual')));
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      // Mon 5 – Sat 17 Oct: 12 working days, 10 earned by October.
      await _tapVisible(tester, _day('Mon, 5 Oct 2026'));
      await _tapVisible(tester, _day('Sat, 17 Oct 2026'));

      expect(find.text('12 days · calculated'), findsOneWidget);
      expect(find.text('10 Casual + 2 Unpaid'), findsOneWidget);
      expect(find.text('Not enough Casual leave'), findsOneWidget);

      // Without the choice the server refuses it.
      await _tapVisible(tester, find.text('Travel'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSideSheet), findsOneWidget);
      expect(
        find.textContaining('Only 10 days of Casual leave are available'),
        findsOneWidget,
      );

      await _tapVisible(tester, find.text('Save the extra 2 days as Unpaid'));
      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSideSheet), findsNothing);
      expect(currentLocation(router), '/leave');
      expect(find.text('Leave added for Sanjay Makwana'), findsOneWidget);
    });

    /// Opens Dhruv Parmar's pending leave (5–7 Oct) for editing.
    Future<void> openDhruvsEdit(WidgetTester tester) async {
      await tester.tap(
        find.byTooltip('More actions for leave of Dhruv Parmar'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit leave'));
      await tester.pumpAndSettle();
    }

    testWidgets('editing pending leave keeps the employee fixed', (
      tester,
    ) async {
      await _open(tester, '/leave');
      await openDhruvsEdit(tester);

      expect(find.text('Edit leave'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Change'), findsNothing);
      expect(find.text('3 days · calculated'), findsOneWidget);
    });

    testWidgets('saving an edit updates the row', (tester) async {
      final router = await _open(tester, '/leave');
      await openDhruvsEdit(tester);

      // Shorten 5–7 Oct to a single day.
      await _tapVisible(tester, _day('Mon, 5 Oct 2026'));
      await _tapVisible(tester, _day('Mon, 5 Oct 2026'));
      expect(find.text('1 day · calculated'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();

      expect(find.byType(AppSideSheet), findsNothing);
      expect(currentLocation(router), '/leave');
      expect(find.text('Leave updated for Dhruv Parmar'), findsOneWidget);
      expect(find.text('5 Oct 2026'), findsWidgets);
    });

    testWidgets('approved leave can be cancelled, not edited', (tester) async {
      await _open(tester, '/leave');
      expect(find.byTooltip('Edit leave of Priya Desai'), findsNothing);
      await tester.tap(find.byTooltip('More actions for leave of Priya Desai'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel leave'), findsOneWidget);
      expect(find.text('Edit leave'), findsNothing);
    });

    testWidgets('an old edit link to approved leave explains why not', (
      tester,
    ) async {
      // Priya's approved leave is record 3.
      await _open(tester, '/leave/3/edit');
      expect(find.text('This leave can no longer be edited'), findsOneWidget);
      expect(find.textContaining('this one is approved'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Save leave'), findsNothing);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Close'));
      await tester.pumpAndSettle();
      expect(find.byType(AppSideSheet), findsNothing);
    });

    testWidgets('decided by someone else while editing: saving explains', (
      tester,
    ) async {
      await _open(tester, '/leave');
      await openDhruvsEdit(tester);

      // Another admin approves it meanwhile.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(AppSideSheet)),
      );
      // Real async: the mock's delay doesn't complete in fake test time.
      await tester.runAsync(
        () => container
            .read(leaveRepositoryProvider)
            .setStatus('1', LeaveStatus.approved),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Save leave'));
      await tester.pumpAndSettle();
      expect(find.text('This leave can no longer be edited'), findsOneWidget);
    });
  });

  group('balances tab', () {
    testWidgets('switches from Requests and shows totals and rows', (
      tester,
    ) async {
      final router = await _open(tester, '/leave');
      await tester.tap(find.text('Balances'));
      await tester.pumpAndSettle();
      expect(currentLocation(router), '/leave?view=balances');

      expect(find.text('Totals for 19 active employees'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('^Casual earned: 171 days')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Casual used: 13\.5 days, \+ 9 days')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Casual remaining: 148\.5 days')),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp('^Unpaid taken: 2 days')),
        findsOneWidget,
      );
      // Aarav has used all 9 days earned.
      expect(find.text('Aarav Shah'), findsOneWidget);
      expect(find.text('0 days'), findsOneWidget);

      // Back to Requests.
      await tester.tap(find.text('Requests'));
      await tester.pumpAndSettle();
      expect(currentLocation(router), '/leave');
      expect(find.bySemanticsLabel('Pending, 3'), findsOneWidget);
    });

    testWidgets('search narrows rows and totals; a row opens the profile', (
      tester,
    ) async {
      final router = await _open(tester, '/leave?view=balances');
      await tester.enterText(
        find.widgetWithText(TextField, 'Employee name or EC number'),
        'Priya',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(
        find.text('Totals for 1 active employee matching the filters'),
        findsOneWidget,
      );
      expect(find.text('6 days'), findsWidgets); // remaining (row + total)
      await tester.tap(find.text('Priya Desai'));
      await tester.pumpAndSettle();
      expect(currentLocation(router), '/employees/2');
    });
  });

  group('no overflow', () {
    const sizes = {
      'smallest phone': Size(320, 640),
      'tablet': Size(820, 1180),
      'large desktop': Size(1920, 1080),
    };
    for (final size in sizes.entries) {
      for (final location in ['/leave', '/leave/add?employeeId=1']) {
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
