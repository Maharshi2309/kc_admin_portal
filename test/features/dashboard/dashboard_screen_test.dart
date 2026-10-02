import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/kpi_card.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

Future<void> _pumpDashboard(
  WidgetTester tester, {
  FakeDashboardRepository? dashboard,
  Size size = const Size(1440, 1000),
}) async {
  await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    dashboard: dashboard,
    size: size,
  );
}

void main() {
  testWidgets('shows the greeting, KPIs, chart and lists', (tester) async {
    await _pumpDashboard(tester);

    expect(find.text('Good afternoon, Test'), findsOneWidget);
    expect(find.byType(KpiCard), findsNWidgets(5)); // with overtime
    expect(find.text('124'), findsOneWidget);
    expect(find.text('84%'), findsWidgets); // KPI and "Today" figure
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.text('86.4%'), findsOneWidget); // monthly average
    expect(find.text('Rohan Patel'), findsOneWidget);
    expect(find.text('Till 30 Sep · 3 days'), findsOneWidget);
    expect(find.text('1,176 days'), findsOneWidget);
  });

  testWidgets('attention list shows known items only', (tester) async {
    await _pumpDashboard(tester);

    expect(find.text('11 not punched in'), findsOneWidget);
    expect(find.text('3 leave requests pending'), findsOneWidget);
    // The unknown kind (count 5) is ignored, so the badge counts 2 items.
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('cards open their sections', (tester) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
    );

    await tester.tap(find.text('View employees'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/employees');
  });

  testWidgets('a failed summary shows a retry that recovers', (tester) async {
    final dashboard = FakeDashboardRepository(
      summaryError: const NetworkException(),
    );
    await _pumpDashboard(tester, dashboard: dashboard);

    expect(find.text(const NetworkException().message), findsOneWidget);
    expect(find.byType(KpiCard), findsNothing);

    dashboard.summaryError = null;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.byType(KpiCard), findsNWidgets(5));
  });

  testWidgets('a failed chart does not hide the rest of the dashboard', (
    tester,
  ) async {
    await _pumpDashboard(
      tester,
      dashboard: FakeDashboardRepository(monthlyError: const ServerException()),
    );

    expect(find.byType(KpiCard), findsNWidgets(5));
    expect(find.byType(BarChart), findsNothing);
    expect(find.text('Try again'), findsOneWidget);
  });

  const sizes = {
    'smallest phone': Size(320, 640),
    'phone': Size(390, 844),
    'tablet': Size(820, 1180),
    'laptop': Size(1280, 800),
    'large desktop': Size(1920, 1080),
  };
  for (final entry in sizes.entries) {
    testWidgets('renders without overflow on ${entry.key}', (tester) async {
      await _pumpDashboard(tester, size: entry.value);
      await tester.dragUntilVisible(
        find.text('Leave used · 2026'),
        find.byType(Scrollable).first,
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
