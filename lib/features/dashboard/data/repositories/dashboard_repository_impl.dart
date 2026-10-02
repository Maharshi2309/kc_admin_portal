import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<DashboardSummaryModel> summary(DateTime date) => _remote.summary(date);

  @override
  Future<MonthlyAttendanceModel> monthlyAttendance(DateTime month) =>
      _remote.monthlyAttendance(month);
}

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) =>
      DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider)),
);
