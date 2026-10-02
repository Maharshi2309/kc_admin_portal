import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';

/// DEV ONLY: the backend's permission catalogue (`GET /permissions`), as in
/// `docs/api-examples/permissions.response.json`. Contract tests keep the two
/// in step.
const List<PermissionModuleModel> mockPermissionCatalogue = [
  PermissionModuleModel(
    module: 'dashboard',
    label: 'Dashboard',
    permissions: [
      PermissionModel(
        key: 'dashboard.view',
        action: 'view',
        label: 'View dashboard',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'employee',
    label: 'Employees',
    permissions: [
      PermissionModel(
        key: 'employee.view',
        action: 'view',
        label: 'View employees',
      ),
      PermissionModel(
        key: 'employee.create',
        action: 'create',
        label: 'Add employees',
      ),
      PermissionModel(
        key: 'employee.edit',
        action: 'edit',
        label: 'Edit employees',
      ),
      PermissionModel(
        key: 'employee.deactivate',
        action: 'deactivate',
        label: 'Deactivate employees',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'schedule',
    label: 'Working schedules',
    permissions: [
      PermissionModel(
        key: 'schedule.edit',
        action: 'edit',
        label: 'Change schedules',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'attendance',
    label: 'Attendance',
    permissions: [
      PermissionModel(
        key: 'attendance.view',
        action: 'view',
        label: 'View attendance',
      ),
      PermissionModel(
        key: 'attendance.punch',
        action: 'punch',
        label: 'Punch in and out',
      ),
      PermissionModel(
        key: 'attendance.correct',
        action: 'correct',
        label: 'Correct attendance',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'overtime',
    label: 'Overtime',
    permissions: [
      PermissionModel(
        key: 'overtime.view',
        action: 'view',
        label: 'View overtime',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'leave',
    label: 'Leave',
    permissions: [
      PermissionModel(key: 'leave.view', action: 'view', label: 'View leave'),
      PermissionModel(
        key: 'leave.create',
        action: 'create',
        label: 'Add leave',
      ),
      PermissionModel(
        key: 'leave.edit',
        action: 'edit',
        label: 'Edit pending leave',
      ),
      PermissionModel(
        key: 'leave.cancel',
        action: 'cancel',
        label: 'Cancel leave',
      ),
      PermissionModel(
        key: 'leave.approve',
        action: 'approve',
        label: 'Approve and reject',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'calendar',
    label: 'Employee calendar',
    permissions: [
      PermissionModel(
        key: 'calendar.view',
        action: 'view',
        label: 'View calendars',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'holiday',
    label: 'Holidays',
    permissions: [
      PermissionModel(
        key: 'holiday.view',
        action: 'view',
        label: 'View holidays',
      ),
      PermissionModel(
        key: 'holiday.create',
        action: 'create',
        label: 'Add holidays',
      ),
      PermissionModel(
        key: 'holiday.edit',
        action: 'edit',
        label: 'Edit holidays',
      ),
      PermissionModel(
        key: 'holiday.delete',
        action: 'delete',
        label: 'Delete holidays',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'permission',
    label: 'Users & permissions',
    permissions: [
      PermissionModel(
        key: 'permission.manage',
        action: 'manage',
        label: 'Manage users and permissions',
        description:
            'Add and edit staff users, and choose what each one can do',
      ),
    ],
  ),
  PermissionModuleModel(
    module: 'audit',
    label: 'Change history',
    permissions: [
      PermissionModel(
        key: 'audit.view',
        action: 'view',
        label: 'View change history',
      ),
    ],
  ),
];
