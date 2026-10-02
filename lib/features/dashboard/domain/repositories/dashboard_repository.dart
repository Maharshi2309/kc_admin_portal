import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';

abstract interface class DashboardRepository {
  /// Cards and lists for [date]. Throws an `AppException` on failure.
  Future<DashboardSummaryModel> summary(DateTime date);

  /// Daily attendance percentages for the month containing [month].
  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month);
}
