import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

abstract interface class EmployeeRemoteDataSource {
  Future<EmployeeListModel> list(EmployeeQuery query);

  Future<EmployeeModel> getById(String id);

  Future<String> nextEcNumber();

  Future<EmployeeModel> create(EmployeeFormData data);

  Future<EmployeeModel> update(String id, EmployeeFormData data);

  Future<EmployeeModel> setStatus(String id, EmployeeStatus status);

  Future<LeaveBalanceModel> leaveBalance(String id);

  Future<List<LeaveHistoryItemModel>> leaveHistory(String id);

  /// Schedule versions, newest first.
  Future<List<WorkScheduleModel>> schedules(String id);

  /// Adds a schedule version from its effective date.
  Future<WorkScheduleModel> addSchedule(String id, WorkScheduleInput input);
}

class EmployeeApiDataSource implements EmployeeRemoteDataSource {
  EmployeeApiDataSource(this._client);

  final ApiClient _client;

  static Map<String, dynamic> _map(Object? json) =>
      json! as Map<String, dynamic>;

  static List<T> _list<T>(
    Object? json,
    T Function(Map<String, dynamic>) fromJson,
  ) => (json! as List<Object?>).map((item) => fromJson(_map(item))).toList();

  static EmployeeModel _employee(Object? json) =>
      EmployeeModel.fromJson(_map(json));

  @override
  Future<EmployeeListModel> list(EmployeeQuery query) => _client.get(
    ApiConstants.employees,
    query: query.toQueryParameters(),
    parse: (json) => EmployeeListModel.fromJson(_map(json)),
  );

  @override
  Future<EmployeeModel> getById(String id) =>
      _client.get(ApiConstants.employee(id), parse: _employee);

  @override
  Future<String> nextEcNumber() => _client.get(
    ApiConstants.nextEcNumber,
    parse: (json) => _map(json)['ecNumber']! as String,
  );

  @override
  Future<EmployeeModel> create(EmployeeFormData data) => _client.post(
    ApiConstants.employees,
    body: data.toJson(),
    parse: _employee,
  );

  @override
  Future<EmployeeModel> update(String id, EmployeeFormData data) => _client
      .patch(ApiConstants.employee(id), body: data.toJson(), parse: _employee);

  @override
  Future<EmployeeModel> setStatus(String id, EmployeeStatus status) =>
      _client.patch(
        ApiConstants.employeeStatus(id),
        body: {'status': status.name},
        parse: _employee,
      );

  @override
  Future<LeaveBalanceModel> leaveBalance(String id) => _client.get(
    ApiConstants.employeeLeaveBalance(id),
    parse: (json) => LeaveBalanceModel.fromJson(_map(json)),
  );

  @override
  Future<List<LeaveHistoryItemModel>> leaveHistory(String id) => _client.get(
    ApiConstants.employeeLeaves(id),
    parse: (json) => _list(json, LeaveHistoryItemModel.fromJson),
  );

  @override
  Future<List<WorkScheduleModel>> schedules(String id) => _client.get(
    ApiConstants.employeeSchedules(id),
    parse: (json) => _list(json, WorkScheduleModel.fromJson),
  );

  @override
  Future<WorkScheduleModel> addSchedule(String id, WorkScheduleInput input) =>
      _client.post(
        ApiConstants.employeeSchedules(id),
        body: input.toJson(),
        parse: (json) => WorkScheduleModel.fromJson(_map(json)),
      );
}

final employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>((
  ref,
) {
  if (ref.watch(envProvider).useMockApi) {
    return ref.watch(mockActiveTenantProvider).employeeSource;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationIdProvider);
  return EmployeeApiDataSource(ref.watch(apiClientProvider));
});
