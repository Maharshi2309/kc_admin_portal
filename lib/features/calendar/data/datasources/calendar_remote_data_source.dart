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
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_mock_data_source.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

/// An employee's calendar over the API. Throws an `AppException` on
/// failure.
abstract interface class CalendarRemoteDataSource {
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month);

  Future<CalendarDayDetailModel> day(String employeeId, DateTime date);
}

class CalendarApiDataSource implements CalendarRemoteDataSource {
  CalendarApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month) =>
      _client.get(
        ApiConstants.employeeCalendar(employeeId),
        query: {'month': ApiDateFormat.month(month)},
        parse: (json) =>
            EmployeeCalendarModel.fromJson(json! as Map<String, dynamic>),
      );

  @override
  Future<CalendarDayDetailModel> day(String employeeId, DateTime date) =>
      _client.get(
        ApiConstants.employeeCalendarDay(employeeId, dateToJson(date)),
        parse: (json) =>
            CalendarDayDetailModel.fromJson(json! as Map<String, dynamic>),
      );
}

final calendarRemoteDataSourceProvider = Provider<CalendarRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    final attendance = ref.watch(attendanceRemoteDataSourceProvider);
    final leaves = ref.watch(leaveRemoteDataSourceProvider);
    final now = ref.watch(clockProvider);
    return CalendarMockDataSource(
      guard: ref.watch(mockGuardProvider),
      now: now,
      attendance: attendance is AttendanceMockDataSource
          ? attendance
          : AttendanceMockDataSource(now: now),
      leaves: leaves is LeaveMockDataSource ? leaves : null,
      holidays: ref.watch(mockHolidayStoreProvider),
      audit: ref.watch(mockAuditLogProvider),
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return CalendarApiDataSource(ref.watch(apiClientProvider));
});
