import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/domain/repositories/leave_repository.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl(this._remote);

  final LeaveRemoteDataSource _remote;

  @override
  Future<LeaveListModel> list(LeaveQuery query) => _remote.list(query);

  @override
  Future<LeaveModel> getById(String id) => _remote.getById(id);

  @override
  Future<LeaveModel> create(LeaveFormData data) =>
      _remote.create(_normalised(data));

  @override
  Future<LeaveModel> update(String id, LeaveFormData data) =>
      _remote.update(id, _normalised(data));

  @override
  Future<LeaveModel> setStatus(String id, LeaveStatus status) =>
      _remote.setStatus(id, status);

  @override
  Future<List<LeaveTypeModel>> types() => _remote.types();

  @override
  Future<LeavePreviewModel> preview(LeavePreviewRequest request) =>
      _remote.preview(request);

  @override
  Future<LeaveCalendarModel> calendar(DateTime month, {String? employeeId}) =>
      _remote.calendar(month, employeeId: employeeId);

  /// A half day is a single date; blank remarks are sent as absent.
  static LeaveFormData _normalised(LeaveFormData data) {
    final remarks = data.remarks?.trim();
    return data.copyWith(
      endDate: data.isHalfDay ? data.startDate : data.endDate,
      remarks: remarks == null || remarks.isEmpty ? null : remarks,
    );
  }
}

final leaveRepositoryProvider = Provider<LeaveRepository>(
  (ref) => LeaveRepositoryImpl(ref.watch(leaveRemoteDataSourceProvider)),
);
