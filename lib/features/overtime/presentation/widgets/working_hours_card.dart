import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_date_range_filter.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';
import 'package:kc_admin_portal/features/overtime/domain/utils/overtime_format.dart';
import 'package:kc_admin_portal/features/overtime/presentation/providers/overtime_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// The profile's working hours and overtime for a chosen period: expected,
/// worked and overtime (also as days), month by month, and each day with
/// overtime. Every figure comes from the backend
/// (`GET /employees/{id}/overtime`); the app only converts minutes to days
/// for display, using the day length the backend sends.
class WorkingHoursCard extends ConsumerWidget {
  const WorkingHoursCard({required this.employeeId, super.key});

  final String employeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(overtimeSelectionProvider(employeeId));
    final report = ref.watch(employeeOvertimeProvider(employeeId));

    return SectionCard(
      title: 'Working hours & overtime',
      subtitle: AppDateFormat.range(selection.from, selection.to),
      // The picker sits above the figures (not beside the title), so it can
      // wrap on narrow screens.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          _PeriodPicker(employeeId: employeeId, selection: selection),
          AsyncValueView<OvertimeReportModel>(
            value: report,
            compact: true,
            onRetry: () => ref.invalidate(employeeOvertimeProvider(employeeId)),
            data: (data) => _Report(report: data),
          ),
        ],
      ),
    );
  }
}

class _PeriodPicker extends ConsumerWidget {
  const _PeriodPicker({required this.employeeId, required this.selection});

  final String employeeId;
  final OvertimeSelection selection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(overtimeSelectionProvider(employeeId).notifier);
    final today = ref.watch(clockProvider)().dateOnly;
    final custom = selection.period == OvertimePeriod.custom;
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        AppFilterDropdown<OvertimePeriod>(
          label: 'Period',
          allLabel: null,
          value: selection.period,
          items: [
            for (final p in OvertimePeriod.values)
              if (p != OvertimePeriod.custom)
                AppDropdownItem(value: p, label: p.label),
            if (custom)
              const AppDropdownItem(
                value: OvertimePeriod.custom,
                label: 'Custom',
              ),
          ],
          onChanged: (p) {
            if (p != null) notifier.setPeriod(p);
          },
        ),
        AppDateRangeFilter(
          label: 'Dates',
          anyLabel: 'Pick dates',
          from: custom ? selection.from : null,
          to: custom ? selection.to : null,
          firstDate: DateTime(today.year - 5),
          lastDate: today,
          onChanged: (from, to) => from == null || to == null
              ? notifier.setPeriod(OvertimePeriod.thisMonth)
              : notifier.setRange(from, to),
        ),
      ],
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.report});

  final OvertimeReportModel report;

  static const double _tileMinWidth = 180;

  @override
  Widget build(BuildContext context) {
    final total = OvertimeDays.of(
      report.totalMinutes,
      dayMinutes: report.dayBasisMinutes,
    );
    final expected = report.expectedMinutes;
    final worked = report.workedMinutes;
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s20,
      children: [
        ResponsiveGrid(
          minItemWidth: _tileMinWidth,
          maxColumns: 3,
          children: [
            if (expected != null)
              _Figure(
                label: 'Expected',
                value: FormatUtils.duration(expected),
                caption: 'By the working schedule',
              ),
            if (worked != null)
              _Figure(
                label: 'Worked',
                value: FormatUtils.duration(worked),
                caption: expected == null || expected == 0
                    ? 'Including holiday and week-off work'
                    : '${FormatUtils.percent(worked * 100 / expected)} of '
                          'expected',
              ),
            _Figure(
              label: 'Overtime',
              value: total.short,
              semanticValue: total.long,
              caption: total.hasDayLength
                  ? '${FormatUtils.duration(report.totalMinutes)} · a day '
                        'is ${FormatUtils.duration(report.dayBasisMinutes)}'
                  : FormatUtils.duration(report.totalMinutes),
              highlight: true,
            ),
          ],
        ),
        if (report.scheduleChanged)
          Text(
            'The schedule changed in this period. Days use the current '
            'schedule for the total; each day below uses its own.',
            style: muted,
          ),
        if (report.months.length > 1) _Months(months: report.months),
        _Days(days: report.days),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    required this.caption,
    this.semanticValue,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String caption;
  final String? semanticValue;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label: ${semanticValue ?? value}. $caption',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: highlight ? AppColors.offDayWorkedBg : AppColors.surfaceSunken,
          borderRadius: AppRadius.lgAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s4,
          children: [
            Text(
              label,
              style: AppTextStyles.smallSemibold.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.headingLarge.copyWith(
                color: highlight ? AppColors.offDayWorkedFg : null,
              ),
            ),
            Text(
              caption,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Months extends StatelessWidget {
  const _Months({required this.months});

  final List<OvertimeMonthModel> months;

  @override
  Widget build(BuildContext context) {
    String time(int? minutes) =>
        minutes == null ? '—' : FormatUtils.duration(minutes);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        Text('By month', style: AppTextStyles.bodySemibold),
        ResponsiveDataView<OvertimeMonthModel>(
          rows: months,
          rowKey: (m) => m.month.toIso8601String(),
          mobileItemBuilder: (context, m) => Row(
            children: [
              Expanded(
                child: Text(
                  AppDateFormat.monthYear(m.month),
                  style: AppTextStyles.bodySemibold,
                ),
              ),
              Text(
                'Worked ${time(m.workedMinutes)} · '
                'overtime ${FormatUtils.duration(m.minutes)}',
                style: AppTextStyles.small,
              ),
            ],
          ),
          columns: [
            AppDataColumn(
              label: 'Month',
              flex: 2,
              minWidth: 140,
              cellBuilder: (context, m) => Text(
                AppDateFormat.monthYear(m.month),
                style: AppTextStyles.bodySemibold,
              ),
            ),
            AppDataColumn(
              label: 'Expected',
              minWidth: 100,
              cellBuilder: (context, m) => Text(time(m.expectedMinutes)),
            ),
            AppDataColumn(
              label: 'Worked',
              minWidth: 100,
              cellBuilder: (context, m) => Text(time(m.workedMinutes)),
            ),
            AppDataColumn(
              label: 'Overtime',
              minWidth: 100,
              cellBuilder: (context, m) => Text(
                FormatUtils.duration(m.minutes),
                style: AppTextStyles.bodySemibold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Each day with overtime, newest first; the first few, then "Show all".
class _Days extends StatefulWidget {
  const _Days({required this.days});

  final List<OvertimeDayModel> days;

  @override
  State<_Days> createState() => _DaysState();
}

class _DaysState extends State<_Days> {
  static const int _preview = 7;
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final days = widget.days;
    if (days.isEmpty) {
      return const AppEmptyView(
        compact: true,
        icon: Icons.more_time_rounded,
        title: 'No overtime in this period',
      );
    }
    final shown = _all ? days : days.take(_preview).toList();
    String asDays(OvertimeDayModel d) =>
        OvertimeDays.of(d.overtimeMinutes, dayMinutes: d.dayBasisMinutes).short;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        Text(
          days.length == 1
              ? '1 day with overtime'
              : '${days.length} days '
                    'with overtime',
          style: AppTextStyles.bodySemibold,
        ),
        ResponsiveDataView<OvertimeDayModel>(
          rows: shown,
          rowKey: (d) => d.date.toIso8601String(),
          mobileItemBuilder: (context, d) => Row(
            spacing: AppSpacing.s12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s4,
                  children: [
                    Text(
                      AppDateFormat.long(d.date),
                      style: AppTextStyles.bodySemibold,
                    ),
                    Text(
                      'Worked ${FormatUtils.duration(d.workedMinutes)} of '
                      '${FormatUtils.duration(d.expectedMinutes)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    DayKindBadge(d.dayKind),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    FormatUtils.duration(d.overtimeMinutes),
                    style: AppTextStyles.bodySemibold,
                  ),
                  Text(
                    asDays(d),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          columns: [
            AppDataColumn(
              label: 'Date',
              flex: 2,
              minWidth: 150,
              cellBuilder: (context, d) => Text(
                AppDateFormat.long(d.date),
                style: AppTextStyles.bodySemibold,
              ),
            ),
            AppDataColumn(
              label: 'Day',
              minWidth: 150,
              cellBuilder: (context, d) =>
                  d.dayKind == AttendanceDayKind.working
                  ? Text(d.dayKind.label, style: AppTextStyles.small)
                  : DayKindBadge(d.dayKind),
            ),
            AppDataColumn(
              label: 'Expected',
              minWidth: 90,
              priority: 1,
              cellBuilder: (context, d) =>
                  Text(FormatUtils.duration(d.expectedMinutes)),
            ),
            AppDataColumn(
              label: 'Worked',
              minWidth: 90,
              cellBuilder: (context, d) =>
                  Text(FormatUtils.duration(d.workedMinutes)),
            ),
            AppDataColumn(
              label: 'Overtime',
              minWidth: 90,
              cellBuilder: (context, d) => Text(
                FormatUtils.duration(d.overtimeMinutes),
                style: AppTextStyles.bodySemibold,
              ),
            ),
            AppDataColumn(
              label: 'As days',
              minWidth: 120,
              priority: 1,
              cellBuilder: (context, d) => Text(asDays(d)),
            ),
          ],
        ),
        if (days.length > _preview)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton(
              label: _all ? 'Show fewer' : 'Show all ${days.length}',
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: () => setState(() => _all = !_all),
            ),
          ),
      ],
    );
  }
}
