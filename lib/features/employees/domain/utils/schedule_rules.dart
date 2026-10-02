import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// A working schedule being entered in a form. The break window is optional;
/// when a break start is set, the break ends [breakMinutes] later.
class ScheduleDraft {
  const ScheduleDraft({
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.weeklyOffDays,
    this.breakStart,
  });

  /// Starting values for a new employee: the design's shift (09:30–18:30),
  /// an hour's break, Sunday off.
  ///
  /// TODO — REQUIREMENT CONFIRMATION REQUIRED: the company's standard
  /// schedule, if any. The admin can change every value.
  static const ScheduleDraft standard = ScheduleDraft(
    startTime: ClockTime.hm(9, 30),
    endTime: ClockTime.hm(18, 30),
    breakMinutes: 60,
    weeklyOffDays: {DateTime.sunday},
  );

  factory ScheduleDraft.fromSchedule(WorkScheduleModel schedule) =>
      ScheduleDraft(
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        breakMinutes: schedule.breakMinutes,
        breakStart: schedule.breakStart,
        weeklyOffDays: schedule.weeklyOffDays.toSet(),
      );

  final ClockTime startTime;
  final ClockTime endTime;
  final int breakMinutes;
  final ClockTime? breakStart;

  /// ISO weekdays, 1 = Monday … 7 = Sunday.
  final Set<int> weeklyOffDays;

  /// End of the break window, when a start is set and it fits in a day.
  ClockTime? get breakEnd {
    final start = breakStart;
    if (start == null) return null;
    final end = start.minutes + breakMinutes;
    return end < Duration.minutesPerDay ? ClockTime(end) : null;
  }

  int get shiftMinutes => endTime.minutes - startTime.minutes;

  /// What the backend will compute: end − start − break (a preview; the
  /// server's value is the one that counts).
  int get expectedMinutes => shiftMinutes - breakMinutes;

  ScheduleDraft copyWith({
    ClockTime? startTime,
    ClockTime? endTime,
    int? breakMinutes,
    ClockTime? breakStart,
    bool clearBreakStart = false,
    Set<int>? weeklyOffDays,
  }) => ScheduleDraft(
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    breakStart: clearBreakStart ? null : (breakStart ?? this.breakStart),
    weeklyOffDays: weeklyOffDays ?? this.weeklyOffDays,
  );

  WorkScheduleInput toInput(DateTime effectiveFrom) => WorkScheduleInput(
    effectiveFrom: effectiveFrom,
    startTime: startTime,
    endTime: endTime,
    breakMinutes: breakMinutes,
    breakStart: breakStart,
    breakEnd: breakStart == null ? null : breakEnd,
    weeklyOffDays: weeklyOffDays.toList()..sort(),
  );
}

/// The problems the backend would reject (docs/DATABASE_V2.md §2.1), keyed
/// like its field errors. Empty when the schedule is valid. Used by the form
/// to explain problems before saving, and by the dev mock.
Map<String, String> scheduleProblems(WorkScheduleInput input) {
  final problems = <String, String>{};
  final shift = input.endTime.minutes - input.startTime.minutes;
  if (shift <= 0) {
    problems['endTime'] = 'End time must be after the start time';
  } else if (input.breakMinutes < 0 || input.breakMinutes >= shift) {
    problems['breakMinutes'] = 'The break must be shorter than the shift';
  }

  final breakStart = input.breakStart;
  final breakEnd = input.breakEnd;
  if ((breakStart == null) != (breakEnd == null)) {
    problems['breakStart'] = 'The break must end on the same day';
  } else if (breakStart != null && breakEnd != null) {
    if (breakStart < input.startTime || breakEnd > input.endTime) {
      problems['breakStart'] = 'The break must be within the working hours';
    } else if (breakEnd.minutes - breakStart.minutes != input.breakMinutes) {
      problems['breakStart'] = 'The break window must match the break length';
    }
  }

  final offs = input.weeklyOffDays;
  if (offs.any((d) => d < DateTime.monday || d > DateTime.sunday) ||
      offs.toSet().length >= DateTime.daysPerWeek) {
    problems['weeklyOffDays'] = 'Leave at least one working day in the week';
  }
  return problems;
}
