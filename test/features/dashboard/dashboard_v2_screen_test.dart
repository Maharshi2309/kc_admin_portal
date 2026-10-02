import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

Future<void> _open(WidgetTester tester, DashboardSummaryModel summary) async {
  await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    dashboard: FakeDashboardRepository(summary: summary),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows who is scheduled, and the overtime this month', (
    tester,
  ) async {
    await _open(
      tester,
      testSummary.copyWith(
        scheduledToday: 118,
        weekOffToday: 6,
        weekOffWorkedToday: 2,
        overtimeMinutesThisMonth: 2550,
        overtimeEmployeesThisMonth: 8,
      ),
    );
    expect(
      find.text(
        '118 scheduled to work today · 6 on weekly off · '
        '2 working their day off',
      ),
      findsOneWidget,
    );
    expect(find.text('Overtime this month'), findsOneWidget);
    expect(find.text('42h 30m'), findsOneWidget);
    expect(find.text('8 employees'), findsOneWidget);
  });

  testWidgets('without overtime figures there is no overtime card', (
    tester,
  ) async {
    await _open(
      tester,
      testSummary.copyWith(
        scheduledToday: null,
        overtimeMinutesThisMonth: null,
        overtimeEmployeesThisMonth: null,
      ),
    );
    expect(find.text('Overtime this month'), findsNothing);
    // An older backend: the general subtitle.
    expect(find.textContaining("Here's today at a glance"), findsOneWidget);
  });

  testWidgets('a company holiday: banner, and nobody to punch in', (
    tester,
  ) async {
    await _open(
      tester,
      testSummary.copyWith(
        date: DateTime(2026, 10, 2),
        holiday: HolidayModel(
          id: '12',
          date: DateTime(2026, 10, 2),
          name: 'Gandhi Jayanti',
        ),
        scheduledToday: 0,
        presentToday: 0,
        onLeaveToday: 0,
        absentToday: 0,
        presentPercent: null,
        onLeavePercent: null,
        absentPercent: null,
        holidayWorkedToday: 2,
        notPunchedIn: const [],
        notPunchedInTotal: 0,
        attention: const [
          AttentionItemModel(kind: AttentionKind.pendingLeave, count: 3),
        ],
      ),
    );
    expect(
      find.text('Today is a company holiday: Gandhi Jayanti'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Nobody is marked absent today. 2 employees are working; their '
        'hours count as overtime.',
      ),
      findsOneWidget,
    );
    expect(find.text('Nobody is scheduled to work today'), findsWidgets);
    expect(find.text('Everyone has punched in'), findsNothing);
  });
}
