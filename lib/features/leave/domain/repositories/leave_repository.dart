import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Leave records. All methods throw an `AppException` on failure.
///
/// There is no delete: leave is cancelled and stays in history.
abstract interface class LeaveRepository {
  Future<LeaveListModel> list(LeaveQuery query);

  Future<LeaveModel> getById(String id);

  Future<LeaveModel> create(LeaveFormData data);

  Future<LeaveModel> update(String id, LeaveFormData data);

  /// Approve, reject or cancel.
  Future<LeaveModel> setStatus(String id, LeaveStatus status);

  Future<List<LeaveTypeModel>> types();

  /// Days and balance the backend would count for [request].
  Future<LeavePreviewModel> preview(LeavePreviewRequest request);

  /// Company holidays, and [employeeId]'s weekly offs when given.
  Future<LeaveCalendarModel> calendar(DateTime month, {String? employeeId});
}
