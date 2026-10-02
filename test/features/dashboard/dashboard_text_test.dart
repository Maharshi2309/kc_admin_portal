import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_mock_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/dashboard_text.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';

LeaveTodayModel _leave({
  required DateTime end,
  double days = 1,
  bool halfDay = false,
}) => LeaveTodayModel(
  employee: const EmployeeSummaryModel(id: '1', name: 'A B', ecNumber: 'EC-1'),
  leaveType: 'Casual',
  endDate: end,
  days: days,
  isHalfDay: halfDay,
);

void main() {
  final today = DateTime(2026, 9, 28);

  group('greeting', () {
    test('uses the time of day and first name', () {
      expect(
        DashboardText.greeting(DateTime(2026, 9, 28, 9), 'Aarav Shah'),
        'Good morning, Aarav',
      );
      expect(
        DashboardText.greeting(DateTime(2026, 9, 28, 14), 'Admin'),
        'Good afternoon, Admin',
      );
      expect(
        DashboardText.greeting(DateTime(2026, 9, 28, 19), null),
        'Good evening',
      );
    });
  });

  group('leaveUntil', () {
    test('describes how long the leave lasts', () {
      expect(
        DashboardText.leaveUntil(
          _leave(end: DateTime(2026, 9, 30), days: 3),
          today,
        ),
        'Till 30 Sep · 3 days',
      );
      expect(DashboardText.leaveUntil(_leave(end: today), today), 'Today only');
      expect(
        DashboardText.leaveUntil(
          _leave(end: today, days: 0.5, halfDay: true),
          today,
        ),
        'Half day',
      );
    });
  });

  group('FormatUtils', () {
    test('count, percent and days', () {
      expect(FormatUtils.count(1176), '1,176');
      expect(FormatUtils.percent(84), '84%');
      expect(FormatUtils.percent(86.44), '86.4%');
      expect(FormatUtils.days(1), '1 day');
      expect(FormatUtils.days(1176), '1,176 days');
      expect(FormatUtils.days(0.5), '0.5 days');
    });
  });

  group('DashboardMockDataSource', () {
    test('monthly data skips Sundays and future days', () async {
      final source = DashboardMockDataSource(
        now: () => DateTime(2026, 9, 10, 12),
      );
      final month = await source.monthlyAttendance(DateTime(2026, 9));

      expect(month.days, isNotEmpty);
      expect(
        month.days.every((d) => d.date.weekday != DateTime.sunday),
        isTrue,
      );
      expect(month.days.last.date, DateTime(2026, 9, 10));
      expect(month.averagePercent, isNotNull);
    });
  });
}
