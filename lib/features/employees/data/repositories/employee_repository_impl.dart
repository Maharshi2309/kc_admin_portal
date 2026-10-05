import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/repositories/employee_repository.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this._remote);

  final EmployeeRemoteDataSource _remote;

  @override
  Future<EmployeeListModel> list(EmployeeQuery query) => _remote.list(query);

  @override
  Future<EmployeeModel> getById(String id) => _remote.getById(id);

  @override
  Future<String> nextEcNumber() => _remote.nextEcNumber();

  @override
  Future<EmployeeModel> create(EmployeeFormData data) =>
      _remote.create(_normalised(data));

  @override
  Future<EmployeeModel> update(String id, EmployeeFormData data) =>
      _remote.update(id, _normalised(data));

  @override
  Future<EmployeeModel> setStatus(String id, EmployeeStatus status) =>
      _remote.setStatus(id, status);

  @override
  Future<LeaveBalanceModel> leaveBalance(String id) => _remote.leaveBalance(id);

  @override
  Future<List<LeaveHistoryItemModel>> leaveHistory(String id) =>
      _remote.leaveHistory(id);

  @override
  Future<List<WorkScheduleModel>> schedules(String id) => _remote.schedules(id);

  @override
  Future<WorkScheduleModel> addSchedule(String id, WorkScheduleInput input) =>
      _remote.addSchedule(id, input);

  /// Trims text and upper-cases the EC number before sending.
  static EmployeeFormData _normalised(EmployeeFormData data) => data.copyWith(
    ecNumber: data.ecNumber.trim().toUpperCase(),
    name: data.name.trim(),
    mobile: data.mobile.trim(),
  );
}

final employeeRepositoryProvider = Provider<EmployeeRepository>(
  (ref) => EmployeeRepositoryImpl(ref.watch(employeeRemoteDataSourceProvider)),
);
