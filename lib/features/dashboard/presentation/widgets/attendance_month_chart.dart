import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';

/// Daily attendance % for the month as bars. Today's bar is emphasised; every
/// bar shows its date and value on hover/tap. One series, so no legend: the
/// card title names it.
class AttendanceMonthChart extends StatelessWidget {
  const AttendanceMonthChart({
    required this.days,
    required this.today,
    super.key,
  });

  final List<DailyAttendanceModel> days;
  final DateTime today;

  static const double height = 230;
  static const double _maxPercent = 100;
  static const double _gridStep = 25;
  static const double _axisLabelWidth = 48;
  static const double _bottomLabelHeight = 24;
  static const double _barGap = 2;
  static const double _maxBarWidth = 24;
  static const double _minLabelSpacing = 36;
  static const double _barRadius = 4;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticSummary(),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final plotWidth = constraints.maxWidth - _axisLabelWidth;
              final slot = plotWidth / math.max(days.length, 1);
              final barWidth = (slot - _barGap).clamp(1.0, _maxBarWidth);
              final labelEvery = math.max(1, (_minLabelSpacing / slot).ceil());
              return BarChart(_chartData(barWidth, labelEvery));
            },
          ),
        ),
      ),
    );
  }

  bool _isToday(DailyAttendanceModel day) =>
      AppDateFormat.isSameDay(day.date, today);

  BarChartData _chartData(double barWidth, int labelEvery) {
    final axisStyle = AppTextStyles.caption.copyWith(
      color: AppColors.textMuted,
    );

    return BarChartData(
      minY: 0,
      maxY: _maxPercent,
      alignment: BarChartAlignment.spaceAround,
      barGroups: [
        for (var i = 0; i < days.length; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: days[i].percent.clamp(0, _maxPercent),
                width: barWidth,
                color: _isToday(days[i])
                    ? AppColors.chartBarHighlight
                    : AppColors.chartBar,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_barRadius),
                ),
              ),
            ],
          ),
      ],
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: _gridStep,
        getDrawingHorizontalLine: (_) =>
            const FlLine(color: AppColors.divider, strokeWidth: 1),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(bottom: BorderSide(color: AppColors.chartAxis)),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _gridStep,
            reservedSize: _axisLabelWidth,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              meta: meta,
              child: Text(
                FormatUtils.percent(value),
                style: axisStyle,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: _bottomLabelHeight,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              final show = index % labelEvery == 0 || _isToday(days[index]);
              return SideTitleWidget(
                meta: meta,
                child: show
                    ? Text('${days[index].date.day}', style: axisStyle)
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => AppColors.inverse,
          tooltipBorderRadius: AppRadius.smAll,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s10,
            vertical: AppSpacing.s6,
          ),
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItem: (group, _, rod, _) {
            final day = days[group.x];
            return BarTooltipItem(
              '${AppDateFormat.dayMonth(day.date)}\n',
              AppTextStyles.caption.copyWith(color: AppColors.onInverseMuted),
              children: [
                TextSpan(
                  text: FormatUtils.percent(day.percent),
                  style: AppTextStyles.bodyBold.copyWith(
                    color: AppColors.onInverse,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// What a screen reader announces instead of the bars.
  String _semanticSummary() {
    if (days.isEmpty) return 'No attendance recorded yet this month';
    final values = days
        .map(
          (d) =>
              '${AppDateFormat.dayMonth(d.date)} ${FormatUtils.percent(d.percent)}',
        )
        .join(', ');
    return 'Daily attendance percentage: $values';
  }
}
