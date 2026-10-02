import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';

/// Display text for the dashboard, kept out of widgets so it can be tested.
abstract final class DashboardText {
  static const int _afternoonStartsAt = 12;
  static const int _eveningStartsAt = 17;

  /// "Good morning, Aarav" (first name only).
  static String greeting(DateTime now, String? fullName) {
    final part = switch (now.hour) {
      < _afternoonStartsAt => 'Good morning',
      < _eveningStartsAt => 'Good afternoon',
      _ => 'Good evening',
    };
    final firstName = fullName?.trim().split(RegExp(r'\s+')).first;
    return firstName == null || firstName.isEmpty ? part : '$part, $firstName';
  }

  /// Who is expected today: "118 scheduled to work · 6 on weekly off · 2
  /// working their day off". Null when the backend doesn't send it.
  static String? scheduleLine(DashboardSummaryModel summary) {
    final scheduled = summary.scheduledToday;
    if (scheduled == null) return null;
    final offDayWork = summary.holidayWorkedToday + summary.weekOffWorkedToday;
    return [
      scheduled == 0
          ? 'Nobody is scheduled to work today'
          : '${FormatUtils.count(scheduled)} scheduled to work today',
      if (summary.weekOffToday > 0)
        '${FormatUtils.count(summary.weekOffToday)} on weekly off',
      if (offDayWork > 0)
        offDayWork == 1
            ? '1 working their day off'
            : '${FormatUtils.count(offDayWork)} working their day off',
    ].join(' · ');
  }

  /// The holiday banner: "2 employees are working today; their hours count
  /// as overtime."
  static String holidayMessage(DashboardSummaryModel summary) {
    final working = summary.holidayWorkedToday;
    const base = 'Nobody is marked absent today.';
    if (working == 0) return base;
    return '$base ${working == 1 ? '1 employee is' : '$working employees are'} '
        'working; their hours count as overtime.';
  }

  /// "Half day", "Today only" or "Till 30 Sep · 3 days".
  static String leaveUntil(LeaveTodayModel leave, DateTime today) {
    if (leave.isHalfDay) return 'Half day';
    if (AppDateFormat.isSameDay(leave.endDate, today)) return 'Today only';
    return 'Till ${AppDateFormat.dayMonth(leave.endDate)} · '
        '${FormatUtils.days(leave.days)}';
  }
}
