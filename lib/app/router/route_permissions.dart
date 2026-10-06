import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';

typedef _P = AppPermission;

/// What each signed-in route needs (all of the listed permissions). A child
/// route lists its parent's needs too, since the parent page is shown under
/// it. Routes not listed need only a session.
///
/// Mirrors the backend's endpoint permissions (API_CONTRACT §2), so a page
/// opens only when its data can be loaded.
const Map<String, List<AppPermission>> routePermissions = {
  AppRouteNames.dashboard: [_P.dashboardView],

  AppRouteNames.employees: [_P.employeeView],
  AppRouteNames.employeeAdd: [_P.employeeView, _P.employeeCreate],
  AppRouteNames.employeeImport: [_P.employeeView, _P.employeeCreate],
  AppRouteNames.employeeProfile: [_P.employeeView],
  AppRouteNames.employeeEdit: [_P.employeeView, _P.employeeEdit],
  AppRouteNames.employeeSchedule: [_P.employeeView, _P.scheduleEdit],
  AppRouteNames.employeeCalendarDay: [_P.employeeView, _P.calendarView],
  AppRouteNames.calendarDayAttendance: [
    _P.employeeView,
    _P.calendarView,
    _P.attendanceCorrect,
  ],
  AppRouteNames.calendarDayAttendanceCorrect: [
    _P.employeeView,
    _P.calendarView,
    _P.attendanceCorrect,
  ],
  AppRouteNames.calendarDayLeaveAdd: [
    _P.employeeView,
    _P.calendarView,
    _P.leaveCreate,
  ],
  AppRouteNames.calendarDayLeaveEdit: [
    _P.employeeView,
    _P.calendarView,
    _P.leaveEdit,
  ],
  AppRouteNames.calendarDayHolidayAdd: [
    _P.employeeView,
    _P.calendarView,
    _P.holidayCreate,
  ],

  AppRouteNames.attendance: [_P.attendanceView],
  AppRouteNames.attendanceCorrect: [_P.attendanceView, _P.attendanceCorrect],
  AppRouteNames.attendanceAdd: [_P.attendanceView, _P.attendanceCorrect],

  AppRouteNames.leave: [_P.leaveView],
  // The form's employee picker searches employees.
  AppRouteNames.leaveAdd: [_P.leaveView, _P.leaveCreate, _P.employeeView],
  AppRouteNames.leaveEdit: [_P.leaveView, _P.leaveEdit],

  AppRouteNames.holidays: [_P.holidayView],
  AppRouteNames.holidayAdd: [_P.holidayView, _P.holidayCreate],
  AppRouteNames.holidayEdit: [_P.holidayView, _P.holidayEdit],

  // Everything about users and their permissions needs this one.
  AppRouteNames.accessControl: [_P.permissionManage],
  AppRouteNames.settings: [_P.settingsManage],
  AppRouteNames.userAdd: [_P.permissionManage],
  AppRouteNames.userAccess: [_P.permissionManage],
  AppRouteNames.userEdit: [_P.permissionManage],
};

bool canOpenRoute(String? routeName, Set<AppPermission> grants) =>
    (routePermissions[routeName] ?? const []).every(grants.contains);

/// The start page of each section, in navigation order.
const List<(String name, String path)> _sectionStarts = [
  (AppRouteNames.dashboard, AppRoutePaths.dashboard),
  (AppRouteNames.employees, AppRoutePaths.employees),
  (AppRouteNames.attendance, AppRoutePaths.attendance),
  (AppRouteNames.leave, AppRoutePaths.leave),
  (AppRouteNames.holidays, AppRoutePaths.holidays),
  (AppRouteNames.accessControl, AppRoutePaths.accessControl),
  (AppRouteNames.settings, AppRoutePaths.settings),
];

/// Where a signed-in user lands: the first page they may open, or null when
/// their role opens nothing.
String? homeLocationFor(Set<AppPermission> grants) {
  for (final (name, path) in _sectionStarts) {
    if (canOpenRoute(name, grants)) return path;
  }
  return null;
}

/// Where to send a signed-in user who asked for [routeName] at [location],
/// or null if they may open it: the dashboard (the default start page)
/// falls back to the first page they may open; anything else goes to
/// "No access", keeping the address asked for.
String? permissionRedirect({
  required String? routeName,
  required Uri location,
  required Set<AppPermission> grants,
}) {
  if (location.path == AppRoutePaths.noAccess) return null;
  if (canOpenRoute(routeName, grants)) return null;
  if (routeName == AppRouteNames.dashboard) {
    final home = homeLocationFor(grants);
    if (home != null) return home;
  }
  return Uri(
    path: AppRoutePaths.noAccess,
    queryParameters: {AppRouteParams.from: location.toString()},
  ).toString();
}
