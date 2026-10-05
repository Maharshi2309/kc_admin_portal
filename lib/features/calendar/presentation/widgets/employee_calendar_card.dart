import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_link.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/calendar/presentation/calendar_cell_state.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/overtime/domain/utils/overtime_format.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// One employee's month: attendance, leave (approved, pending), company
/// holidays, weekly offs, work on off days, corrections and overtime, with
/// the month's totals. Takes the profile's calendar place (design board 05).
class EmployeeCalendarCard extends ConsumerWidget {
  const EmployeeCalendarCard({
    required this.employeeId,
    this.dayMinutes = 0,
    this.onDayTap,
    super.key,
  });

  final String employeeId;

  /// The employee's current working-day length, for showing overtime as
  /// days.
  final int dayMinutes;

  /// Opens a day (Phase 8: the day sheet); null keeps days read-only.
  final ValueChanged<DateTime>? onDayTap;

  static const double _monthLabelMinWidth = 120;

  /// Card width from which title and month switcher fit on one line.
  static const double _inlineSwitcherMinWidth = 480;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(calendarMonthProvider(employeeId));
    final monthNotifier = ref.read(calendarMonthProvider(employeeId).notifier);
    final today = ref.watch(clockProvider)().dateOnly;
    final key = (employeeId: employeeId, month: month);
    final calendar = ref.watch(employeeCalendarProvider(key));
    final isCurrentMonth = month == today.monthStart;

    final previous = AppIconButton(
      icon: Icons.chevron_left_rounded,
      tooltip: 'Previous month',
      bordered: true,
      onPressed: monthNotifier.previous,
    );
    final next = AppIconButton(
      icon: Icons.chevron_right_rounded,
      tooltip: 'Next month',
      bordered: true,
      onPressed: monthNotifier.canGoNext ? monthNotifier.next : null,
    );
    final monthLabel = Text(
      AppDateFormat.monthYear(month),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodyBold,
    );
    final switcher = [previous, monthLabel, next];

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow =
            constraints.maxWidth <
            MediaQuery.textScalerOf(context).scale(_inlineSwitcherMinWidth);

        return SectionCard(
          title: 'Calendar',
          subtitle: isCurrentMonth ? 'This month so far' : null,
          trailing: narrow
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.s4,
                  children: [
                    switcher[0],
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: _monthLabelMinWidth,
                      ),
                      child: monthLabel,
                    ),
                    switcher[2],
                  ],
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s16,
            children: [
              if (narrow)
                Row(
                  children: [
                    previous,
                    Expanded(child: monthLabel),
                    next,
                  ],
                ),
              if (!isCurrentMonth)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppLink(
                    label: 'Back to this month',
                    showChevron: false,
                    onPressed: monthNotifier.thisMonth,
                  ),
                ),
              AsyncValueView<EmployeeCalendarModel>(
                value: calendar,
                compact: true,
                onRetry: () => ref.invalidate(employeeCalendarProvider(key)),
                data: (data) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.s16,
                  children: [
                    if (month.isAfter(today.monthStart))
                      _AheadSummary(days: data.days)
                    else
                      _Summary(summary: data.summary, dayMinutes: dayMinutes),
                    _Grid(
                      month: data.month,
                      today: today,
                      days: data.days,
                      onDayTap: onDayTap,
                    ),
                    _Legend(days: data.days, today: today),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary, required this.dayMinutes});

  final CalendarSummaryModel summary;
  final int dayMinutes;

  @override
  Widget build(BuildContext context) {
    final overtime = summary.overtimeMinutes;
    final offDaysWorked = summary.holidayWorked + summary.weekOffWorked;
    final figures = <(String, String, String?)>[
      ('Present', '${summary.present} / ${summary.workingDays}', null),
      ('Absent', '${summary.absent}', null),
      ('Leave', FormatUtils.days(summary.leaveDays), null),
      (
        'Worked',
        DurationFormat.short(summary.workedMinutes),
        'of ${DurationFormat.short(summary.expectedMinutes)}',
      ),
      (
        'Overtime',
        overtime == 0 ? '—' : '+${DurationFormat.short(overtime)}',
        overtime == 0
            ? null
            : OvertimeDays.of(overtime, dayMinutes: dayMinutes).compact,
      ),
      (
        'Holidays · week offs',
        '${summary.holidays} · ${summary.weekOffs}',
        offDaysWorked == 0 ? null : '$offDaysWorked worked',
      ),
    ];

    return Wrap(
      spacing: AppSpacing.s28,
      runSpacing: AppSpacing.s12,
      children: [
        for (final (label, value, note) in figures)
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(value, style: AppTextStyles.statXSmall),
                if (note != null)
                  Text(
                    note,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A month still to come: what's already planned.
class _AheadSummary extends StatelessWidget {
  const _AheadSummary({required this.days});

  final List<CalendarDayModel> days;

  @override
  Widget build(BuildContext context) {
    double leaveDays(LeaveStatus status) => days
        .where((d) => d.dayType == CalendarDayType.working)
        .expand((d) => d.leaves.where((l) => l.status == status))
        .fold(0, (sum, l) => sum + (l.isHalfDay ? 0.5 : 1));
    final figures = [
      (
        'Holidays',
        '${days.where((d) => d.dayType == CalendarDayType.holiday).length}',
      ),
      (
        'Week offs',
        '${days.where((d) => d.dayType == CalendarDayType.weekOff).length}',
      ),
      ('Planned leave', FormatUtils.days(leaveDays(LeaveStatus.approved))),
      ('Pending leave', FormatUtils.days(leaveDays(LeaveStatus.pending))),
    ];
    return Wrap(
      spacing: AppSpacing.s28,
      runSpacing: AppSpacing.s12,
      children: [
        for (final (label, value) in figures)
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                Text(value, style: AppTextStyles.statXSmall),
              ],
            ),
          ),
      ],
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.month,
    required this.today,
    required this.days,
    required this.onDayTap,
  });

  final DateTime month;
  final DateTime today;
  final List<CalendarDayModel> days;
  final ValueChanged<DateTime>? onDayTap;

  static const int _daysPerWeek = 7;

  /// Below this width the grid uses minimal gaps (smallest phones).
  static const double _compactWidth = 360;

  @override
  Widget build(BuildContext context) {
    final byDay = {for (final d in days) d.date.day: d};
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingBlanks = month.monthStart.weekday - DateTime.monday;
    final cellCount =
        ((leadingBlanks + daysInMonth) / _daysPerWeek).ceil() * _daysPerWeek;

    final cells = <Widget>[
      for (var i = 0; i < cellCount; i++)
        switch (i - leadingBlanks + 1) {
          final d when d >= 1 && d <= daysInMonth && byDay[d] != null =>
            _DayCell(day: byDay[d]!, today: today, onTap: onDayTap),
          _ => const _DayCell.blank(),
        },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = constraints.maxWidth < _compactWidth
            ? AppSpacing.s2
            : AppSpacing.s6;
        return Column(
          spacing: gap,
          children: [
            Row(
              spacing: gap,
              children: [
                for (
                  var weekday = DateTime.monday;
                  weekday <= DateTime.sunday;
                  weekday++
                )
                  Expanded(
                    child: Text(
                      AppDateFormat.weekdayShort(weekday).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            for (var row = 0; row < cells.length; row += _daysPerWeek)
              Row(
                spacing: gap,
                children: [
                  for (final cell in cells.sublist(row, row + _daysPerWeek))
                    Expanded(child: cell),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.today, this.onTap})
    : blank = false;

  const _DayCell.blank() : day = null, today = null, onTap = null, blank = true;

  final CalendarDayModel? day;
  final DateTime? today;
  final ValueChanged<DateTime>? onTap;
  final bool blank;

  static const double _height = 56;
  static const double _markerSize = 6;

  @override
  Widget build(BuildContext context) {
    // Cells hold two lines of text, so they grow with the system font size.
    final height = MediaQuery.textScalerOf(context).scale(_height);
    final day = this.day;
    if (blank || day == null) return SizedBox(height: height);

    final state = cellStateOf(day, today!);
    final markers = markersOf(day);
    final tone = state.tone;
    final isToday = day.date == today;
    final foreground = tone?.foreground ?? AppColors.textMuted;
    final tag = state == CalendarCellState.onLeave
        ? leaveShortOf(day)
        : state.short;
    final description = describeDay(day, state, markers);

    final cell = Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: tone?.background ?? Colors.transparent,
        borderRadius: AppRadius.smAll,
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : (tone == null ? Border.all(color: AppColors.border) : null),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Scales down instead of wrapping in the narrow cells of
              // small phones.
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${day.date.day}',
                    maxLines: 1,
                    softWrap: false,
                    style: AppTextStyles.smallSemibold.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              for (final marker in markers)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.s2,
                  ),
                  child: _MarkerDot(marker: marker, size: _markerSize),
                ),
            ],
          ),
          if (tag.isNotEmpty)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tag,
                  style: AppTextStyles.micro.copyWith(color: foreground),
                ),
              ),
            ),
        ],
      ),
    );

    final tap = onTap;
    return Tooltip(
      message: description,
      waitDuration: AppDurations.tooltipWait,
      child: Semantics(
        label: description,
        button: tap != null,
        excludeSemantics: true,
        child: tap == null
            ? cell
            : InkWell(
                borderRadius: AppRadius.smAll,
                onTap: () => tap(day.date),
                child: cell,
              ),
      ),
    );
  }
}

/// Everything about a day in one sentence, for the tooltip and screen
/// readers: "Thu, 1 Oct 2026 · Present · 08:58–19:00 · worked 9h 02m ·
/// overtime 1h 32m · Pending casual leave".
String describeDay(
  CalendarDayModel day,
  CalendarCellState state,
  List<CalendarMarker> markers,
) {
  final attendance = day.attendance;
  final punchIn = attendance?.punchIn;
  final punchOut = attendance?.punchOut;
  final worked = attendance?.workedMinutes;
  return [
    AppDateFormat.long(day.date),
    if (day.holidayName != null) day.holidayName!,
    state.label,
    if (punchIn != null)
      '${AppDateFormat.time(punchIn)}–'
          '${punchOut == null ? '…' : AppDateFormat.time(punchOut)}',
    if (worked != null) 'worked ${DurationFormat.full(worked)}',
    if (day.overtimeMinutes > 0)
      'overtime ${DurationFormat.full(day.overtimeMinutes)}',
    for (final leave in day.leaves)
      if (leave.status != LeaveStatus.approved ||
          state != CalendarCellState.onLeave)
        '${leave.status.label} ${leave.leaveType.name.toLowerCase()} leave'
            '${leave.isHalfDay ? ' (half day)' : ''}',
    if (markers.contains(CalendarMarker.corrected)) 'attendance corrected',
  ].join(' · ');
}

class _MarkerDot extends StatelessWidget {
  const _MarkerDot({required this.marker, required this.size});

  final CalendarMarker marker;
  final double size;

  static Color colorOf(CalendarMarker marker) => switch (marker) {
    CalendarMarker.pendingLeave => AppColors.warningSwatch,
    CalendarMarker.corrected => AppColors.primary,
    CalendarMarker.overtime => AppColors.offDayWorkedFg,
  };

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: colorOf(marker),
      shape: BoxShape.circle,
      // A light ring keeps the dot visible on any cell colour.
      border: Border.all(color: AppColors.surface),
    ),
  );
}

/// Explains the colours and markers that appear this month.
class _Legend extends StatelessWidget {
  const _Legend({required this.days, required this.today});

  final List<CalendarDayModel> days;
  final DateTime today;

  static const double _swatchSize = 12;
  static const double _swatchRadius = 3;
  static const double _markerSize = 8;

  @override
  Widget build(BuildContext context) {
    final states =
        {
            for (final d in days) cellStateOf(d, today),
          }.where((s) => s.tone != null).toList()
          ..sort((a, b) => a.index.compareTo(b.index));
    final markers = {for (final d in days) ...markersOf(d)}.toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    if (states.isEmpty && markers.isEmpty) return const SizedBox.shrink();

    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    return Wrap(
      spacing: AppSpacing.s14,
      runSpacing: AppSpacing.s8,
      children: [
        for (final state in states)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s6,
            children: [
              Container(
                width: _swatchSize,
                height: _swatchSize,
                decoration: BoxDecoration(
                  color: state.tone!.background,
                  border: Border.all(color: state.tone!.foreground),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(_swatchRadius),
                  ),
                ),
              ),
              Text(state.label, style: muted),
            ],
          ),
        for (final marker in markers)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s6,
            children: [
              _MarkerDot(marker: marker, size: _markerSize),
              Text(marker.label, style: muted),
            ],
          ),
      ],
    );
  }
}
