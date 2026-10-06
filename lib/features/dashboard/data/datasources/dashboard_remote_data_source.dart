import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

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
    return ref.watch(mockActiveTenantProvider).dashboard;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationIdProvider);
  return DashboardApiDataSource(ref.watch(apiClientProvider));
});
