import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// Employee records. All methods throw an `AppException` on failure.
///
/// There is deliberately no delete: employees are only deactivated
/// (confirmed 2026-09-29).
abstract interface class EmployeeRepository {
  Future<EmployeeListModel> list(EmployeeQuery query);

  Future<EmployeeModel> getById(String id);

  /// Suggested EC number for a new employee; the admin may change it.
  Future<String> nextEcNumber();

  Future<EmployeeModel> create(EmployeeFormData data);

  Future<EmployeeModel> update(String id, EmployeeFormData data);

  /// Activates or deactivates an employee.
  Future<EmployeeModel> setStatus(String id, EmployeeStatus status);

  Future<LeaveBalanceModel> leaveBalance(String id);

  Future<List<LeaveHistoryItemModel>> leaveHistory(String id);

  /// Working-schedule versions, newest first.
  Future<List<WorkScheduleModel>> schedules(String id);

  /// Adds a schedule version from its effective date; the previous version
  /// ends the day before.
  Future<WorkScheduleModel> addSchedule(String id, WorkScheduleInput input);
}
