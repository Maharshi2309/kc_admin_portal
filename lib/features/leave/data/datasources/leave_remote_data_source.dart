import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

abstract interface class LeaveRemoteDataSource {
  Future<LeaveListModel> list(LeaveQuery query);

  Future<LeaveModel> getById(String id);

  Future<LeaveModel> create(LeaveFormData data);

  Future<LeaveModel> update(String id, LeaveFormData data);

  /// Approve, reject or cancel.
  Future<LeaveModel> setStatus(String id, LeaveStatus status);

  Future<List<LeaveTypeModel>> types();

  Future<LeavePreviewModel> preview(LeavePreviewRequest request);

  /// Company holidays, and [employeeId]'s weekly offs when given.
  Future<LeaveCalendarModel> calendar(DateTime month, {String? employeeId});
}

class LeaveApiDataSource implements LeaveRemoteDataSource {
  LeaveApiDataSource(this._client);

  final ApiClient _client;

  static Map<String, dynamic> _map(Object? json) =>
      json! as Map<String, dynamic>;

  static LeaveModel _leave(Object? json) => LeaveModel.fromJson(_map(json));

  @override
  Future<LeaveListModel> list(LeaveQuery query) => _client.get(
    ApiConstants.leaves,
    query: query.toQueryParameters(),
    parse: (json) => LeaveListModel.fromJson(_map(json)),
  );

  @override
  Future<LeaveModel> getById(String id) =>
      _client.get(ApiConstants.leave(id), parse: _leave);

  @override
  Future<LeaveModel> create(LeaveFormData data) =>
      _client.post(ApiConstants.leaves, body: data.toJson(), parse: _leave);

  @override
  Future<LeaveModel> update(String id, LeaveFormData data) =>
      _client.patch(ApiConstants.leave(id), body: data.toJson(), parse: _leave);

  @override
  Future<LeaveModel> setStatus(String id, LeaveStatus status) => _client.patch(
    ApiConstants.leaveStatus(id),
    body: {'status': status.name},
    parse: _leave,
  );

  @override
  Future<List<LeaveTypeModel>> types() => _client.get(
    ApiConstants.leaveTypes,
    parse: (json) => (json! as List<Object?>)
        .map((item) => LeaveTypeModel.fromJson(_map(item)))
        .toList(),
  );

  @override
  Future<LeavePreviewModel> preview(LeavePreviewRequest request) =>
      _client.post(
        ApiConstants.leavePreview,
        body: request.toJson(),
        parse: (json) => LeavePreviewModel.fromJson(_map(json)),
      );

  @override
  Future<LeaveCalendarModel> calendar(DateTime month, {String? employeeId}) =>
      _client.get(
        ApiConstants.leaveCalendar,
        query: {'month': ApiDateFormat.month(month), 'employeeId': ?employeeId},
        parse: (json) => LeaveCalendarModel.fromJson(_map(json)),
      );
}

final leaveRemoteDataSourceProvider = Provider<LeaveRemoteDataSource>((ref) {
  if (ref.watch(envProvider).useMockApi) {
    return LeaveMockDataSource(
      guard: ref.watch(mockGuardProvider),
      now: ref.watch(clockProvider),
      employees: ref.watch(mockEmployeeStoreProvider),
      latency: ref.watch(mockLatencyProvider),
      holidays: ref.watch(mockHolidayStoreProvider),
      schedules: ref.watch(mockScheduleBookProvider),
      audit: ref.watch(mockAuditLogProvider),
    );
  }
  return LeaveApiDataSource(ref.watch(apiClientProvider));
});
