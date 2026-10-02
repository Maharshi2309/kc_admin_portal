import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/monthly_attendance_model.dart';
import 'package:kc_admin_portal/features/dashboard/data/repositories/dashboard_repository_impl.dart';

/// Today's dashboard cards and lists. Refetched each time the dashboard is
/// opened after being left (auto-dispose).
final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummaryModel>((ref) {
      final today = ref.watch(clockProvider)().dateOnly;
      return ref.watch(dashboardRepositoryProvider).summary(today);
    }, retry: (_, _) => null);

/// Daily attendance for the current month (the dashboard chart).
final monthlyAttendanceProvider =
    FutureProvider.autoDispose<MonthlyAttendanceModel>((ref) {
      final month = ref.watch(clockProvider)().monthStart;
      return ref.watch(dashboardRepositoryProvider).monthlyAttendance(month);
    }, retry: (_, _) => null);
