import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/invitation_card.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// "Your organizations": work in another of the user's organizations
/// (everything then reloads for it and the app returns to its home page,
/// docs/ARCHITECTURE_MULTI_ORG.md §C), answer invitations, or create
/// another organization.
Future<void> showOrganizationsDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final user = ref.read(authControllerProvider).value;
  if (user == null) return;
  final messenger = ScaffoldMessenger.of(context);
  final controller = ref.read(authControllerProvider.notifier);

  final chosen = await showDialog<MembershipModel>(
    context: context,
    builder: (_) => _OrganizationsDialog(user: user),
  );
  if (chosen == null || chosen.organizationId == user.organization?.id) {
    return;
  }
  try {
    await controller.switchOrganization(chosen.organizationId);
    showAppSnackBarOn(
      messenger,
      'Now working in ${chosen.name}',
      tone: SnackBarTone.success,
    );
  } on AppException catch (error) {
    showAppSnackBarOn(
      messenger,
      ErrorHandler.messageFor(error),
      tone: SnackBarTone.error,
    );
  }
}

class _OrganizationsDialog extends ConsumerWidget {
  const _OrganizationsDialog({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitations = ref.watch(invitationsProvider).value ?? const [];
    return AppDialog(
      title: 'Your organizations',
      subtitle: 'Each organization has its own employees and data',
      maxWidth: AppSizes.confirmDialogMaxWidth,
      fullscreenOnMobile: false,
      actions: [
        AppButton(
          label: 'Create organization',
          icon: Icons.add_business_outlined,
          variant: AppButtonVariant.secondary,
          onPressed: () {
            Navigator.of(context).pop();
            context.goNamed(AppRouteNames.createOrganization);
          },
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s8,
        children: [
          for (final membership
              in user.memberships ?? const <MembershipModel>[])
            _OrganizationTile(
              membership: membership,
              isCurrent: membership.organizationId == user.organization?.id,
              onTap: () => Navigator.of(context).pop(membership),
            ),
          if (invitations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s8),
            Text('Invitations', style: AppTextStyles.smallSemibold),
            for (final invitation in invitations)
              InvitationCard(invitation: invitation),
          ],
        ],
      ),
    );
  }
}

class _OrganizationTile extends StatelessWidget {
  const _OrganizationTile({
    required this.membership,
    required this.isCurrent,
    required this.onTap,
  });

  final MembershipModel membership;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isCurrent,
      label: '${membership.name}${isCurrent ? ', current' : ''}',
      excludeSemantics: true,
      child: Material(
        color: isCurrent ? AppColors.primarySubtle : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(
            color: isCurrent ? AppColors.primary : AppColors.border,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: Row(
              spacing: AppSpacing.s12,
              children: [
                AppAvatar(name: membership.name, size: AppSizes.avatarSmall),
                Expanded(
                  child: Text(
                    membership.name,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySemibold,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'Current',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
