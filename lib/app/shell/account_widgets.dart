import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/shell/layout_mode_switch.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

/// What the second line under the user's name says: the organization they
/// are working in, or (from a server without organizations) their access.
String _accountSubtitle(UserModel user) =>
    user.organization?.name ??
    (user.hasFullAccess ? 'Full access' : user.email);

/// Signed-in admin card at the bottom of the desktop sidebar.
class SidebarUserCard extends StatelessWidget {
  const SidebarUserCard({
    required this.user,
    required this.onSignOut,
    this.onSwitchOrganization,
    super.key,
  });

  final UserModel user;
  final VoidCallback onSignOut;

  /// "Organizations": switch, invitations, create another.
  final VoidCallback? onSwitchOrganization;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s8,
        children: [
          Row(
            spacing: AppSpacing.s10,
            children: [
              AppAvatar(name: user.name, size: AppSizes.avatarSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.smallSemibold.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _accountSubtitle(user),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              AppIconButton(
                icon: Icons.logout_rounded,
                tooltip: 'Sign out',
                onPressed: onSignOut,
              ),
            ],
          ),
          // Its own line, so the name and organization keep their room.
          if (user.organization != null && onSwitchOrganization != null)
            AppButton(
              label: 'Organizations',
              icon: Icons.swap_horiz_rounded,
              variant: AppButtonVariant.ghost,
              size: AppButtonSize.small,
              onPressed: onSwitchOrganization,
            ),
        ],
      ),
    );
  }
}

/// Avatar button opening a menu with the admin's details, their
/// organization, "Organizations", the layout choice and "Sign out"
/// (navigation rail and phone top bar).
class AccountMenuButton extends ConsumerWidget {
  const AccountMenuButton({
    required this.user,
    required this.onSignOut,
    this.onSwitchOrganization,
    super.key,
  });

  final UserModel user;
  final VoidCallback onSignOut;

  /// "Organizations": switch, invitations, create another.
  final VoidCallback? onSwitchOrganization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, AppSpacing.s4),
      menuChildren: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(user.name, style: AppTextStyles.bodySemibold),
              Text(
                user.email,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              if (user.organization case final organization?)
                Text(
                  organization.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        const Divider(),
        if (user.organization != null && onSwitchOrganization != null)
          MenuItemButton(
            leadingIcon: const Icon(
              Icons.swap_horiz_rounded,
              size: AppSizes.icon,
            ),
            onPressed: onSwitchOrganization,
            child: const Text('Organizations'),
          ),
        const Divider(),
        ...layoutModeMenuItems(ref),
        const Divider(),
        MenuItemButton(
          leadingIcon: const Icon(Icons.logout_rounded, size: AppSizes.icon),
          onPressed: onSignOut,
          child: const Text('Sign out'),
        ),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: 'Account',
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        icon: AppAvatar(name: user.name, size: AppSizes.avatarSmall),
      ),
    );
  }
}
