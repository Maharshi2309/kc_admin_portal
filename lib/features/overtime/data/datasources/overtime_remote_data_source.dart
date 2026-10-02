import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_mock_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

/// An employee's overtime over the API. Throws an `AppException` on
/// failure.
abstract interface class OvertimeRemoteDataSource {
  Future<OvertimeReportModel> report(
    String employeeId, {
    required DateTime from,
    required DateTime to,
  });
}

class OvertimeApiDataSource implements OvertimeRemoteDataSource {
  OvertimeApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<OvertimeReportModel> report(
    String employeeId, {
    required DateTime from,
    required DateTime to,
  }) => _client.get(
    ApiConstants.employeeOvertime(employeeId),
    query: {'from': dateToJson(from), 'to': dateToJson(to)},
    parse: (json) =>
        OvertimeReportModel.fromJson(json! as Map<String, dynamic>),
  );
}

final overtimeRemoteDataSourceProvider = Provider<OvertimeRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    final attendance = ref.watch(attendanceRemoteDataSourceProvider);
    return OvertimeMockDataSource(
      guard: ref.watch(mockGuardProvider),
      attendance: attendance is AttendanceMockDataSource
          ? attendance
          : AttendanceMockDataSource(now: ref.watch(clockProvider)),
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return OvertimeApiDataSource(ref.watch(apiClientProvider));
});
