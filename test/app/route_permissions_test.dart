import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/shell/nav_destinations.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';

typedef _P = AppPermission;

String? _redirect(String? route, String location, Set<AppPermission> grants) =>
    permissionRedirect(
      routeName: route,
      location: Uri.parse(location),
      grants: grants,
    );

void main() {
  const supervisor = {
    _P.dashboardView,
    _P.employeeView,
    _P.attendanceView,
    _P.attendancePunch,
    _P.attendanceCorrect,
    _P.leaveView,
    _P.calendarView,
    _P.holidayView,
  };

  test('child routes need their parent page too', () {
    expect(canOpenRoute(AppRouteNames.holidayAdd, {_P.holidayCreate}), false);
    expect(
      canOpenRoute(AppRouteNames.holidayAdd, {
        _P.holidayView,
        _P.holidayCreate,
      }),
      true,
    );
    // Routes not listed only need a session.
    expect(canOpenRoute(AppRouteNames.login, const {}), true);
  });

  test('every signed-in section route is in the table', () {
    for (final name in [
      AppRouteNames.dashboard,
      AppRouteNames.employees,
      AppRouteNames.attendance,
      AppRouteNames.leave,
      AppRouteNames.holidays,
      AppRouteNames.accessControl,
      AppRouteNames.userAccess,
    ]) {
      expect(routePermissions, contains(name));
    }
  });

  test('sections shown follow the role', () {
    expect(visibleBranches(supervisor), [0, 1, 2, 3, 4]);
    expect(visibleBranches({_P.holidayView, _P.permissionManage}), [4, 5]);
    expect(visibleBranches(const {}), isEmpty);
  });

  test('home is the first page the role may open', () {
    expect(homeLocationFor(supervisor), AppRoutePaths.dashboard);
    expect(homeLocationFor({_P.holidayView}), AppRoutePaths.holidays);
    expect(homeLocationFor({_P.permissionManage}), AppRoutePaths.accessControl);
    expect(homeLocationFor(const {}), isNull);
  });

  test('redirects', () {
    expect(_redirect(AppRouteNames.holidays, '/holidays', supervisor), isNull);
    expect(
      _redirect(AppRouteNames.holidayAdd, '/holidays/add', supervisor),
      '/no-access?from=%2Fholidays%2Fadd',
    );
    // The default start page falls back to a page the role can open.
    expect(
      _redirect(AppRouteNames.dashboard, '/dashboard', {_P.holidayView}),
      AppRoutePaths.holidays,
    );
    // Anything else is "No access", not a silent redirect.
    expect(
      _redirect(AppRouteNames.accessControl, '/access-control', supervisor),
      startsWith(AppRoutePaths.noAccess),
    );
    expect(_redirect(null, '/no-access', const {}), isNull);
  });
}
