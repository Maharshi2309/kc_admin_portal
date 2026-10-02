import 'package:flutter/material.dart';

import 'package:kc_admin_portal/core/permissions/app_permission.dart';

class AppNavDestination {
  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.requires,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// The section is shown only to people with all of these.
  final List<AppPermission> requires;

  bool isVisibleTo(Set<AppPermission> grants) =>
      requires.every(grants.contains);
}

/// The branch indexes of the sections [grants] may open, in order.
List<int> visibleBranches(Set<AppPermission> grants) => [
  for (var i = 0; i < appNavDestinations.length; i++)
    if (appNavDestinations[i].isVisibleTo(grants)) i,
];

/// The single list of top-level sections. Its order must match the branch
/// order of the shell route in `app_router.dart`; the sidebar, navigation
/// rail and bottom bar are all built from it.
const List<AppNavDestination> appNavDestinations = [
  AppNavDestination(
    label: 'Dashboard',
    requires: [AppPermission.dashboardView],
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view_rounded,
  ),
  AppNavDestination(
    label: 'Employees',
    requires: [AppPermission.employeeView],
    icon: Icons.group_outlined,
    selectedIcon: Icons.group_rounded,
  ),
  AppNavDestination(
    label: 'Attendance',
    requires: [AppPermission.attendanceView],
    icon: Icons.schedule_outlined,
    selectedIcon: Icons.watch_later_rounded,
  ),
  AppNavDestination(
    label: 'Leaves',
    requires: [AppPermission.leaveView],
    icon: Icons.calendar_month_outlined,
    selectedIcon: Icons.calendar_month_rounded,
  ),
  AppNavDestination(
    label: 'Holidays',
    requires: [AppPermission.holidayView],
    icon: Icons.event_available_outlined,
    selectedIcon: Icons.event_available_rounded,
  ),
  AppNavDestination(
    label: 'Access control',
    requires: [AppPermission.permissionManage],
    icon: Icons.admin_panel_settings_outlined,
    selectedIcon: Icons.admin_panel_settings_rounded,
  ),
];
