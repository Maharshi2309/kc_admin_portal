import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';

/// An employee's calendar: every day's type, attendance, leave and
/// overtime, decided by the backend. Throws an `AppException` on failure.
abstract interface class CalendarRepository {
  Future<EmployeeCalendarModel> month(String employeeId, DateTime month);

  /// One day in full, with its change history.
  Future<CalendarDayDetailModel> day(String employeeId, DateTime date);
}
