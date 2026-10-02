import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the employee calendar, put together the
/// way the backend does from the same records the other screens show:
/// attendance (with each day's schedule and overtime), leave of any status
/// except cancelled, company holidays and weekly offs.
class CalendarMockDataSource implements CalendarRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  CalendarMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    required this.attendance,
    required this.holidays,
    this.leaves,
    this.audit,
    this.latency = Duration.zero,
  });

  final DateTime Function() now;
  final AttendanceMockDataSource attendance;
  final MockHolidayStore holidays;
  final LeaveMockDataSource? leaves;

  /// The change history, when shared.
  final MockAuditLog? audit;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month) async {
    await _wait();
    guard.require(AppPermission.calendarView);
    final first = month.monthStart;
    final last = DateTime(first.year, first.month + 1, 0);
    final days = _days(employeeId, first, last);
    return EmployeeCalendarModel(
      month: first,
      days: days,
      summary: _summary(days),
    );
  }

  @override
  Future<CalendarDayDetailModel> day(String employeeId, DateTime date) async {
    await _wait();
    guard.require(AppPermission.calendarView);
    final day = _days(employeeId, date.dateOnly, date.dateOnly).single;
    return CalendarDayDetailModel(
      day: day,
      // Change history only for roles with `audit.view`.
      history: guard.has(AppPermission.auditView)
          ? audit?.forDay(employeeId, date) ?? const []
          : const [],
    );
  }

  List<CalendarDayModel> _days(String employeeId, DateTime from, DateTime to) {
    final today = now().dateOnly;
    final records = {
      for (final r in attendance.recordsBetween(employeeId, from, to))
        r.date: r,
    };
    final leaveRecords = leaves?.leavesOf(employeeId, from, to) ?? const [];
    final schedules = attendance.schedules;

    return [
      for (
        var date = from;
        !date.isAfter(to);
        date = DateTime(date.year, date.month, date.day + 1)
      )
        _day(
          date: date,
          today: today,
          schedule: schedules.on(employeeId, date),
          record: records[date],
          leaves: [
            for (final l in leaveRecords)
              if (l.status != LeaveStatus.cancelled &&
                  !date.isBefore(l.startDate) &&
                  !date.isAfter(l.endDate))
                CalendarLeaveModel(
                  id: l.id,
                  leaveType: l.leaveType,
                  status: l.status,
                  isHalfDay: l.isHalfDay,
                ),
          ],
        ),
    ];
  }

  CalendarDayModel _day({
    required DateTime date,
    required DateTime today,
    required WorkScheduleModel? schedule,
    required AttendanceRecordModel? record,
    required List<CalendarLeaveModel> leaves,
  }) {
    final holiday = holidays.on(date);
    final dayType = holiday != null
        ? CalendarDayType.holiday
        : schedule != null && schedule.weeklyOffDays.contains(date.weekday)
        ? CalendarDayType.weekOff
        : CalendarDayType.working;
    final working = dayType == CalendarDayType.working;
    // Nothing to show for an off day without work, or for days to come.
    final showAttendance =
        record != null &&
        !date.isAfter(today) &&
        (working || record.punchIn != null);

    return CalendarDayModel(
      date: date,
      dayType: dayType,
      holidayName: holiday?.name,
      schedule: working && schedule != null
          ? ScheduleSnapshotModel(
              startTime: schedule.startTime,
              endTime: schedule.endTime,
              expectedMinutes: schedule.expectedMinutes,
            )
          : null,
      attendance: showAttendance
          ? CalendarAttendanceModel(
              id: record.id,
              status: record.status,
              dayKind: record.dayKind,
              punchIn: record.punchIn,
              punchOut: record.punchOut,
              workedMinutes: record.workedMinutes,
              corrected: record.correctedBy != null,
            )
          : null,
      leaves: leaves,
      overtimeMinutes: showAttendance ? record.overtimeMinutes ?? 0 : 0,
    );
  }

  /// Totals of the month so far (attendance counts stop at today; holidays
  /// and weekly offs cover the whole month).
  CalendarSummaryModel _summary(List<CalendarDayModel> days) {
    int count(bool Function(CalendarDayModel d) test) =>
        days.where(test).length;
    final today = now().dateOnly;
    final past = days.where((d) => !d.date.isAfter(today)).toList();
    var expected = 0;
    var worked = 0;
    var overtime = 0;
    var leaveDays = 0.0;
    for (final d in past) {
      final a = d.attendance;
      if (a == null) continue;
      worked += a.workedMinutes ?? 0;
      overtime += d.overtimeMinutes;
      if (d.dayType == CalendarDayType.working) {
        final scheduled = d.schedule?.expectedMinutes ?? 0;
        switch (a.status) {
          case AttendanceDayStatus.onLeave:
            leaveDays += 1;
          case AttendanceDayStatus.halfDay:
            leaveDays += 0.5;
            expected += scheduled ~/ 2;
          default:
            expected += scheduled;
        }
      }
    }
    bool workingPast(CalendarDayModel d) =>
        d.dayType == CalendarDayType.working && !d.date.isAfter(today);

    return CalendarSummaryModel(
      workingDays: past.where(workingPast).length,
      present: past
          .where(
            (d) =>
                workingPast(d) &&
                const {
                  AttendanceDayStatus.present,
                  AttendanceDayStatus.late,
                  AttendanceDayStatus.halfDay,
                }.contains(d.attendance?.status),
          )
          .length,
      absent: past
          .where(
            (d) =>
                workingPast(d) &&
                d.attendance?.status == AttendanceDayStatus.absent,
          )
          .length,
      leaveDays: leaveDays,
      holidays: count((d) => d.dayType == CalendarDayType.holiday),
      weekOffs: count((d) => d.dayType == CalendarDayType.weekOff),
      holidayWorked: past
          .where(
            (d) => d.attendance?.dayKind == AttendanceDayKind.holidayWorked,
          )
          .length,
      weekOffWorked: past
          .where(
            (d) => d.attendance?.dayKind == AttendanceDayKind.weekOffWorked,
          )
          .length,
      expectedMinutes: expected,
      workedMinutes: worked,
      overtimeMinutes: overtime,
    );
  }
}
