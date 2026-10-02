import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl(this._remote);

  final AttendanceRemoteDataSource _remote;

  @override
  Future<AttendanceDayModel> day(AttendanceQuery query, {int page = 1}) =>
      _remote.day(query, page);

  @override
  Future<AttendanceRecordModel> getById(String id) => _remote.getById(id);

  @override
  Future<AttendanceRecordModel> punchIn(String employeeId) =>
      _remote.punchIn(employeeId);

  @override
  Future<AttendanceRecordModel> punchOut(String employeeId) =>
      _remote.punchOut(employeeId);

  @override
  Future<int> punchInAll(DateTime date) => _remote.punchInAll(date);

  @override
  Future<AttendanceRecordModel> correct(
    String id,
    AttendanceCorrectionData data,
  ) => _remote.correct(id, _trimmed(data));

  @override
  Future<AttendanceRecordModel> create(AttendanceCorrectionData data) =>
      _remote.create(_trimmed(data));

  @override
  Future<List<AttendanceRecordModel>> employeeLog(
    String employeeId,
    DateTime month,
  ) => _remote.employeeLog(employeeId, month);

  /// Blank remarks are sent as absent.
  static AttendanceCorrectionData _trimmed(AttendanceCorrectionData data) {
    final remarks = data.remarks?.trim();
    return data.copyWith(
      remarks: remarks == null || remarks.isEmpty ? null : remarks,
    );
  }
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) =>
      AttendanceRepositoryImpl(ref.watch(attendanceRemoteDataSourceProvider)),
);
