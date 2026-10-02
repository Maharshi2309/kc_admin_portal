import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';

/// Attendance records and actions. All methods throw an `AppException` on
/// failure.
abstract interface class AttendanceRepository {
  Future<AttendanceDayModel> day(AttendanceQuery query, {int page = 1});

  Future<AttendanceRecordModel> getById(String id);

  /// Records a punch at the current server time.
  Future<AttendanceRecordModel> punchIn(String employeeId);

  Future<AttendanceRecordModel> punchOut(String employeeId);

  /// Punches in everyone not punched in yet on [date]; returns how many.
  Future<int> punchInAll(DateTime date);

  Future<AttendanceRecordModel> correct(
    String id,
    AttendanceCorrectionData data,
  );

  Future<AttendanceRecordModel> create(AttendanceCorrectionData data);

  Future<List<AttendanceRecordModel>> employeeLog(
    String employeeId,
    DateTime month,
  );
}
