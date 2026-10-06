import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// Profile header (design board 05): identity, status, actions and contact
/// details.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.employee,
    required this.today,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onAddLeave,
    this.isChangingStatus = false,
    super.key,
  });

  final EmployeeModel employee;
  final DateTime today;

  /// Each action is hidden when null (the role doesn't allow it).
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onAddLeave;
  final bool isChangingStatus;

  static const double _detailMinWidth = 180;

  @override
  Widget build(BuildContext context) {
    final isActive = employee.status == EmployeeStatus.active;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s20,
        children: [
          Wrap(
            spacing: AppSpacing.s20,
            runSpacing: AppSpacing.s16,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _Identity(employee: employee),
              Wrap(
                spacing: AppSpacing.s10,
                runSpacing: AppSpacing.s8,
                children: [
                  if (onToggleStatus != null)
                    AppButton(
                      label: isActive ? 'Deactivate' : 'Reactivate',
                      variant: isActive
                          ? AppButtonVariant.danger
                          : AppButtonVariant.secondary,
                      isLoading: isChangingStatus,
                      onPressed: onToggleStatus,
                    ),
                  if (onEdit != null)
                    AppButton(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      variant: AppButtonVariant.secondary,
                      onPressed: onEdit,
                    ),
                  if (isActive && onAddLeave != null)
                    AppButton(
                      label: 'Add leave',
                      icon: Icons.event_available_outlined,
                      onPressed: onAddLeave,
                    ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.divider),
          ResponsiveGrid(
            minItemWidth: _detailMinWidth,
            equalHeight: false,
            children: [
              _Detail(
                label: 'Mobile',
                value: FormatUtils.mobile(employee.mobile),
              ),
              _Detail(
                label: 'Joined',
                value:
                    '${AppDateFormat.medium(employee.joiningDate)} · '
                    '${FormatUtils.tenure(employee.joiningDate, today)}',
              ),
              if (employee.overtimeMinutesThisYear != null)
                _Detail(
                  label: 'Overtime this year',
                  value: DurationFormat.full(employee.overtimeMinutesThisYear!),
                ),
              if (employee.updatedAt != null)
                _Detail(
                  label: 'Last updated',
                  value: [
                    AppDateFormat.medium(employee.updatedAt!),
                    if (employee.updatedBy != null) 'by ${employee.updatedBy}',
                  ].join(' · '),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s18,
      children: [
        AppAvatar(name: employee.name, size: AppSizes.avatarXLarge),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s6,
            children: [
              Wrap(
                spacing: AppSpacing.s10,
                runSpacing: AppSpacing.s6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      employee.name,
                      style: AppTextStyles.headingMedium,
                    ),
                  ),
                  EmployeeStatusBadge(employee.status),
                  if (employee.todayStatus != null)
                    AttendanceStatusBadge(employee.todayStatus!),
                ],
              ),
              Wrap(
                spacing: AppSpacing.s10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  EcNumberText(employee.ecNumber, large: true, copyable: true),
                  Text(
                    '${employee.position.name} · ${employee.department.name}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s4,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
