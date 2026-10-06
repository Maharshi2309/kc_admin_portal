/// Every permission the portal checks, with the key the API uses.
///
/// The backend is the security layer: it rejects any request the signed-in
/// user's permissions do not allow (403). The app uses these only to hide or
/// disable what the user cannot do.
///
/// The list mirrors `docs/DATABASE_V2.md` (permissions seed). Keys the app
/// does not know are ignored, so the backend can add permissions first.
enum AppPermission {
  dashboardView('dashboard.view'),

  employeeView('employee.view'),
  employeeCreate('employee.create'),
  employeeEdit('employee.edit'),

  /// Deactivate and reactivate; employees are never deleted.
  employeeDeactivate('employee.deactivate'),

  /// Add a new working-schedule version. Viewing needs [employeeView].
  scheduleEdit('schedule.edit'),

  attendanceView('attendance.view'),

  /// Punch in, punch out and "Punch in all".
  attendancePunch('attendance.punch'),

  /// Correct a record, add a missing one, or record holiday / week-off work.
  attendanceCorrect('attendance.correct'),

  overtimeView('overtime.view'),

  leaveView('leave.view'),
  leaveCreate('leave.create'),

  /// Edit pending leave only (the backend enforces the status rule).
  leaveEdit('leave.edit'),
  leaveCancel('leave.cancel'),

  /// Approve and reject pending requests.
  leaveApprove('leave.approve'),

  /// Edits on the calendar use the permission of what is changed.
  calendarView('calendar.view'),

  holidayView('holiday.view'),
  holidayCreate('holiday.create'),
  holidayEdit('holiday.edit'),
  holidayDelete('holiday.delete'),

  /// Opens Access control: add and edit staff users, deactivate them, and
  /// choose each user's permissions. (Anyone with it could grant themselves
  /// anything, so users are not split into finer permissions.)
  permissionManage('permission.manage'),

  auditView('audit.view'),

  /// Settings: the organization's name, logo and time zone, its departments
  /// and positions, and its working defaults (2026-10-06).
  settingsManage('settings.manage');

  const AppPermission(this.key);

  /// The API's name for this permission, e.g. `employee.edit`.
  final String key;

  static final Map<String, AppPermission> _byKey = {
    for (final permission in values) permission.key: permission,
  };

  /// The permission for [key], or null if this app version does not know it.
  static AppPermission? fromKey(String key) => _byKey[key];

  /// The known permissions among [keys]; unknown keys are ignored.
  static Set<AppPermission> parseAll(Iterable<String> keys) => {
    for (final key in keys) ?fromKey(key),
  };
}
