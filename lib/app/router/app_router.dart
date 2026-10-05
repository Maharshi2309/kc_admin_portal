import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/dev/component_gallery_screen.dart';
import 'package:kc_admin_portal/app/router/no_access_screen.dart';
import 'package:kc_admin_portal/app/router/not_found_screen.dart';
import 'package:kc_admin_portal/app/router/overlay_pages.dart';
import 'package:kc_admin_portal/app/router/route_guards.dart';
import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/router/splash_screen.dart';
import 'package:kc_admin_portal/app/shell/app_shell.dart';
import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/features/access_control/presentation/screens/access_control_screen.dart';
import 'package:kc_admin_portal/features/attendance/presentation/screens/attendance_correction_dialog.dart';
import 'package:kc_admin_portal/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/calendar/presentation/screens/calendar_day_sheet.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:kc_admin_portal/features/employees/presentation/screens/employee_form_screen.dart';
import 'package:kc_admin_portal/features/employees/presentation/screens/employee_profile_screen.dart';
import 'package:kc_admin_portal/features/employees/presentation/screens/employees_screen.dart';
import 'package:kc_admin_portal/features/employees/presentation/screens/schedule_change_dialog.dart';
import 'package:kc_admin_portal/features/holidays/presentation/screens/holiday_form_dialog.dart';
import 'package:kc_admin_portal/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:kc_admin_portal/features/leave/presentation/screens/leave_form_sheet.dart';
import 'package:kc_admin_portal/features/leave/presentation/screens/leave_screen.dart';
import 'package:kc_admin_portal/features/users/presentation/screens/user_access_screen.dart';
import 'package:kc_admin_portal/features/users/presentation/screens/user_form_dialog.dart';

/// All app routes. Signed-in sections live in one [StatefulShellRoute]
/// (branch order = `appNavDestinations` order). Dialog and side-sheet routes
/// use the root navigator so their backdrop covers the whole shell.
///
/// Access is decided by [authRedirect] from the auth state. The router is
/// created once; auth changes only re-run the redirect (via
/// `refreshListenable`), so navigation state is never lost.
final routerProvider = Provider<GoRouter>((ref) {
  final env = ref.watch(envProvider);
  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  final authState = ValueNotifier<AsyncValue<UserModel?>>(
    ref.read(authControllerProvider),
  );
  ref
    ..listen(authControllerProvider, (_, next) => authState.value = next)
    ..onDispose(authState.dispose);

  String idOf(GoRouterState state) => state.pathParameters[AppRouteParams.id]!;
  DateTime? dateOf(GoRouterState state) =>
      AppDateFormat.tryParseIso(state.pathParameters[AppRouteParams.date]);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutePaths.dashboard,
    debugLogDiagnostics: !env.isProduction,
    errorBuilder: (context, state) => const NotFoundScreen(),
    refreshListenable: authState,
    redirect: (context, state) {
      final auth = authState.value;
      final status = authStatusOf(auth);
      final grants = auth.value?.grants ?? const <AppPermission>{};
      final toAuth = authRedirect(
        status: status,
        location: state.uri,
        homeLocation: homeLocationFor(grants) ?? AppRoutePaths.noAccess,
        keepReturnPath: !ref
            .read(authControllerProvider.notifier)
            .signedOutByUser,
      );
      if (toAuth != null || status != AuthStatus.signedIn) return toAuth;
      // Pages the role doesn't allow: the backend would refuse their data.
      return permissionRedirect(
        routeName: state.topRoute?.name,
        location: state.uri,
        grants: grants,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutePaths.root,
        redirect: (context, state) => AppRoutePaths.dashboard,
      ),
      GoRoute(
        path: AppRoutePaths.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.noAccess,
        name: AppRouteNames.noAccess,
        builder: (context, state) => const NoAccessScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.dashboard,
                name: AppRouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.employees,
                name: AppRouteNames.employees,
                builder: (context, state) => EmployeesScreen(
                  initialSearch:
                      state.uri.queryParameters[AppRouteParams.search],
                ),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.add,
                    name: AppRouteNames.employeeAdd,
                    builder: (context, state) => const EmployeeFormScreen(),
                  ),
                  GoRoute(
                    path: AppRoutePaths.byId,
                    name: AppRouteNames.employeeProfile,
                    builder: (context, state) =>
                        EmployeeProfileScreen(employeeId: idOf(state)),
                    routes: [
                      GoRoute(
                        path: AppRoutePaths.edit,
                        name: AppRouteNames.employeeEdit,
                        builder: (context, state) =>
                            EmployeeFormScreen(employeeId: idOf(state)),
                      ),
                      GoRoute(
                        path: AppRoutePaths.calendarDay,
                        name: AppRouteNames.employeeCalendarDay,
                        parentNavigatorKey: rootNavigatorKey,
                        // An unreadable date goes back to the profile.
                        redirect: (context, state) => dateOf(state) == null
                            ? '${AppRoutePaths.employees}/${idOf(state)}'
                            : null,
                        pageBuilder: (context, state) => SideSheetPage<void>(
                          key: state.pageKey,
                          name: state.name,
                          child: CalendarDaySheet(
                            employeeId: idOf(state),
                            date: dateOf(state)!,
                          ),
                        ),
                        routes: [
                          GoRoute(
                            path: AppRoutePaths.dayAttendance,
                            name: AppRouteNames.calendarDayAttendance,
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) => DialogPage<void>(
                              key: state.pageKey,
                              name: state.name,
                              child: AttendanceCorrectionDialog(
                                employeeId: idOf(state),
                                date: dateOf(state),
                              ),
                            ),
                          ),
                          GoRoute(
                            path: AppRoutePaths.dayAttendanceRecord,
                            name: AppRouteNames.calendarDayAttendanceCorrect,
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) => DialogPage<void>(
                              key: state.pageKey,
                              name: state.name,
                              child: AttendanceCorrectionDialog(
                                recordId: state
                                    .pathParameters[AppRouteParams.recordId],
                              ),
                            ),
                          ),
                          GoRoute(
                            path: AppRoutePaths.dayLeaveNew,
                            name: AppRouteNames.calendarDayLeaveAdd,
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) =>
                                SideSheetPage<void>(
                                  key: state.pageKey,
                                  name: state.name,
                                  child: LeaveFormSheet(
                                    employeeId: idOf(state),
                                    initialDate: dateOf(state),
                                  ),
                                ),
                          ),
                          GoRoute(
                            path: AppRoutePaths.dayLeaveEdit,
                            name: AppRouteNames.calendarDayLeaveEdit,
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) =>
                                SideSheetPage<void>(
                                  key: state.pageKey,
                                  name: state.name,
                                  child: LeaveFormSheet(
                                    leaveId: state
                                        .pathParameters[AppRouteParams.leaveId],
                                  ),
                                ),
                          ),
                          GoRoute(
                            path: AppRoutePaths.dayHolidayNew,
                            name: AppRouteNames.calendarDayHolidayAdd,
                            parentNavigatorKey: rootNavigatorKey,
                            pageBuilder: (context, state) => DialogPage<void>(
                              key: state.pageKey,
                              name: state.name,
                              child: HolidayFormDialog(
                                initialDate: dateOf(state),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: AppRoutePaths.schedule,
                        name: AppRouteNames.employeeSchedule,
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) => DialogPage<void>(
                          key: state.pageKey,
                          name: state.name,
                          child: ScheduleChangeDialog(employeeId: idOf(state)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.attendance,
                name: AppRouteNames.attendance,
                builder: (context, state) => const AttendanceScreen(),
                routes: [
                  // Declared before `:id/edit` so "new" is not read as an id.
                  GoRoute(
                    path: AppRoutePaths.newRecord,
                    name: AppRouteNames.attendanceAdd,
                    parentNavigatorKey: rootNavigatorKey,
                    redirect: (context, state) {
                      final query = state.uri.queryParameters;
                      final valid =
                          query[AppRouteParams.employeeId] != null &&
                          AppDateFormat.tryParseIso(
                                query[AppRouteParams.date],
                              ) !=
                              null;
                      return valid ? null : AppRoutePaths.attendance;
                    },
                    pageBuilder: (context, state) {
                      final query = state.uri.queryParameters;
                      return DialogPage<void>(
                        key: state.pageKey,
                        name: state.name,
                        child: AttendanceCorrectionDialog(
                          employeeId: query[AppRouteParams.employeeId],
                          date: AppDateFormat.tryParseIso(
                            query[AppRouteParams.date],
                          ),
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: '${AppRoutePaths.byId}/${AppRoutePaths.edit}',
                    name: AppRouteNames.attendanceCorrect,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => DialogPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: AttendanceCorrectionDialog(recordId: idOf(state)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.leave,
                name: AppRouteNames.leave,
                builder: (context, state) => LeaveScreen(
                  view: LeaveView.fromQuery(
                    state.uri.queryParameters[AppRouteParams.view],
                  ),
                ),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.add,
                    name: AppRouteNames.leaveAdd,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => SideSheetPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: LeaveFormSheet(
                        employeeId: state
                            .uri
                            .queryParameters[AppRouteParams.employeeId],
                      ),
                    ),
                  ),
                  GoRoute(
                    path: '${AppRoutePaths.byId}/${AppRoutePaths.edit}',
                    name: AppRouteNames.leaveEdit,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => SideSheetPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: LeaveFormSheet(leaveId: idOf(state)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.holidays,
                name: AppRouteNames.holidays,
                builder: (context, state) => const HolidaysScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.add,
                    name: AppRouteNames.holidayAdd,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => DialogPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: const HolidayFormDialog(),
                    ),
                  ),
                  GoRoute(
                    path: '${AppRoutePaths.byId}/${AppRoutePaths.edit}',
                    name: AppRouteNames.holidayEdit,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => DialogPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: HolidayFormDialog(holidayId: idOf(state)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutePaths.accessControl,
                name: AppRouteNames.accessControl,
                builder: (context, state) => const AccessControlScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutePaths.newRecord,
                    name: AppRouteNames.userAdd,
                    parentNavigatorKey: rootNavigatorKey,
                    pageBuilder: (context, state) => DialogPage<void>(
                      key: state.pageKey,
                      name: state.name,
                      child: const UserFormDialog(),
                    ),
                  ),
                  GoRoute(
                    path: AppRoutePaths.byId,
                    name: AppRouteNames.userAccess,
                    builder: (context, state) =>
                        UserAccessScreen(userId: idOf(state)),
                    routes: [
                      GoRoute(
                        path: AppRoutePaths.edit,
                        name: AppRouteNames.userEdit,
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) => DialogPage<void>(
                          key: state.pageKey,
                          name: state.name,
                          child: UserFormDialog(userId: idOf(state)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      if (!env.isProduction)
        GoRoute(
          path: AppRoutePaths.devComponents,
          name: AppRouteNames.devComponents,
          builder: (context, state) => const ComponentGalleryScreen(),
        ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
