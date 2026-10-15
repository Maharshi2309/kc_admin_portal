import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';

/// "Today, 9:12 AM", "Yesterday", "21 Sep 2026" or "Never".
String lastSignInLabel(DateTime? at, DateTime now) {
  if (at == null) return 'Never';
  final days = now.dateOnly.difference(at.dateOnly).inDays;
  return switch (days) {
    0 => 'Today, ${AppDateFormat.time(at)}',
    1 => 'Yesterday',
    _ => AppDateFormat.medium(at),
  };
}

/// "Full access", "No access" or "8 of 21 permissions", counting the
/// permissions this app knows.
String accessLabel(UserAccountModel user) {
  final total = AppPermission.values.length;
  final count = AppPermission.parseAll(user.permissions).length;
  if (count == 0) return 'No access';
  if (count == total) return 'Full access';
  return '$count of $total permissions';
}

/// Staff users with their linked employee, access and last sign-in.
class UsersTable extends ConsumerWidget {
  const UsersTable({required this.users, super.key});

  final List<UserAccountModel> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    final youId = ref.watch(authControllerProvider).value?.id;
    return ResponsiveDataView<UserAccountModel>(
      rows: users,
      rowKey: (u) => u.id,
      mobileItemBuilder: (context, u) =>
          _MobileItem(user: u, isYou: u.id == youId, now: now),
      columns: [
        AppDataColumn(
          label: 'User',
          flex: 3,
          minWidth: 260,
          cellBuilder: (context, u) => _UserCell(user: u, isYou: u.id == youId),
        ),
        AppDataColumn(
          label: 'Employee',
          flex: 2,
          minWidth: 170,
          cellBuilder: (context, u) => _EmployeeCell(user: u),
        ),
        AppDataColumn(
          label: 'Access',
          minWidth: 170,
          cellBuilder: (context, u) => _AccessBadge(user: u),
        ),
        AppDataColumn(
          label: 'Last sign-in',
          minWidth: 150,
          priority: 1,
          cellBuilder: (context, u) => Text(
            lastSignInLabel(u.lastSignInAt, now),
            style: AppTextStyles.small,
          ),
        ),
        AppDataColumn(
          label: 'Status',
          minWidth: 110,
          cellBuilder: (context, u) => UserStatusBadge(user: u),
        ),
        AppDataColumn(
          label: '',
          fixedWidth: context.usesTouchInput ? 196 : 172,
          alignment: AlignmentDirectional.centerEnd,
          cellBuilder: (context, u) => _Actions(user: u, isYou: u.id == youId),
        ),
      ],
    );
  }
}

class _UserCell extends StatelessWidget {
  const _UserCell({required this.user, required this.isYou});

  final UserAccountModel user;
  final bool isYou;

  @override
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.s10,
    children: [
      AppAvatar(name: user.name, size: AppSizes.avatarSmall),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.s2,
          children: [
            Wrap(
              spacing: AppSpacing.s6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(user.name, style: AppTextStyles.bodySemibold),
                if (isYou)
                  const AppStatusBadge(label: 'You', tone: StatusTone.info),
              ],
            ),
            Text(
              user.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    ],
  );
}

class _EmployeeCell extends StatelessWidget {
  const _EmployeeCell({required this.user});

  final UserAccountModel user;

  @override
  Widget build(BuildContext context) {
    final employee = user.employee;
    if (employee == null) {
      return Text(
        'Not linked',
        style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s2,
      children: [
        Text(employee.name, style: AppTextStyles.small),
        Text(
          employee.ecNumber,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _AccessBadge extends StatelessWidget {
  const _AccessBadge({required this.user});

  final UserAccountModel user;

  @override
  Widget build(BuildContext context) {
    final label = accessLabel(user);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppStatusBadge(
        label: label,
        tone: switch (label) {
          'Full access' => StatusTone.info,
          'No access' => StatusTone.neutral,
          _ => StatusTone.offDayWorked,
        },
      ),
    );
  }
}

/// "Invited", "Active" or "Inactive".
class UserStatusBadge extends StatelessWidget {
  const UserStatusBadge({required this.user, super.key});

  final UserAccountModel user;

  @override
  Widget build(BuildContext context) => user.invitationPending
      ? const AppStatusBadge(label: 'Invited', tone: StatusTone.info)
      : user.isActive
      ? const AppStatusBadge(label: 'Active', tone: StatusTone.success)
      : const AppStatusBadge(label: 'Inactive', tone: StatusTone.neutral);
}

/// Deactivates (after asking) or reactivates [user], and says how it went.
Future<void> toggleUserStatus(
  BuildContext context,
  WidgetRef ref,
  UserAccountModel user,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final activating = !user.isActive;
  if (!activating) {
    final confirmed = await showAppConfirmDialog(
      context,
      title: 'Deactivate ${user.name}?',
      message:
          'They will no longer be able to sign in. You can reactivate them '
          'later.',
      confirmLabel: 'Deactivate user',
      isDestructive: true,
    );
    if (!confirmed) return;
  }
  final error = await ref
      .read(userActionsProvider.notifier)
      .setActive(user, active: activating);
  showAppSnackBarOn(
    messenger,
    error ?? '${user.name} ${activating ? 'reactivated' : 'deactivated'}',
    tone: error == null ? SnackBarTone.success : SnackBarTone.error,
  );
}

/// Withdraws [user]'s invitation after asking, and says how it went.
/// Returns true when it was cancelled.
Future<bool> cancelUserInvitation(
  BuildContext context,
  WidgetRef ref,
  UserAccountModel user,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final confirmed = await showAppConfirmDialog(
    context,
    title: 'Cancel the invitation to ${user.name}?',
    message:
        '${user.email} will no longer be able to join with this invitation. '
        'You can invite them again later.',
    confirmLabel: 'Cancel invitation',
    cancelLabel: 'Keep invitation',
    isDestructive: true,
  );
  if (!confirmed) return false;
  final error = await ref
      .read(userActionsProvider.notifier)
      .cancelInvitation(user);
  showAppSnackBarOn(
    messenger,
    error ?? 'Invitation to ${user.name} cancelled',
    tone: error == null ? SnackBarTone.success : SnackBarTone.error,
  );
  return error == null;
}

/// Emails [user]'s invitation again, and says how it went.
Future<void> resendUserInvitation(
  BuildContext context,
  WidgetRef ref,
  UserAccountModel user,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final error = await ref
      .read(userActionsProvider.notifier)
      .resendInvitation(user);
  showAppSnackBarOn(
    messenger,
    error ?? 'Invitation sent again to ${user.email}',
    tone: error == null ? SnackBarTone.success : SnackBarTone.error,
  );
}

/// "Deactivate" / "Reactivate" for a user's page.
class UserStatusButton extends ConsumerWidget {
  const UserStatusButton({required this.user, super.key});

  final UserAccountModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(userActionsProvider).contains(user.id);
    return AppButton(
      label: user.isActive ? 'Deactivate' : 'Reactivate',
      variant: user.isActive
          ? AppButtonVariant.danger
          : AppButtonVariant.secondary,
      isLoading: busy,
      onPressed: () => toggleUserStatus(context, ref, user),
    );
  }
}

/// Permissions, edit, and a menu: deactivate / reactivate, or for an
/// invitation, resend / cancel it. Nobody can deactivate themselves, so the
/// menu is off on their own row.
class _Actions extends ConsumerWidget {
  const _Actions({required this.user, required this.isYou});

  final UserAccountModel user;
  final bool isYou;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(userActionsProvider).contains(user.id);
    final id = {AppRouteParams.id: user.id};
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s8,
      children: [
        AppIconButton(
          icon: Icons.key_outlined,
          tooltip: 'Permissions of ${user.name}',
          onPressed: () =>
              context.goNamed(AppRouteNames.userAccess, pathParameters: id),
        ),
        AppIconButton(
          icon: Icons.edit_outlined,
          tooltip: 'Edit ${user.name}',
          onPressed: busy
              ? null
              : () =>
                    context.goNamed(AppRouteNames.userEdit, pathParameters: id),
        ),
        MenuAnchor(
          menuChildren: [
            if (user.invitationPending) ...[
              MenuItemButton(
                leadingIcon: const Icon(
                  Icons.forward_to_inbox_outlined,
                  size: AppSizes.icon,
                ),
                onPressed: () => resendUserInvitation(context, ref, user),
                child: const Text('Resend invitation'),
              ),
              MenuItemButton(
                leadingIcon: const Icon(
                  Icons.cancel_outlined,
                  size: AppSizes.icon,
                ),
                onPressed: () => cancelUserInvitation(context, ref, user),
                child: const Text('Cancel invitation'),
              ),
            ] else
              MenuItemButton(
                leadingIcon: Icon(
                  user.isActive
                      ? Icons.block_rounded
                      : Icons.check_circle_outline_rounded,
                  size: AppSizes.icon,
                ),
                onPressed: () => toggleUserStatus(context, ref, user),
                child: Text(user.isActive ? 'Deactivate' : 'Reactivate'),
              ),
          ],
          builder: (context, controller, _) => AppIconButton(
            icon: Icons.more_vert_rounded,
            tooltip: isYou
                ? 'You cannot deactivate yourself'
                : 'More actions for ${user.name}',
            onPressed: busy || isYou
                ? null
                : () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
          ),
        ),
      ],
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({
    required this.user,
    required this.isYou,
    required this.now,
  });

  final UserAccountModel user;
  final bool isYou;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        Row(
          spacing: AppSpacing.s8,
          children: [
            Expanded(
              child: _UserCell(user: user, isYou: isYou),
            ),
            _Actions(user: user, isYou: isYou),
          ],
        ),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            UserStatusBadge(user: user),
            _AccessBadge(user: user),
            Text(
              user.employee == null
                  ? 'Not linked'
                  : '${user.employee!.name} · ${user.employee!.ecNumber}',
              style: muted,
            ),
            Text(
              'Last sign-in: ${lastSignInLabel(user.lastSignInAt, now)}',
              style: muted,
            ),
          ],
        ),
      ],
    );
  }
}
