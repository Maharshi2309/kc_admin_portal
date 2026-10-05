import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';

/// Fixed "today" for dashboard tests: Monday 28 Sep 2026, 14:30.
final testNow = DateTime(2026, 9, 28, 14, 30);

final testSummary = DashboardSummaryModel(
  date: DateTime(2026, 9, 28),
  totalEmployees: 124,
  scheduledToday: 124,
  overtimeMinutesThisMonth: 2550,
  overtimeEmployeesThisMonth: 8,
  presentToday: 104,
  presentPercent: 84,
  onLeaveToday: 9,
  onLeavePercent: 7,
  absentToday: 11,
  absentPercent: 9,
  attention: const [
    AttentionItemModel(kind: AttentionKind.notPunchedIn, count: 11),
    AttentionItemModel(kind: AttentionKind.pendingLeave, count: 3),
    AttentionItemModel(kind: AttentionKind.unknown, count: 5),
  ],
  notPunchedInTotal: 11,
  notPunchedIn: const [
    EmployeeSummaryModel(
      id: '1042',
      name: 'Rohan Patel',
      ecNumber: 'KC1042',
      department: JobRole.graphicDesigner,
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
      endDate: DateTime(2026, 9, 30),
      days: 3,
    ),
  ],
  leaveUsage: const LeaveUsageModel(
    year: 2026,
    casualRemainingDays: 412,
    casualTakenDays: 286,
    unpaidTakenDays: 26,
    approvedThisMonth: 41,
    pendingThisMonth: 3,
    rejectedThisMonth: 4,
  ),
);

final testMonthly = MonthlyAttendanceModel(
  month: DateTime(2026, 9),
  averagePercent: 86.4,
  days: [
    for (final (day, percent) in [(25, 88.0), (26, 86.0), (28, 84.0)])
      DailyAttendanceModel(date: DateTime(2026, 9, day), percent: percent),
  ],
);

/// In-memory [DashboardRepository] with optional failures per call.
class FakeDashboardRepository implements DashboardRepository {
  FakeDashboardRepository({
    DashboardSummaryModel? summary,
    MonthlyAttendanceModel? monthly,
    this.summaryError,
    this.monthlyError,
  }) : summaryResult = summary ?? testSummary,
       monthlyResult = monthly ?? testMonthly;

  DashboardSummaryModel summaryResult;
  MonthlyAttendanceModel monthlyResult;
  AppException? summaryError;
  AppException? monthlyError;

  @override
  Future<DashboardSummaryModel> summary(DateTime date) async {
    if (summaryError != null) throw summaryError!;
    return summaryResult;
  }

  @override
  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month) async {
    if (monthlyError != null) throw monthlyError!;
    return monthlyResult;
  }
}
