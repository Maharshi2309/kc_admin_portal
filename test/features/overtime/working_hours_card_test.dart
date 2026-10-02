import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/overtime/presentation/widgets/working_hours_card.dart';

import '../../helpers/fake_auth.dart';

Future<void> _openProfile(
  WidgetTester tester, {
  bool canSeeOvertime = true,
}) async {
  final user = canSeeOvertime
      ? testUser
      : testUser.copyWith(
          permissions: [
            for (final p in testUser.permissions)
              if (p != AppPermission.overtimeView.key) p,
          ],
        );
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: user),
    size: const Size(1440, 2400),
  );
  router.go('/employees/1');
  await tester.pumpAndSettle();
}

Future<void> _choosePeriod(WidgetTester tester, String period) async {
  await tester.tap(find.textContaining('Period'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(period).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("shows this month's working hours and overtime", (tester) async {
    await _openProfile(tester);
    expect(find.text('Working hours & overtime'), findsOneWidget);
    expect(
      find.text(AppDateFormat.range(DateTime(2026, 9), DateTime(2026, 9, 28))),
      findsOneWidget,
    );
    for (final label in ['Expected', 'Worked', 'Overtime']) {
      expect(
        find.descendant(
          of: find.byType(WorkingHoursCard),
          matching: find.text(label),
        ),
        findsWidgets,
        reason: label,
      );
    }
    expect(find.textContaining('a day is'), findsOneWidget);
    // One month: no monthly breakdown.
    expect(find.text('By month'), findsNothing);
  });

  testWidgets('a longer period shows each month', (tester) async {
    await _openProfile(tester);
    await _choosePeriod(tester, 'Last 3 months');
    expect(
      find.text(AppDateFormat.range(DateTime(2026, 7), DateTime(2026, 9, 28))),
      findsOneWidget,
    );
    expect(find.text('By month'), findsOneWidget);
    expect(find.text('July 2026'), findsOneWidget);
    expect(find.text('September 2026'), findsWidgets);
  });

  testWidgets('long lists show the first days, then all', (tester) async {
    await _openProfile(tester);
    await _choosePeriod(tester, 'This year');
    final showAll = find.textContaining(RegExp(r'^Show all \d+$'));
    expect(showAll, findsOneWidget);
    await tester.ensureVisible(showAll);
    await tester.pumpAndSettle();
    await tester.tap(showAll);
    await tester.pumpAndSettle();
    expect(find.text('Show fewer'), findsOneWidget);
  });

  testWidgets('hidden without overtime.view', (tester) async {
    await _openProfile(tester, canSeeOvertime: false);
    expect(find.byType(WorkingHoursCard), findsNothing);
  });
}
