import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// Month calendar for choosing leave dates (design board 09). Tap a start
/// then an end date; in half-day mode one tap picks the day. Holidays and
/// weekly offs from the backend are marked (they are not counted).
class LeaveRangeCalendar extends StatelessWidget {
  const LeaveRangeCalendar({
    required this.month,
    required this.calendar,
    required this.start,
    required this.end,
    required this.singleDay,
    required this.onMonthChanged,
    required this.onRangeChanged,
    this.enabled = true,
    super.key,
  });

  final DateTime month;

  /// Holidays and weekly offs of [month], when loaded.
  final LeaveCalendarModel? calendar;
  final DateTime? start;
  final DateTime? end;

  /// Half-day mode: picks one date.
  final bool singleDay;
  final ValueChanged<DateTime> onMonthChanged;
  final void Function(DateTime start, DateTime end) onRangeChanged;
  final bool enabled;

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const int _daysPerWeek = 7;
  static const double _cellHeight = 40;

  /// Day cells grow with the system font size.
  static double _cellHeightOf(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(_cellHeight);

  void _tap(DateTime day) {
    final s = start;
    if (singleDay || s == null || end != s || day.isBefore(s)) {
      onRangeChanged(day, day);
    } else {
      onRangeChanged(s, day);
    }
  }

  HolidayModel? _holiday(DateTime day) =>
      calendar?.holidays.where((h) => h.date.dateOnly == day).firstOrNull;

  bool _isOff(DateTime day) => calendar?.isWeekOff(day) ?? false;

  @override
  Widget build(BuildContext context) {
    final first = month.monthStart;
    final daysInMonth = DateUtils.getDaysInMonth(first.year, first.month);
    final leading = first.weekday - DateTime.monday;
    final cellCount =
        ((leading + daysInMonth) / _daysPerWeek).ceil() * _daysPerWeek;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s6,
        children: [
          Row(
            children: [
              AppIconButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous month',
                onPressed: () =>
                    onMonthChanged(DateTime(first.year, first.month - 1)),
              ),
              Expanded(
                child: Text(
                  AppDateFormat.monthYear(first),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyBold,
                ),
              ),
              AppIconButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next month',
                onPressed: () =>
                    onMonthChanged(DateTime(first.year, first.month + 1)),
              ),
            ],
          ),
          Row(
            children: [
              for (final weekday in _weekdays)
                Expanded(
                  child: Text(
                    weekday.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
          for (var row = 0; row < cellCount; row += _daysPerWeek)
            Row(
              children: [
                for (var i = row; i < row + _daysPerWeek; i++)
                  Expanded(child: _cell(context, i - leading + 1, daysInMonth)),
              ],
            ),
          _Notes(calendar: calendar),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, int dayNumber, int daysInMonth) {
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return SizedBox(height: _cellHeightOf(context));
    }
    final day = DateTime(month.year, month.month, dayNumber);
    final s = start;
    final e = end;
    final isStart = s != null && day == s;
    final isEnd = e != null && day == e;
    final inRange =
        s != null && e != null && !day.isBefore(s) && !day.isAfter(e);
    final holiday = _holiday(day);

    return _DayCell(
      day: day,
      isEdge: isStart || isEnd,
      inRange: inRange,
      isHoliday: holiday != null,
      isOff: _isOff(day),
      semanticsNote: holiday?.name,
      onTap: enabled ? () => _tap(day) : null,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isEdge,
    required this.inRange,
    required this.isHoliday,
    required this.isOff,
    required this.semanticsNote,
    required this.onTap,
  });

  final DateTime day;
  final bool isEdge;
  final bool inRange;
  final bool isHoliday;
  final bool isOff;
  final String? semanticsNote;
  final VoidCallback? onTap;

  static const double _dotSize = 4;

  @override
  Widget build(BuildContext context) {
    final notCounted = isHoliday || isOff;
    final Color background;
    final Color foreground;
    if (isEdge) {
      background = AppColors.primary;
      foreground = AppColors.onPrimary;
    } else if (inRange) {
      background = AppColors.primarySoft;
      foreground = notCounted ? AppColors.textMuted : AppColors.primary;
    } else {
      background = Colors.transparent;
      // Muted, not faded: the dates stay readable (WCAG 4.5:1).
      foreground = notCounted ? AppColors.textMuted : AppColors.textPrimary;
    }

    return Semantics(
      button: true,
      selected: inRange,
      label: [
        AppDateFormat.long(day),
        if (isOff) 'weekly off',
        ?semanticsNote,
      ].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: Container(
          height: LeaveRangeCalendar._cellHeightOf(context),
          margin: const EdgeInsets.all(AppSpacing.s2),
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.smAll,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.s2,
            children: [
              // Scales down rather than wrapping in narrow cells.
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${day.day}',
                  maxLines: 1,
                  style: AppTextStyles.smallSemibold.copyWith(
                    color: foreground,
                  ),
                ),
              ),
              if (isHoliday)
                Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    color: isEdge
                        ? AppColors.onPrimary
                        : AppColors.warningSwatch,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "● Holiday · 2 Oct Gandhi Jayanti" and "Sundays are not counted".
class _Notes extends StatelessWidget {
  const _Notes({required this.calendar});

  final LeaveCalendarModel? calendar;

  static const List<String> _weekdayNames = [
    'Mondays',
    'Tuesdays',
    'Wednesdays',
    'Thursdays',
    'Fridays',
    'Saturdays',
    'Sundays',
  ];
  static const double _dotSize = 8;

  @override
  Widget build(BuildContext context) {
    final data = calendar;
    if (data == null) return const SizedBox.shrink();
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    final offs = [
      for (final weekday in data.weeklyOffDays) _weekdayNames[weekday - 1],
    ];

    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s4,
      children: [
        for (final holiday in data.holidays)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s6,
            children: [
              Container(
                width: _dotSize,
                height: _dotSize,
                decoration: const BoxDecoration(
                  color: AppColors.warningSwatch,
                  shape: BoxShape.circle,
                ),
              ),
              // Long holiday names wrap on narrow screens.
              Flexible(
                child: Text(
                  'Holiday · ${AppDateFormat.dayMonth(holiday.date)} '
                  '${holiday.name}',
                  style: muted,
                ),
              ),
            ],
          ),
        if (offs.isNotEmpty)
          Text('${offs.join(' and ')} are not counted', style: muted),
      ],
    );
  }
}
