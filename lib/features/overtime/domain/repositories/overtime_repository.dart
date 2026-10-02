import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';

/// An employee's overtime. Computed by the backend from attendance and the
/// employee's schedules; the app only formats it. Throws an `AppException`
/// on failure.
abstract interface class OvertimeRepository {
  Future<OvertimeReportModel> report(
    String employeeId, {
    required DateTime from,
    required DateTime to,
  });
}
