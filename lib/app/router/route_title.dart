import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/core/constants/app_constants.dart';

/// Page names for the browser tab and the app switcher, as in the design
/// ("Employees · Keshav Admin"). Dialogs and side sheets are routes too, so
/// the title follows them and returns when they close.
const Map<String, String> routeTitles = {
  AppRouteNames.login: 'Sign in',
  AppRouteNames.noAccess: 'No access',
  AppRouteNames.register: 'Create an account',
  AppRouteNames.verifyEmail: 'Verify your email',
  AppRouteNames.forgotPassword: 'Forgot password',
  AppRouteNames.resetPassword: 'New password',
  AppRouteNames.welcome: 'Welcome',
  AppRouteNames.createOrganization: 'Create organization',
  AppRouteNames.dashboard: 'Dashboard',
  AppRouteNames.employees: 'Employees',
  AppRouteNames.employeeAdd: 'Add employee',
  AppRouteNames.employeeImport: 'Import employees',
  AppRouteNames.employeeProfile: 'Employee profile',
  AppRouteNames.employeeEdit: 'Edit employee',
  AppRouteNames.employeeSchedule: 'Change schedule',
  AppRouteNames.employeeCalendarDay: 'Day details',
  AppRouteNames.calendarDayAttendance: 'Add attendance',
  AppRouteNames.calendarDayAttendanceCorrect: 'Correct attendance',
  AppRouteNames.calendarDayLeaveAdd: 'Add leave',
  AppRouteNames.calendarDayLeaveEdit: 'Edit leave',
  AppRouteNames.calendarDayHolidayAdd: 'Add holiday',
  AppRouteNames.attendance: 'Attendance',
  AppRouteNames.attendanceCorrect: 'Correct attendance',
  AppRouteNames.attendanceAdd: 'Add attendance',
  AppRouteNames.leave: 'Leaves',
  AppRouteNames.leaveAdd: 'Add leave',
  AppRouteNames.leaveEdit: 'Edit leave',
  AppRouteNames.holidays: 'Holidays',
  AppRouteNames.holidayAdd: 'Add holiday',
  AppRouteNames.holidayEdit: 'Edit holiday',
  AppRouteNames.accessControl: 'Access control',
  AppRouteNames.settings: 'Settings',
  AppRouteNames.userAccess: 'User permissions',
  AppRouteNames.userAdd: 'Add user',
  AppRouteNames.userEdit: 'Edit user',
  AppRouteNames.devComponents: 'Components',
};

const String notFoundTitle = 'Page not found';

/// The full title for [configuration]: "Employees · Keshav Admin", or just the
/// app name when the route has no page name (splash).
String titleFor(RouteMatchList configuration) {
  if (configuration.isError) return _withApp(notFoundTitle);
  final route = configuration.lastOrNull?.route;
  final page = route is GoRoute ? routeTitles[route.name] : null;
  return page == null ? AppConstants.appName : _withApp(page);
}

String _withApp(String page) => '$page · ${AppConstants.appShortName}';

/// Keeps the window title in step with the current route. Sits in
/// `MaterialApp.router`'s builder, below the app's own [Title], so it wins.
class RouteTitle extends StatefulWidget {
  const RouteTitle({required this.router, required this.child, super.key});

  final GoRouter router;
  final Widget child;

  @override
  State<RouteTitle> createState() => _RouteTitleState();
}

class _RouteTitleState extends State<RouteTitle> {
  late String _title = _current();

  String _current() =>
      titleFor(widget.router.routerDelegate.currentConfiguration);

  void _update() {
    // A router that replaces another (after switching organization) sets
    // its first page while the app is building: wait for the frame.
    final scheduler = SchedulerBinding.instance;
    if (scheduler.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      scheduler.addPostFrameCallback((_) => _update());
      return;
    }
    final title = _current();
    if (title != _title && mounted) setState(() => _title = title);
  }

  @override
  void initState() {
    super.initState();
    widget.router.routerDelegate.addListener(_update);
  }

  @override
  void didUpdateWidget(RouteTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.router != widget.router) {
      oldWidget.router.routerDelegate.removeListener(_update);
      widget.router.routerDelegate.addListener(_update);
      _title = _current();
    }
  }

  @override
  void dispose() {
    widget.router.routerDelegate.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Title(title: _title, color: AppColors.primary, child: widget.child);
}
