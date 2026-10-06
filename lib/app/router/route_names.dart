/// Route names used with `context.goNamed(...)`. Always navigate by name so
/// paths can change in one place ([AppRoutePaths]).
abstract final class AppRouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String noAccess = 'no-access';

  // Sign-up and onboarding (2026-10-06)
  static const String register = 'register';
  static const String verifyEmail = 'verify-email';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String welcome = 'welcome';
  static const String createOrganization = 'create-organization';
  static const String dashboard = 'dashboard';

  static const String employees = 'employees';
  static const String employeeAdd = 'employee-add';

  /// `/employees/import`: employees from an Excel file (2026-10-06).
  static const String employeeImport = 'employee-import';
  static const String employeeProfile = 'employee-profile';
  static const String employeeEdit = 'employee-edit';
  static const String employeeSchedule = 'employee-schedule';

  /// A day of an employee's calendar, and what can be done from it.
  static const String employeeCalendarDay = 'employee-calendar-day';
  static const String calendarDayAttendance = 'calendar-day-attendance';
  static const String calendarDayAttendanceCorrect =
      'calendar-day-attendance-correct';
  static const String calendarDayLeaveAdd = 'calendar-day-leave-add';
  static const String calendarDayLeaveEdit = 'calendar-day-leave-edit';
  static const String calendarDayHolidayAdd = 'calendar-day-holiday-add';

  static const String attendance = 'attendance';
  static const String attendanceCorrect = 'attendance-correct';
  static const String attendanceAdd = 'attendance-add';

  static const String leave = 'leave';
  static const String leaveAdd = 'leave-add';
  static const String leaveEdit = 'leave-edit';

  static const String holidays = 'holidays';
  static const String holidayAdd = 'holiday-add';
  static const String holidayEdit = 'holiday-edit';

  /// Access control: the staff users; each user's page sets their
  /// permissions.
  static const String accessControl = 'access-control';
  static const String settings = 'settings';
  static const String userAccess = 'user-access';
  static const String userAdd = 'user-add';
  static const String userEdit = 'user-edit';

  static const String devComponents = 'dev-components';
}

/// Path segments. Child routes are relative to their parent.
abstract final class AppRoutePaths {
  static const String root = '/';
  static const String splash = '/splash';
  static const String login = '/login';

  /// Public: create an account, verify its email (`?email=`), and reset a
  /// forgotten password (`/reset-password?email=`).
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  /// Signed in but in no organization yet: create one, or join by
  /// invitation. Every other page sends such users here.
  static const String welcome = '/welcome';

  /// Any signed-in user can create (another) organization.
  static const String createOrganization = '/create-organization';

  /// Shown when the signed-in user's role doesn't allow the page asked for
  /// (`?from=` keeps that address).
  static const String noAccess = '/no-access';
  static const String dashboard = '/dashboard';

  static const String employees = '/employees';
  static const String add = 'add';
  static const String import = 'import';

  /// Adding a missing attendance record: `/attendance/new?employeeId&date`.
  static const String newRecord = 'new';
  static const String byId = ':id';
  static const String edit = 'edit';
  static const String schedule = 'schedule';

  /// `/employees/:id/calendar/:date` and its dialogs. Opened from the
  /// profile, so the app stays in the Employees section.
  static const String calendarDay = 'calendar/:date';
  static const String dayAttendance = 'attendance';
  static const String dayAttendanceRecord = 'attendance/:recordId';
  static const String dayLeaveNew = 'leave/new';
  static const String dayLeaveEdit = 'leave/:leaveId';
  static const String dayHolidayNew = 'holiday/new';

  static const String attendance = '/attendance';
  static const String leave = '/leave';
  static const String holidays = '/holidays';

  /// Access control: `/access-control` (users), `/access-control/new`,
  /// `/access-control/:id` (a user's permissions) and its `edit` dialog.
  static const String accessControl = '/access-control';

  /// The organization's settings (2026-10-06).
  static const String settings = '/settings';

  static const String devComponents = '/dev/components';
}

/// Path and query parameter keys.
abstract final class AppRouteParams {
  static const String id = 'id';

  /// Employee search text, e.g. `/employees?search=KC1001` from the header.
  static const String search = 'search';

  /// Pre-selects an employee, e.g. `/leave/add?employeeId=42` from a profile.
  static const String employeeId = 'employeeId';

  /// The Leave page's tab: `/leave?view=balances` (Requests otherwise).
  static const String view = 'view';

  /// A calendar date, `YYYY-MM-DD`.
  static const String date = 'date';

  /// Page to open after signing in, e.g. `/login?from=/employees/42`.
  static const String from = 'from';

  /// The email on the verification and password reset pages.
  static const String email = 'email';

  /// A leave id in a calendar day's path.
  static const String leaveId = 'leaveId';

  /// The attendance record to correct, e.g. `…/attendance/a-1`.
  static const String recordId = 'recordId';
}
