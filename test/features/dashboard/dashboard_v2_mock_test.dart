import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

void main() {
  test("today's figures cover only employees scheduled to work", () async {
    final container = createTestContainer();
    final summary = await container
        .read(dashboardRemoteDataSourceProvider)
        .summary(testNow);

    expect(summary.holiday, isNull);
    expect(summary.scheduledToday, isNotNull);
    expect(
      summary.presentToday + summary.onLeaveToday + summary.absentToday,
      summary.scheduledToday,
    );
    // Monday 28 Sep: people with Monday off are not absent.
    expect(
      summary.scheduledToday! + summary.weekOffToday,
      lessThanOrEqualTo(summary.totalEmployees),
    );
    expect(summary.overtimeMinutesThisMonth, isNotNull);
    expect(summary.overtimeEmployeesThisMonth, greaterThan(0));
    expect(summary.notPunchedInTotal, summary.absentToday);
  });

  test('on a company holiday nobody is absent', () async {
    final container = createTestContainer();
    final summary = await container
        .read(dashboardRemoteDataSourceProvider)
        .summary(DateTime(2026, 10, 2)); // Gandhi Jayanti in the mock

    expect(summary.holiday?.name, 'Gandhi Jayanti');
    expect(summary.scheduledToday, 0);
    expect(summary.absentToday, 0);
    expect(summary.presentPercent, isNull);
    expect(
      summary.attention.map((a) => a.kind),
      isNot(contains(AttentionKind.notPunchedIn)),
    );
  });

  test('the chart leaves out days nobody was scheduled', () async {
    final container = createTestContainer();
    final month = await container
        .read(dashboardRemoteDataSourceProvider)
        .monthlyAttendance(DateTime(2026, 9));
    expect(month.days, isNotEmpty);
    // Sundays are everyone's weekly off in the mock schedules.
    expect(month.days.where((d) => d.date.weekday == DateTime.sunday), isEmpty);
    expect(month.days.every((d) => d.percent >= 0 && d.percent <= 100), true);
  });

  test('overtime only for users who may see it', () async {
    final container = createTestContainer();
    final store = container.read(mockAccessStoreProvider)
      ..setPermissions('u4', const ['dashboard.view'])
      ..resume('u4');
    final dashboard = container.read(dashboardRemoteDataSourceProvider);
    final summary = await dashboard.summary(testNow);
    expect(summary.overtimeMinutesThisMonth, isNull);
    expect(summary.presentToday, greaterThan(0));

    // Needs dashboard.view only, not attendance.view (regression).
    store.setPermissions('u4', const []);
    await expectLater(
      dashboard.summary(testNow),
      throwsA(isA<ForbiddenException>()),
    );
  });
}
