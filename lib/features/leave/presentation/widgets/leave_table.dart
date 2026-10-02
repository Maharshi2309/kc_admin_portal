import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/widgets/status_badges.dart';

/// Leave rows (design board 08): pending requests show Approve / Reject;
/// active leave can be edited or cancelled. Nothing is ever deleted.
class LeaveTable extends ConsumerWidget {
  const LeaveTable({required this.leaves, super.key});

  final List<LeaveModel> leaves;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = AppTextStyles.body.copyWith(color: AppColors.textSecondary);

    return ResponsiveDataView<LeaveModel>(
      rows: leaves,
      rowKey: (leave) => leave.id,
      mobileItemBuilder: (context, leave) => _MobileItem(leave: leave),
      columns: [
        AppDataColumn(
          label: 'Employee',
          flex: 2,
          // Avatar + the longest sample names; leaves room for "Added by".
          minWidth: 180,
          cellBuilder: (context, l) => _EmployeeCell(leave: l),
        ),
        AppDataColumn(
          label: 'EC number',
          minWidth: 110,
          priority: 2,
          cellBuilder: (context, l) => EcNumberText(l.employee.ecNumber),
        ),
        AppDataColumn(
          label: 'Type',
          minWidth: 84,
          cellBuilder: (context, l) => Text(l.leaveType.name),
        ),
        AppDataColumn(
          label: 'Dates',
          flex: 2,
          minWidth: 155,
          cellBuilder: (context, l) => Text(
            AppDateFormat.range(l.startDate, l.endDate),
            style: AppTextStyles.bodySemibold,
          ),
        ),
        AppDataColumn(
          label: 'Days',
          minWidth: 70,
          priority: 1,
          cellBuilder: (context, l) => Text(FormatUtils.count(l.days)),
        ),
        AppDataColumn(
          label: 'Reason',
          flex: 2,
          minWidth: 170,
          priority: 4,
          cellBuilder: (context, l) => Text(
            _reasonText(l),
            overflow: TextOverflow.ellipsis,
            style: muted,
          ),
        ),
        AppDataColumn(
          label: 'Status',
          minWidth: 130,
          cellBuilder: (context, l) => LeaveStatusBadge(l.status),
        ),
        AppDataColumn(
          label: 'Added by',
          // Fits "Employee request" on one line.
          minWidth: 160,
          priority: 3,
          cellBuilder: (context, l) => Text(
            l.addedBy ?? '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: muted,
          ),
        ),
        AppDataColumn(
          label: 'Action',
          // Approve, Reject and the menu on one line; touch-size buttons
          // need more room (then "Added by" gives way first).
          minWidth: context.usesTouchInput ? 260 : 232,
          alignment: AlignmentDirectional.centerEnd,
          cellBuilder: (context, l) => LeaveRowActions(leave: l),
        ),
      ],
    );
  }

  static String _reasonText(LeaveModel leave) =>
      [leave.reason.label, ?leave.remarks].join(' · ');
}

class _EmployeeCell extends ConsumerWidget {
  const _EmployeeCell({required this.leave});

  final LeaveModel leave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canOpen = ref.can(AppPermission.employeeView);
    return Row(
      spacing: AppSpacing.s10,
      children: [
        AppAvatar(name: leave.employee.name, size: AppSizes.avatarSmall),
        Expanded(
          child: InkWell(
            onTap: canOpen
                ? () => context.goNamed(
                    AppRouteNames.employeeProfile,
                    pathParameters: {AppRouteParams.id: leave.employee.id},
                  )
                : null,
            child: Text(
              leave.employee.name,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySemibold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Approve / Reject, edit and cancel for pending leave; cancel for approved
/// leave. Only pending leave can be edited.
class LeaveRowActions extends ConsumerWidget {
  const LeaveRowActions({required this.leave, super.key});

  final LeaveModel leave;

  Future<void> _setStatus(
    BuildContext context,
    WidgetRef ref,
    LeaveStatus status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final name = leave.employee.name;
    final dates = AppDateFormat.range(leave.startDate, leave.endDate);

    if (status != LeaveStatus.approved) {
      final rejecting = status == LeaveStatus.rejected;
      final confirmed = await showAppConfirmDialog(
        context,
        title: rejecting ? 'Reject this leave?' : 'Cancel this leave?',
        message:
            '$name · ${leave.leaveType.name} · $dates. '
            'It stays in the leave history as '
            '${rejecting ? 'rejected' : 'cancelled'}.',
        confirmLabel: rejecting ? 'Reject leave' : 'Cancel leave',
        cancelLabel: 'Keep',
        isDestructive: true,
      );
      if (!confirmed) return;
    }

    final error = await ref
        .read(leaveActionsProvider.notifier)
        .setStatus(leave.id, status);
    showAppSnackBarOn(
      messenger,
      error ?? 'Leave ${status.label.toLowerCase()} for $name',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(leaveActionsProvider).contains(leave.id);
    final name = leave.employee.name;
    final showEdit = leave.canEdit && ref.can(AppPermission.leaveEdit);
    final showCancel = leave.canCancel && ref.can(AppPermission.leaveCancel);
    final canDecide = leave.canDecide && ref.can(AppPermission.leaveApprove);

    final menu = MenuAnchor(
      menuChildren: [
        if (showEdit)
          MenuItemButton(
            leadingIcon: const Icon(Icons.edit_outlined, size: AppSizes.icon),
            onPressed: () => context.goNamed(
              AppRouteNames.leaveEdit,
              pathParameters: {AppRouteParams.id: leave.id},
            ),
            child: const Text('Edit leave'),
          ),
        if (showCancel)
          MenuItemButton(
            leadingIcon: const Icon(
              Icons.event_busy_outlined,
              size: AppSizes.icon,
            ),
            onPressed: () => _setStatus(context, ref, LeaveStatus.cancelled),
            child: const Text('Cancel leave'),
          ),
      ],
      builder: (context, controller, _) => AppIconButton(
        icon: Icons.more_vert_rounded,
        tooltip: 'More actions for leave of $name',
        onPressed: busy
            ? null
            : () => controller.isOpen ? controller.close() : controller.open(),
      ),
    );

    final hasMenu = showEdit || showCancel;
    if (canDecide) {
      // Pending: decide, or edit / cancel from the menu.
      return Wrap(
        spacing: AppSpacing.s6,
        runSpacing: AppSpacing.s6,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppButton(
            label: 'Approve',
            size: AppButtonSize.small,
            isLoading: busy,
            onPressed: () => _setStatus(context, ref, LeaveStatus.approved),
          ),
          AppButton(
            label: 'Reject',
            size: AppButtonSize.small,
            variant: AppButtonVariant.secondary,
            onPressed: busy
                ? null
                : () => _setStatus(context, ref, LeaveStatus.rejected),
          ),
          if (hasMenu) menu,
        ],
      );
    }
    // Approved leave can only be cancelled; nothing for the rest (and
    // nothing the role doesn't allow).
    return hasMenu ? menu : const SizedBox.shrink();
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.leave});

  final LeaveModel leave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s10,
      children: [
        Row(
          spacing: AppSpacing.s12,
          children: [
            AppAvatar(name: leave.employee.name),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s2,
                children: [
                  Text(
                    leave.employee.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySemibold,
                  ),
                  Text(
                    '${leave.leaveType.name} · '
                    '${AppDateFormat.range(leave.startDate, leave.endDate)} · '
                    '${FormatUtils.days(leave.days)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            LeaveStatusBadge(leave.status),
          ],
        ),
        if (leave.canCancel)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LeaveRowActions(leave: leave),
          ),
      ],
    );
  }
}
