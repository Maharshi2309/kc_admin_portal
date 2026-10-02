import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_mock_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> summary(DateTime date);

  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month);
}

class DashboardApiDataSource implements DashboardRemoteDataSource {
  DashboardApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<DashboardSummaryModel> summary(DateTime date) => _client.get(
    ApiConstants.dashboardSummary,
    query: {'date': ApiDateFormat.date(date)},
    parse: (json) =>
        DashboardSummaryModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month) =>
      _client.get(
        ApiConstants.dashboardAttendanceChart,
        query: {'month': ApiDateFormat.month(month)},
        parse: (json) =>
            MonthlyAttendanceModel.fromJson(json! as Map<String, dynamic>),
      );
}

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    final attendance = ref.watch(attendanceRemoteDataSourceProvider);
    final leaves = ref.watch(leaveRemoteDataSourceProvider);
    return DashboardMockDataSource(
      guard: ref.watch(mockGuardProvider),
      now: ref.watch(clockProvider),
      latency: ref.watch(mockLatencyProvider),
      attendance: attendance is AttendanceMockDataSource ? attendance : null,
      leaves: leaves is LeaveMockDataSource ? leaves : null,
      holidayOn: ref.watch(mockHolidayStoreProvider).on,
    );
  }
  return DashboardApiDataSource(ref.watch(apiClientProvider));
});
