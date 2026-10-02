import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

abstract interface class AttendanceRemoteDataSource {
  Future<AttendanceDayModel> day(AttendanceQuery query, int page);

  Future<AttendanceRecordModel> getById(String id);

  /// The server records the current time.
  Future<AttendanceRecordModel> punchIn(String employeeId);

  Future<AttendanceRecordModel> punchOut(String employeeId);

  /// Punches in everyone not punched in yet on [date]; returns how many.
  Future<int> punchInAll(DateTime date);

  Future<AttendanceRecordModel> correct(
    String id,
    AttendanceCorrectionData data,
  );

  /// Adds a record that is missing (e.g. forgot to punch).
  Future<AttendanceRecordModel> create(AttendanceCorrectionData data);

  Future<List<AttendanceRecordModel>> employeeLog(
    String employeeId,
    DateTime month,
  );
}

class AttendanceApiDataSource implements AttendanceRemoteDataSource {
  AttendanceApiDataSource(this._client);

  final ApiClient _client;

  static Map<String, dynamic> _map(Object? json) =>
      json! as Map<String, dynamic>;

  static AttendanceRecordModel _record(Object? json) =>
      AttendanceRecordModel.fromJson(_map(json));

  @override
  Future<AttendanceDayModel> day(AttendanceQuery query, int page) =>
      _client.get(
        ApiConstants.attendance,
        query: query.toQueryParameters(page),
        parse: (json) => AttendanceDayModel.fromJson(_map(json)),
      );

  @override
  Future<AttendanceRecordModel> getById(String id) =>
      _client.get(ApiConstants.attendanceRecord(id), parse: _record);

  @override
  Future<AttendanceRecordModel> punchIn(String employeeId) => _client.post(
    ApiConstants.punchIn,
    body: {'employeeId': employeeId},
    parse: _record,
  );

  @override
  Future<AttendanceRecordModel> punchOut(String employeeId) => _client.post(
    ApiConstants.punchOut,
    body: {'employeeId': employeeId},
    parse: _record,
  );

  @override
  Future<int> punchInAll(DateTime date) => _client.post(
    ApiConstants.punchInAll,
    body: {'date': dateToJson(date)},
    parse: (json) => (_map(json)['count']! as num).toInt(),
  );

  @override
  Future<AttendanceRecordModel> correct(
    String id,
    AttendanceCorrectionData data,
  ) => _client.patch(
    ApiConstants.attendanceRecord(id),
    body: data.toJson(),
    parse: _record,
  );

  @override
  Future<AttendanceRecordModel> create(AttendanceCorrectionData data) => _client
      .post(ApiConstants.attendance, body: data.toJson(), parse: _record);

  @override
  Future<List<AttendanceRecordModel>> employeeLog(
    String employeeId,
    DateTime month,
  ) => _client.get(
    ApiConstants.employeeAttendanceLog(employeeId),
    query: {'month': ApiDateFormat.month(month)},
    parse: (json) =>
        (json! as List<Object?>).map(_record).toList(growable: false),
  );
}

final attendanceRemoteDataSourceProvider = Provider<AttendanceRemoteDataSource>(
  (ref) {
    if (ref.watch(envProvider).useMockApi) {
      final leaves = ref.watch(leaveRemoteDataSourceProvider);
      return AttendanceMockDataSource(
        guard: ref.watch(mockGuardProvider),
        now: ref.watch(clockProvider),
        latency: ref.watch(mockLatencyProvider),
        store: ref.watch(mockEmployeeStoreProvider),
        schedules: ref.watch(mockScheduleBookProvider),
        holidayOn: ref.watch(mockHolidayStoreProvider).on,
        leaveOn: leaves is LeaveMockDataSource ? leaves.leaveOn : null,
        audit: ref.watch(mockAuditLogProvider),
      );
    }
    return AttendanceApiDataSource(ref.watch(apiClientProvider));
  },
);
