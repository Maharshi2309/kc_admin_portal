import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// DEV ONLY (`USE_MOCK_API=true`): sample dashboard data shaped like the
/// assumed API responses, so the screen can be built before the backend
/// exists. Values are illustrative, not business data.
///
/// With [attendance] set, today's figures and lists come from the attendance
/// mock, so punching someone in anywhere updates the dashboard too.
class DashboardMockDataSource implements DashboardRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  DashboardMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.now,
    this.latency = Duration.zero,
    this.attendance,
    this.leaves,
    this.holidayOn,
  });

  final DateTime Function() now;
  final Duration latency;
  final AttendanceMockDataSource? attendance;

  /// When set, the pending-leave count and leave figures come from the
  /// leave mock.
  final LeaveMockDataSource? leaves;

  /// The company holiday on a date, from the holiday mock.
  final HolidayModel? Function(DateTime date)? holidayOn;

  static const int _previewSize = 3;

  /// From the leave mock when shared; sample figures otherwise.
  LeaveUsageModel _leaveUsage(DateTime today) {
    final source = leaves;
    if (source == null) {
      return LeaveUsageModel(
        year: today.year,
        casualRemainingDays: 412,
        casualTakenDays: 286,
        unpaidTakenDays: 26,
        approvedThisMonth: 41,
        pendingThisMonth: 3,
        rejectedThisMonth: 2,
      );
    }
    final usage = source.usage(today);
    return LeaveUsageModel(
      year: today.year,
      casualRemainingDays: usage.casualRemaining,
      casualTakenDays: usage.casualTaken,
      unpaidTakenDays: usage.unpaidTaken,
      approvedThisMonth: usage.approved,
      pendingThisMonth: usage.pending,
      rejectedThisMonth: usage.rejected,
    );
  }

  @override
  Future<DashboardSummaryModel> summary(DateTime date) async {
    await Future<void>.delayed(latency);
    guard.require(AppPermission.dashboardView);
    final today = date.dateOnly;
    final source = attendance;
    if (source != null) return _fromAttendance(source, today);

    return DashboardSummaryModel(
      date: today,
      totalEmployees: 124,
      presentToday: 104,
      presentPercent: 84,
      onLeaveToday: 9,
      onLeavePercent: 7,
      absentToday: 11,
      absentPercent: 9,
      attention: const [
        AttentionItemModel(kind: AttentionKind.notPunchedIn, count: 11),
        AttentionItemModel(kind: AttentionKind.pendingLeave, count: 3),
        AttentionItemModel(kind: AttentionKind.lateArrival, count: 6),
      ],
      notPunchedInTotal: 11,
      notPunchedIn: const [
        EmployeeSummaryModel(
          id: '1042',
          name: 'Rohan Patel',
          ecNumber: 'KC1042',
          department: JobRole.graphicDesigner,
        ),
        EmployeeSummaryModel(
          id: '1057',
          name: 'Kavya Mehta',
          ecNumber: 'KC1057',
          department: JobRole.accountant,
        ),
        EmployeeSummaryModel(
          id: '1073',
          name: 'Arjun Joshi',
          ecNumber: 'KC1073',
          department: JobRole.tailor,
        ),
      ],
      onLeave: [
        LeaveTodayModel(
          employee: const EmployeeSummaryModel(
            id: '1014',
            name: 'Priya Desai',
            ecNumber: 'KC1014',
          ),
          leaveType: 'Casual',
          endDate: today.add(const Duration(days: 2)),
          days: 3,
        ),
        LeaveTodayModel(
          employee: const EmployeeSummaryModel(
            id: '1061',
            name: 'Harsh Vaghela',
            ecNumber: 'KC1061',
          ),
          leaveType: 'Casual',
          endDate: today,
          days: 1,
        ),
        LeaveTodayModel(
          employee: const EmployeeSummaryModel(
            id: '1066',
            name: 'Meera Rathod',
            ecNumber: 'KC1066',
          ),
          leaveType: 'Casual',
          endDate: today,
          days: 0.5,
          isHalfDay: true,
        ),
      ],
      leaveUsage: _leaveUsage(today),
    );
  }

  /// Today's figures from the attendance records (docs/DATABASE_V2.md §3):
  /// only employees scheduled to work can be present, on leave or absent;
  /// holidays and weekly offs are never absences.
  DashboardSummaryModel _fromAttendance(
    AttendanceMockDataSource source,
    DateTime today,
  ) {
    final records = source.recordsOn(today);
    final scheduled = records.where(_isScheduled).toList();
    List<AttendanceRecordModel> withStatus(
      bool Function(AttendanceDayStatus status) test,
    ) => [
      for (final r in scheduled)
        if (test(r.status)) r,
    ];
    final present = withStatus(_isPresent);
    final onLeave = withStatus((s) => s == AttendanceDayStatus.onLeave);
    final absent = withStatus((s) => s == AttendanceDayStatus.absent)
      ..sort((a, b) => a.employee.name.compareTo(b.employee.name));
    final late = withStatus((s) => s == AttendanceDayStatus.late).length;
    double? percent(int count) => scheduled.isEmpty
        ? null
        : (count * 100 / scheduled.length).roundToDouble();

    final showOvertime = guard.has(AppPermission.overtimeView);
    final overtime = showOvertime ? _overtimeThisMonth(source, today) : null;

    return DashboardSummaryModel(
      date: today,
      totalEmployees: records.length,
      scheduledToday: scheduled.length,
      presentToday: present.length,
      presentPercent: percent(present.length),
      onLeaveToday: onLeave.length,
      onLeavePercent: percent(onLeave.length),
      absentToday: absent.length,
      absentPercent: percent(absent.length),
      holiday: holidayOn?.call(today),
      weekOffToday: records
          .where(
            (r) =>
                r.status == AttendanceDayStatus.weeklyOff ||
                r.dayKind == AttendanceDayKind.weekOffWorked,
          )
          .length,
      holidayWorkedToday: records
          .where((r) => r.dayKind == AttendanceDayKind.holidayWorked)
          .length,
      weekOffWorkedToday: records
          .where((r) => r.dayKind == AttendanceDayKind.weekOffWorked)
          .length,
      overtimeMinutesThisMonth: overtime?.minutes,
      overtimeEmployeesThisMonth: overtime?.employees,
      attention: [
        if (absent.isNotEmpty)
          AttentionItemModel(
            kind: AttentionKind.notPunchedIn,
            count: absent.length,
          ),
        AttentionItemModel(
          kind: AttentionKind.pendingLeave,
          count: leaves?.pendingCount ?? 3,
        ),
        if (late > 0)
          AttentionItemModel(kind: AttentionKind.lateArrival, count: late),
      ],
      notPunchedInTotal: absent.length,
      notPunchedIn: [for (final r in absent.take(_previewSize)) r.employee],
      onLeave: [
        for (final r in onLeave.take(_previewSize))
          LeaveTodayModel(
            employee: r.employee,
            leaveType: 'Casual',
            endDate: today,
            days: 1,
          ),
      ],
      leaveUsage: _leaveUsage(today),
    );
  }

  /// Expected at work: a working day on their schedule (not a holiday or
  /// their weekly off, worked or not).
  static bool _isScheduled(AttendanceRecordModel r) =>
      r.dayKind == AttendanceDayKind.working &&
      r.status != AttendanceDayStatus.holiday &&
      r.status != AttendanceDayStatus.weeklyOff;

  /// Half days count as present, as on the attendance page.
  static bool _isPresent(AttendanceDayStatus status) =>
      status == AttendanceDayStatus.present ||
      status == AttendanceDayStatus.late ||
      status == AttendanceDayStatus.halfDay;

  static List<DateTime> _monthToDate(DateTime today) => [
    for (
      var date = today.monthStart;
      !date.isAfter(today);
      date = DateTime(date.year, date.month, date.day + 1)
    )
      date,
  ];

  ({int minutes, int employees}) _overtimeThisMonth(
    AttendanceMockDataSource source,
    DateTime today,
  ) {
    final byEmployee = <String, int>{};
    for (final date in _monthToDate(today)) {
      for (final r in source.recordsOn(date)) {
        final minutes = r.overtimeMinutes ?? 0;
        if (minutes > 0) {
          byEmployee.update(
            r.employee.id,
            (sum) => sum + minutes,
            ifAbsent: () => minutes,
          );
        }
      }
    }
    return (
      minutes: byEmployee.values.fold(0, (a, b) => a + b),
      employees: byEmployee.length,
    );
  }

  @override
  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month) async {
    await Future<void>.delayed(latency);
    guard.require(AppPermission.dashboardView);
    final today = now().dateOnly;
    final start = month.monthStart;
    final source = attendance;

    final days = <DailyAttendanceModel>[];
    for (
      var date = start;
      date.month == start.month && !date.isAfter(today);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      if (source == null) {
        if (date.weekday == DateTime.sunday) continue;
        // Deterministic sample values between 80 and 91.
        days.add(
          DailyAttendanceModel(date: date, percent: 80 + date.day * 7 % 12),
        );
        continue;
      }
      // Present among those scheduled; days nobody was scheduled are left
      // out (holidays, everyone's weekly off).
      final scheduled = source.recordsOn(date).where(_isScheduled).toList();
      if (scheduled.isEmpty) continue;
      final present = scheduled.where((r) => _isPresent(r.status)).length;
      days.add(
        DailyAttendanceModel(
          date: date,
          percent: (present * 1000 / scheduled.length).round() / 10,
        ),
      );
    }

    final average = days.isEmpty
        ? null
        : days.map((d) => d.percent).reduce((a, b) => a + b) / days.length;
    return MonthlyAttendanceModel(
      month: start,
      averagePercent: average,
      days: days,
    );
  }
}
