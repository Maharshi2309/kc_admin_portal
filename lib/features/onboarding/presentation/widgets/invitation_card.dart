import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// "Sunrise Garments · Invited by Ravi Mehta" with Join and Decline.
/// Joining opens that organization.
class InvitationCard extends ConsumerWidget {
  const InvitationCard({required this.invitation, super.key});

  final InvitationModel invitation;

  Future<void> _act(BuildContext context, WidgetRef ref, bool join) async {
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(invitationActionsProvider.notifier);
    final name = invitation.organization.name;
    final error = join
        ? await actions.accept(invitation.id)
        : await actions.decline(invitation.id);
    showAppSnackBarOn(
      messenger,
      error != null
          ? ErrorHandler.messageFor(error)
          : join
          ? 'You joined $name'
          : 'Invitation from $name declined',
      tone: error != null ? SnackBarTone.error : SnackBarTone.success,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(invitationActionsProvider).contains(invitation.id);
    final name = invitation.organization.name;
    final invitedBy = invitation.invitedBy;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s12,
        children: [
          Row(
            spacing: AppSpacing.s12,
            children: [
              AppAvatar(name: name, size: AppSizes.avatarSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s2,
                  children: [
                    Text(name, style: AppTextStyles.bodySemibold),
                    Text(
                      invitedBy == null
                          ? 'You are invited to join'
                          : 'Invited by $invitedBy',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              AppButton(
                label: 'Decline',
                variant: AppButtonVariant.ghost,
                size: AppButtonSize.small,
                onPressed: busy ? null : () => _act(context, ref, false),
              ),
              AppButton(
                label: 'Join $name',
                size: AppButtonSize.small,
                isLoading: busy,
                onPressed: () => _act(context, ref, true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
