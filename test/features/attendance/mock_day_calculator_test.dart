// The dev mock's day calculation, checked against the rules the backend
// must implement (docs/DATABASE_V2.md §3). These tests double as worked
// examples for the backend team.

import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/mock_day_calculator.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// 09:00–17:30, break 13:00–14:00 (60 min), Sunday off: expected 450.
final _schedule = WorkScheduleModel(
  id: 's1',
  effectiveFrom: DateTime(2026),
  startTime: const ClockTime.hm(9, 0),
  endTime: const ClockTime.hm(17, 30),
  breakMinutes: 60,
  breakStart: const ClockTime.hm(13, 0),
  breakEnd: const ClockTime.hm(14, 0),
  weeklyOffDays: const [DateTime.sunday],
  expectedMinutes: 450,
);

final _thursday = DateTime(2026, 10, 1);
final _sunday = DateTime(2026, 10, 4);
final _evening = DateTime(2026, 10, 5, 20); // "now": all days are over
DateTime _t(DateTime day, int h, int m) =>
    DateTime(day.year, day.month, day.day, h, m);

DayResult _compute(
  DateTime day, {
  DateTime? punchIn,
  DateTime? punchOut,
  HolidayModel? holiday,
  DayLeave leave = DayLeave.none,
  WorkScheduleModel? schedule,
  DateTime? now,
  int lateGraceMinutes = MockDayCalculator.defaultLateGraceMinutes,
}) => MockDayCalculator.compute(
  date: day,
  now: now ?? _evening,
  schedule: schedule ?? _schedule,
  holiday: holiday,
  leave: leave,
  punchIn: punchIn,
  punchOut: punchOut,
  lateGraceMinutes: lateGraceMinutes,
);

void main() {
  group('§3.3 worked and overtime (the spec example)', () {
    test('08:58–19:00: break deducted, 542 worked, 92 overtime', () {
      final r = _compute(
        _thursday,
        punchIn: _t(_thursday, 8, 58),
        punchOut: _t(_thursday, 19, 0),
      );
      expect(r.dayType, CalendarDayType.working);
      expect(r.expectedMinutes, 450);
      expect(r.workedMinutes, 542);
      expect(r.overtimeMinutes, 92);
      expect(r.status, AttendanceDayStatus.present);
    });

    test('the requirement example: 9 h worked against 7.5 h → 90 min', () {
      // In 08:30, out 18:30 = 600 min stay − 60 break = 540 worked.
      final r = _compute(
        _thursday,
        punchIn: _t(_thursday, 8, 30),
        punchOut: _t(_thursday, 18, 30),
      );
      expect(r.workedMinutes, 540);
      expect(r.overtimeMinutes, 90);
    });

    test('a shortfall is never overtime', () {
      final r = _compute(
        _thursday,
        punchIn: _t(_thursday, 9, 0),
        punchOut: _t(_thursday, 15, 0),
      );
      expect(r.workedMinutes, 300);
      expect(r.overtimeMinutes, 0);
    });

    test('the break is only deducted when the stay covers its window', () {
      final morning = _compute(
        _thursday,
        punchIn: _t(_thursday, 9, 0),
        punchOut: _t(_thursday, 12, 30),
      );
      expect(morning.workedMinutes, 210);

      final noWindow = _compute(
        _thursday,
        schedule: _schedule.copyWith(breakStart: null, breakEnd: null),
        punchIn: _t(_thursday, 9, 0),
        punchOut: _t(_thursday, 9, 45),
      );
      expect(noWindow.workedMinutes, 45, reason: 'stay not longer than break');
    });

    test('worked minutes round down', () {
      final r = _compute(
        _thursday,
        punchIn: DateTime(2026, 10, 1, 9, 0, 0),
        punchOut: DateTime(2026, 10, 1, 9, 0, 59),
      );
      expect(r.workedMinutes, 0);
    });
  });

  group('§3.1–3.3 holidays and weekly offs', () {
    final holiday = HolidayModel(
      id: 'h',
      date: _thursday,
      name: 'Company Holiday',
    );

    test('a holiday is never absent and expects nothing', () {
      final r = _compute(_thursday, holiday: holiday);
      expect(r.dayType, CalendarDayType.holiday);
      expect(r.status, AttendanceDayStatus.holiday);
      expect(r.expectedMinutes, 0);
      expect(r.overtimeMinutes, 0);
    });

    test('work on a holiday: all of it is overtime, no break deducted', () {
      final r = _compute(
        _thursday,
        holiday: holiday,
        punchIn: _t(_thursday, 10, 0),
        punchOut: _t(_thursday, 15, 0),
      );
      expect(r.dayKind, AttendanceDayKind.holidayWorked);
      expect(r.workedMinutes, 300);
      expect(r.overtimeMinutes, 300);
      expect(r.status, AttendanceDayStatus.present);
    });

    test('a weekly off, and work on it', () {
      expect(_compute(_sunday).status, AttendanceDayStatus.weeklyOff);
      final r = _compute(
        _sunday,
        punchIn: _t(_sunday, 9, 0),
        punchOut: _t(_sunday, 14, 0),
      );
      expect(r.dayType, CalendarDayType.weekOff);
      expect(r.dayKind, AttendanceDayKind.weekOffWorked);
      expect(r.overtimeMinutes, 300);
    });

    test('a holiday on a weekly off is a holiday', () {
      final r = _compute(
        _sunday,
        holiday: HolidayModel(id: 'h2', date: _sunday, name: 'Festival'),
      );
      expect(r.dayType, CalendarDayType.holiday);
    });
  });

  group('§3.2 leave', () {
    test('full-day leave expects nothing', () {
      final r = _compute(_thursday, leave: DayLeave.fullDay);
      expect(r.status, AttendanceDayStatus.onLeave);
      expect(r.expectedMinutes, 0);
    });

    test('half-day leave halves the expected time', () {
      final r = _compute(
        _thursday,
        leave: DayLeave.halfDay,
        punchIn: _t(_thursday, 9, 0),
        punchOut: _t(_thursday, 13, 0),
      );
      expect(r.status, AttendanceDayStatus.halfDay);
      expect(r.expectedMinutes, 225);
      expect(r.workedMinutes, 240);
      expect(r.overtimeMinutes, 15);
    });
  });

  group('§3.4 status and late', () {
    test("the grace is the organization's setting (2026-10-06)", () {
      // In at 09:20 against a 09:00 start.
      final strict = _compute(
        _thursday,
        punchIn: _t(_thursday, 9, 20),
        lateGraceMinutes: 5,
      );
      expect(strict.status, AttendanceDayStatus.late);
      expect(strict.lateMinutes, 20);
      final relaxed = _compute(
        _thursday,
        punchIn: _t(_thursday, 9, 20),
        lateGraceMinutes: 30,
      );
      expect(relaxed.status, AttendanceDayStatus.present);
    });

    test('within the 15-minute grace is on time; after it is late', () {
      expect(
        _compute(_thursday, punchIn: _t(_thursday, 9, 15)).status,
        AttendanceDayStatus.present,
      );
      final late = _compute(_thursday, punchIn: _t(_thursday, 9, 16));
      expect(late.status, AttendanceDayStatus.late);
      expect(late.lateMinutes, 16);
      expect(late.note, isNull); // durations are never text
    });

    test('no punch on a working day is absent', () {
      expect(_compute(_thursday).status, AttendanceDayStatus.absent);
    });

    test('today before start + grace is "not in yet"', () {
      final r = _compute(_thursday, now: _t(_thursday, 9, 10));
      expect(r.status, AttendanceDayStatus.absent);
      expect(r.note, 'Not in yet');
    });

    test('an open punch today counts up to now', () {
      final r = _compute(
        _thursday,
        punchIn: _t(_thursday, 9, 0),
        now: _t(_thursday, 12, 0),
      );
      expect(r.workedMinutes, 180);
      expect(r.workedPercent, closeTo(40, 0.01));
    });

    test('an open punch on a past day has no worked time yet', () {
      final r = _compute(_thursday, punchIn: _t(_thursday, 9, 0));
      expect(r.workedMinutes, isNull);
      expect(r.overtimeMinutes, 0);
    });
  });
}
