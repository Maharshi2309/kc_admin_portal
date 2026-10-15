import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_status_action.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// Employee rows: a table on wide screens (columns drop by priority as it
/// narrows), a compact list on phones. Rows open the profile.
class EmployeeTable extends ConsumerWidget {
  const EmployeeTable({required this.employees, super.key});

  final List<EmployeeModel> employees;

  /// Width of the three row-action buttons plus gaps and cell padding. On
  /// touch platforms each button has a 48 px tap target; with a mouse it is
  /// the visual 32 px.
  static const int _actionCount = 3;

  static double _actionsWidth(BuildContext context) {
    final button =
        Theme.of(context).materialTapTargetSize == MaterialTapTargetSize.padded
        ? kMinInteractiveDimension
        : AppSizes.iconButtonGhost;
    return _actionCount * button +
        (_actionCount - 1) * AppSpacing.s2 +
        2 * AppSpacing.s16;
  }

  void _openProfile(BuildContext context, EmployeeModel employee) =>
      context.goNamed(
        AppRouteNames.employeeProfile,
        pathParameters: {AppRouteParams.id: employee.id},
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneCountry = ref.watch(defaultPhoneCountryProvider);
    final muted = AppTextStyles.body.copyWith(color: AppColors.textSecondary);
    // The server sends overtime only to people who may see it.
    final showOvertime = ref.can(AppPermission.overtimeView);

    return ResponsiveDataView<EmployeeModel>(
      rows: employees,
      rowKey: (employee) => employee.id,
      onRowTap: (employee) => _openProfile(context, employee),
      mobileItemBuilder: (context, employee) => _MobileItem(employee: employee),
      columns: [
        AppDataColumn(
          label: 'Employee',
          flex: 3,
          minWidth: 210,
          cellBuilder: (context, e) => _NameCell(employee: e),
        ),
        AppDataColumn(
          label: 'EC number',
          minWidth: 110,
          cellBuilder: (context, e) => EcNumberText(e.ecNumber),
        ),
        // One two-line column keeps room for overtime on laptops.
        AppDataColumn(
          label: 'Dept / Position',
          minWidth: 180,
          priority: 1,
          cellBuilder: (context, e) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s2,
            children: [
              Text(
                e.department.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body,
              ),
              Text(
                e.position.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        AppDataColumn(
          label: 'Mobile',
          minWidth: 150,
          priority: 5,
          cellBuilder: (context, e) => Text(
            PhoneUtils.format(e.mobile, country: phoneCountry),
            style: muted,
          ),
        ),
        if (showOvertime)
          AppDataColumn(
            label: 'Overtime this year',
            minWidth: 180,
            priority: 2,
            cellBuilder: (context, e) => Text(
              e.overtimeMinutesThisYear == null
                  ? '—'
                  : DurationFormat.full(e.overtimeMinutesThisYear!),
              style: muted,
            ),
          ),
        AppDataColumn(
          label: 'Today',
          minWidth: 130,
          priority: 3,
          cellBuilder: (context, e) => e.todayStatus == null
              ? Text('—', style: muted)
              : AttendanceStatusBadge(e.todayStatus!),
        ),
        AppDataColumn(
          label: 'Status',
          minWidth: 100,
          cellBuilder: (context, e) => EmployeeStatusBadge(e.status),
        ),
        AppDataColumn(
          label: '',
          fixedWidth: _actionsWidth(context),
          alignment: AlignmentDirectional.centerEnd,
          cellBuilder: (context, e) => _RowActions(employee: e),
        ),
      ],
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        AppAvatar(name: employee.name),
        Expanded(
          child: Text(
            employee.name,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySemibold,
          ),
        ),
      ],
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.s12,
      children: [
        AppAvatar(name: employee.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(
                employee.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySemibold,
              ),
              Text(
                '${employee.ecNumber} · ${employee.department.name}',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              if (employee.overtimeMinutesThisYear != null)
                Text(
                  'Overtime this year: '
                  '${DurationFormat.full(employee.overtimeMinutesThisYear!)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        EmployeeStatusBadge(employee.status),
      ],
    );
  }
}

class _RowActions extends ConsumerWidget {
  const _RowActions({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = employee.status == EmployeeStatus.active;
    final id = {AppRouteParams.id: employee.id};
    final canEdit = ref.can(AppPermission.employeeEdit);
    final canChangeStatus = ref.can(AppPermission.employeeDeactivate);

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        AppIconButton(
          icon: Icons.visibility_outlined,
          tooltip: 'View ${employee.name}',
          onPressed: () => context.goNamed(
            AppRouteNames.employeeProfile,
            pathParameters: id,
          ),
        ),
        if (canEdit)
          AppIconButton(
            icon: Icons.edit_outlined,
            tooltip: 'Edit ${employee.name}',
            onPressed: () =>
                context.goNamed(AppRouteNames.employeeEdit, pathParameters: id),
          ),
        if (canChangeStatus)
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                leadingIcon: Icon(
                  isActive
                      ? Icons.person_off_outlined
                      : Icons.person_add_alt_outlined,
                  size: AppSizes.icon,
                ),
                onPressed: () => toggleEmployeeStatus(context, ref, employee),
                child: Text(isActive ? 'Deactivate' : 'Reactivate'),
              ),
            ],
            builder: (context, controller, _) => AppIconButton(
              icon: Icons.more_vert_rounded,
              tooltip: 'More actions for ${employee.name}',
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          ),
      ],
    );
  }
}
