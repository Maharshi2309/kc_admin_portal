import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/screens/login_screen.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/account_page_parts.dart';
import 'package:kc_admin_portal/features/onboarding/presentation/widgets/invitation_card.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// For someone signed in but in no organization yet (a new account, or one
/// whose only invitation is still waiting): join an organization they were
/// invited to, or create their own. Every other page sends them here.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final invitations = ref.watch(invitationsProvider);
    final firstName = user?.name.trim().split(' ').first ?? '';

    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s20,
        children: [
          AccountPageHeader(
            title: firstName.isEmpty ? 'Welcome' : 'Welcome, $firstName',
            subtitle:
                'Create your organization to manage your employees, '
                "attendance and leave, or join one you've been invited to.",
          ),
          AsyncValueView<List<InvitationModel>>(
            value: invitations,
            compact: true,
            onRetry: () => ref.invalidate(invitationsProvider),
            isEmpty: (items) => items.isEmpty,
            empty: const SizedBox.shrink(),
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s10,
              children: [
                Text('Invitations', style: AppTextStyles.smallSemibold),
                for (final invitation in items)
                  InvitationCard(invitation: invitation),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Or start your own',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: 'Create your organization',
            icon: Icons.add_business_outlined,
            size: AppButtonSize.large,
            expand: true,
            onPressed: () => context.goNamed(AppRouteNames.createOrganization),
          ),
          AccountLinkLine(
            text: user == null ? '' : 'Signed in as ${user.email}.',
            linkLabel: 'Sign out',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}
