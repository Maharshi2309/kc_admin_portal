import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/widgets/attendance_month_chart.dart';

/// "Attendance this month" card with its own loading and error states, so a
/// chart failure never hides the rest of the dashboard.
class AttendanceChartCard extends ConsumerWidget {
  const AttendanceChartCard({required this.onViewDetails, super.key});

  /// Null hides "Details" (the role can't open Attendance).
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthly = ref.watch(monthlyAttendanceProvider);
    final today = ref.watch(clockProvider)().dateOnly;

    return LayoutBuilder(
      builder: (context, constraints) {
        // On narrow cards (or with large text) the figures move under the
        // title so it keeps room.
        final narrow =
            constraints.maxWidth <
            MediaQuery.textScalerOf(context).scale(AppBreakpoints.tablet);
        final figures = monthly.value == null
            ? const <Widget>[]
            : _headlineFigures(monthly.value!, today);

        return SectionCard(
          title: 'Attendance this month',
          subtitle: 'Daily attendance %, ${AppDateFormat.monthYear(today)}',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s16,
            children: [
              if (!narrow) ...figures,
              if (onViewDetails != null)
                AppLink(label: 'Details', onPressed: onViewDetails),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s16,
            children: [
              if (narrow && figures.isNotEmpty)
                Wrap(
                  spacing: AppSpacing.s24,
                  runSpacing: AppSpacing.s12,
                  children: figures,
                ),
              // The chart sizes itself; loading, error and empty states keep
              // at least the chart's height but may grow (e.g. error + retry).
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AttendanceMonthChart.height,
                ),
                child: AsyncValueView<MonthlyAttendanceModel>(
                  value: monthly,
                  compact: true,
                  onRetry: () => ref.invalidate(monthlyAttendanceProvider),
                  isEmpty: (data) => data.days.isEmpty,
                  empty: const AppEmptyView(
                    compact: true,
                    icon: Icons.bar_chart_rounded,
                    title: 'No attendance recorded yet this month',
                  ),
                  data: (data) =>
                      AttendanceMonthChart(days: data.days, today: today),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// "Today 84%" and "Average 86.4%" beside the title. Labelling today
  /// directly means its highlighted bar is not identified by color alone.
  List<Widget> _headlineFigures(MonthlyAttendanceModel data, DateTime today) {
    final todayValue = data.days
        .where((day) => AppDateFormat.isSameDay(day.date, today))
        .firstOrNull;
    return [
      if (todayValue != null)
        _Figure(label: 'Today', value: FormatUtils.percent(todayValue.percent)),
      if (data.averagePercent != null)
        _Figure(
          label: 'Average',
          value: FormatUtils.percent(data.averagePercent!),
        ),
    ];
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: AppTextStyles.statSmall),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
