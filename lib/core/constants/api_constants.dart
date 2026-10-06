/// REST API contract assumptions.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: everything in this file is an
/// assumption until the Next.js backend publishes its API contract.
/// Changing an assumption should only require editing this file (and, for
/// payload shapes, the matching model).
///
/// - Responses are plain JSON (no `{ "data": ... }` envelope).
/// - Errors look like `{ "message": "...", "errors": { "field": "..." } }`.
/// - Authentication uses `Authorization: Bearer <accessToken>`.
abstract final class ApiConstants {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Dashboard endpoints
  /// `?date=YYYY-MM-DD` → DashboardSummaryModel.
  static const String dashboardSummary = '/dashboard/summary';

  /// `?month=YYYY-MM` → MonthlyAttendanceModel.
  static const String dashboardAttendanceChart = '/dashboard/attendance-chart';

  // Master data
  /// `GET` → `List<ListEntry>`. `POST { name, code? }` adds one.
  static const String departments = '/departments';

  /// `GET` → `List<ListEntry>`. `POST { name, code? }` adds one.
  static const String positions = '/positions';

  // Employees
  /// `?search&department&position&status&page&pageSize` → page of
  /// employees. `POST` creates one.
  static const String employees = '/employees';

  /// `{ "ecNumber": "KC1129" }`: suggested next EC number (editable).
  static const String nextEcNumber = '/employees/next-ec-number';
  static String employee(String id) => '/employees/$id';

  /// `PATCH { "status": "inactive" }`. Employees are never deleted.
  static String employeeStatus(String id) => '/employees/$id/status';

  static String employeeLeaveBalance(String id) =>
      '/employees/$id/leave-balance';
  static String employeeLeaves(String id) => '/employees/$id/leaves';

  // Attendance
  /// `?date&status&search&department&page&pageSize` → AttendanceDayModel.
  /// `POST` adds a missing record.
  static const String attendance = '/attendance';
  static String attendanceRecord(String id) => '/attendance/$id';

  /// `{ "employeeId": "..." }`; the server records the current time.
  static const String punchIn = '/attendance/punch-in';
  static const String punchOut = '/attendance/punch-out';

  /// `{ "date": "YYYY-MM-DD" }` → `{ "count": 11 }`: punches in everyone
  /// not punched in yet.
  static const String punchInAll = '/attendance/punch-in/bulk';

  /// `?month=YYYY-MM` → list of AttendanceRecordModel.
  static String employeeAttendanceLog(String id) =>
      '/employees/$id/attendance-log';

  // Leave
  /// `?status&search&from&to&leaveTypeId&department&page&pageSize` →
  /// LeaveListModel. `POST` adds a leave.
  static const String leaves = '/leaves';
  static String leave(String id) => '/leaves/$id';

  /// `PATCH { "status": "approved" | "rejected" | "cancelled" }`.
  /// Leave is never deleted; cancelled leave stays in history.
  static String leaveStatus(String id) => '/leaves/$id/status';
  static const String leaveTypes = '/leave-types';

  /// `POST` LeavePreviewRequest → LeavePreviewModel (days, balance).
  static const String leavePreview = '/leaves/preview';

  /// Every active employee's Casual balance, paged (added 2026-10-05).
  static const String leaveBalances = '/leave-balances';

  /// `?month=YYYY-MM&employeeId=…` → LeaveCalendarModel (company holidays
  /// and that employee's weekly offs).
  static const String leaveCalendar = '/leave-calendar';

  // Working schedules (versions by effective date)
  /// `GET` → history, newest first. `POST` WorkScheduleInput → new version.
  static String employeeSchedules(String id) => '/employees/$id/schedules';

  // Overtime
  /// `?from=YYYY-MM-DD&to=YYYY-MM-DD` → OvertimeReportModel.
  static String employeeOvertime(String id) => '/employees/$id/overtime';

  // Employee calendar
  /// `?month=YYYY-MM` → EmployeeCalendarModel.
  static String employeeCalendar(String id) => '/employees/$id/calendar';

  /// → CalendarDayDetailModel (the day plus its change history).
  static String employeeCalendarDay(String id, String date) =>
      '/employees/$id/calendar/$date';

  // Company holidays
  /// `?year=YYYY&search=` → list. `POST` HolidayInput.
  static const String holidays = '/holidays';

  /// `GET`, `PATCH` HolidayInput, `DELETE`.
  static String holiday(String id) => '/holidays/$id';

  // Permissions
  /// `GET` → the permission catalogue grouped by module.
  static const String permissions = '/permissions';

  // Staff users
  /// `?search&page&pageSize` → UserAccountListModel. `POST`
  /// UserAccountInput.
  static const String users = '/users';

  /// `GET`, `PATCH` UserAccountUpdate (`employeeId: null` unlinks).
  static String user(String id) => '/users/$id';

  /// `PUT { "permissions": [keys] }` replaces the user's permissions.
  static String userPermissions(String id) => '/users/$id/permissions';

  // Audit
  /// `?employeeId&date&from&to&entityType&page&pageSize`.
  static const String auditLogs = '/audit-logs';

  // Request / response keys
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  /// Keys checked (in order) for a human-readable error message.
  static const List<String> errorMessageKeys = ['message', 'error'];

  /// Key holding a machine-readable error code, e.g. `LEAVE_NOT_EDITABLE`.
  static const String errorCodeKey = 'code';

  /// 403: the signed-in user lacks the endpoint's permission.
  static const String permissionDeniedCode = 'PERMISSION_DENIED';

  /// 422: Casual leave beyond the available balance (or using a future
  /// month's day). Resend with `splitExcessAsUnpaid: true` to save the
  /// extra days as Unpaid leave.
  static const String insufficientLeaveBalanceCode =
      'INSUFFICIENT_LEAVE_BALANCE';

  /// 409 when editing leave that is no longer pending.
  static const String leaveNotEditableCode = 'LEAVE_NOT_EDITABLE';

  /// 409: the change would leave nobody able to manage permissions.
  static const String lastPermissionManagerCode = 'LAST_PERMISSION_MANAGER';

  /// 409: users can't remove their own access or deactivate themselves.
  static const String cannotChangeOwnAccessCode = 'CANNOT_CHANGE_OWN_ACCESS';

  /// Key holding per-field validation errors: `{ field: "msg" | ["msg"] }`.
  static const String fieldErrorsKey = 'errors';

  /// Requests to these paths never trigger "session expired" on 401
  /// (a 401 from login just means wrong credentials).
  static const List<String> unauthenticatedPaths = [login];
}
