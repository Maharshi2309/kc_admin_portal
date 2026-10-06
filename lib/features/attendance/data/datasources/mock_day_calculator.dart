import 'dart:math' as math;

import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// Approved leave on a date, as far as the day's hours are concerned.
enum DayLeave { none, fullDay, halfDay }

/// Everything the backend decides about one employee's date.
class DayResult {
  const DayResult({
    required this.dayType,
    required this.dayKind,
    required this.status,
    required this.expectedMinutes,
    required this.overtimeMinutes,
    this.workedMinutes,
    this.workedPercent,
    this.note,
    this.lateMinutes,
  });

  final CalendarDayType dayType;
  final AttendanceDayKind dayKind;
  final AttendanceDayStatus status;
  final int expectedMinutes;

  /// Null until there is a punch in (and, on past days, a punch out).
  final int? workedMinutes;
  final int overtimeMinutes;

  /// Worked share of the expected time, 0–100, for the progress bar.
  final double? workedPercent;

  /// Short explanation, e.g. "Not in yet". Never a duration.
  final String? note;

  /// How late the punch-in was; null when on time.
  final int? lateMinutes;
}

/// DEV ONLY (`USE_MOCK_API=true`): the backend's `computeDay`
/// (docs/DATABASE_V2.md §3), so the dev mocks behave like the real API.
/// The real calculation lives on the server; the app never uses this with
/// the real API.
///
/// All values are whole minutes; times are company wall-clock times.
abstract final class MockDayCalculator {
  /// Late means arriving after the start time plus a grace: the
  /// organization's setting (2026-10-06); 15 minutes for Keshav Clothing
  /// (approved 2026-09-30).
  static const int defaultLateGraceMinutes = 15;

  static DayResult compute({
    required DateTime date,
    required DateTime now,
    required WorkScheduleModel? schedule,
    HolidayModel? holiday,
    DayLeave leave = DayLeave.none,
    DateTime? punchIn,
    DateTime? punchOut,
    int lateGraceMinutes = defaultLateGraceMinutes,
  }) {
    final day = date.dateOnly;
    final isToday = day == now.dateOnly;

    // §3.1 Day type: holidays win over weekly offs.
    final dayType = holiday != null
        ? CalendarDayType.holiday
        : schedule != null && schedule.weeklyOffDays.contains(day.weekday)
        ? CalendarDayType.weekOff
        : CalendarDayType.working;
    final working = dayType == CalendarDayType.working;

    // §3.2 Expected minutes.
    final scheduled = schedule?.expectedMinutes ?? 0;
    final expected = !working
        ? 0
        : switch (leave) {
            DayLeave.fullDay => 0,
            DayLeave.halfDay => scheduled ~/ 2,
            DayLeave.none => scheduled,
          };

    // §3.3 Worked minutes: the stay, less the break on working days.
    int? worked;
    final end = punchOut ?? (isToday ? now : null);
    if (punchIn != null && end != null) {
      final stay = math.max(0, end.difference(punchIn).inMinutes);
      final deduction = working && schedule != null
          ? _breakDeduction(schedule, day, punchIn, end, stay)
          : 0;
      worked = math.max(0, stay - deduction);
    }

    // §3.3 Overtime: never negative; all of it on holidays and weekly offs.
    final overtime = worked == null
        ? 0
        : working
        ? math.max(0, worked - expected)
        : worked;

    final dayKind = punchIn == null
        ? AttendanceDayKind.working
        : switch (dayType) {
            CalendarDayType.holiday => AttendanceDayKind.holidayWorked,
            CalendarDayType.weekOff => AttendanceDayKind.weekOffWorked,
            _ => AttendanceDayKind.working,
          };

    // §3.4 Status and "late".
    final (status, note, lateMinutes) = _status(
      dayType: dayType,
      schedule: schedule,
      leave: leave,
      day: day,
      now: now,
      isToday: isToday,
      punchIn: punchIn,
      lateGraceMinutes: lateGraceMinutes,
    );

    return DayResult(
      dayType: dayType,
      dayKind: dayKind,
      status: status,
      expectedMinutes: expected,
      workedMinutes: worked,
      overtimeMinutes: overtime,
      workedPercent: worked == null || expected == 0
          ? null
          : math.min(100, worked * 100 / expected).toDouble(),
      note: note,
      lateMinutes: lateMinutes,
    );
  }

  /// The break is deducted only when the stay covers the whole break window,
  /// or, without a window, when the stay is longer than the break.
  static int _breakDeduction(
    WorkScheduleModel schedule,
    DateTime day,
    DateTime punchIn,
    DateTime end,
    int stay,
  ) {
    final length = schedule.breakMinutes;
    final start = schedule.breakStart;
    final finish = schedule.breakEnd;
    if (length == 0) return 0;
    if (start == null || finish == null) return stay > length ? length : 0;
    final windowStart = day.add(Duration(minutes: start.minutes));
    final windowEnd = day.add(Duration(minutes: finish.minutes));
    final covers = !punchIn.isAfter(windowStart) && !end.isBefore(windowEnd);
    return covers ? length : 0;
  }

  static (AttendanceDayStatus, String?, int?) _status({
    required CalendarDayType dayType,
    required WorkScheduleModel? schedule,
    required DayLeave leave,
    required DateTime day,
    required DateTime now,
    required bool isToday,
    required DateTime? punchIn,
    required int lateGraceMinutes,
  }) {
    if (dayType != CalendarDayType.working) {
      if (punchIn != null) return (AttendanceDayStatus.present, null, null);
      return dayType == CalendarDayType.holiday
          ? (AttendanceDayStatus.holiday, null, null)
          : (AttendanceDayStatus.weeklyOff, null, null);
    }
    if (leave == DayLeave.fullDay) {
      return (AttendanceDayStatus.onLeave, null, null);
    }

    final start = schedule == null
        ? null
        : day.add(Duration(minutes: schedule.startTime.minutes));
    if (punchIn == null) {
      final dueBy = start?.add(Duration(minutes: lateGraceMinutes));
      final notDueYet = isToday && dueBy != null && now.isBefore(dueBy);
      return (
        AttendanceDayStatus.absent,
        notDueYet ? 'Not in yet' : null,
        null,
      );
    }
    if (leave == DayLeave.halfDay) {
      return (AttendanceDayStatus.halfDay, null, null);
    }
    if (start != null) {
      final lateBy = punchIn.difference(start).inMinutes;
      if (lateBy > lateGraceMinutes) {
        return (AttendanceDayStatus.late, null, lateBy);
      }
    }
    return (AttendanceDayStatus.present, null, null);
  }
}
