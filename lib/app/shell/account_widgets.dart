import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

/// Signed-in admin card at the bottom of the desktop sidebar.
class SidebarUserCard extends StatelessWidget {
  const SidebarUserCard({
    required this.user,
    required this.onSignOut,
    super.key,
  });

  final UserModel user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
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
                  user.hasFullAccess ? 'Full access' : user.email,
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
    );
  }
}

/// Avatar button opening a menu with the admin's details and "Sign out"
/// (navigation rail and phone top bar).
class AccountMenuButton extends StatelessWidget {
  const AccountMenuButton({
    required this.user,
    required this.onSignOut,
    super.key,
  });

  final UserModel user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
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
