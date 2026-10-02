import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_breadcrumb.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/access_control/presentation/providers/access_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';
import 'package:kc_admin_portal/features/users/presentation/widgets/user_permissions_editor.dart';
import 'package:kc_admin_portal/features/users/presentation/widgets/users_table.dart';

/// One staff user: who they are, and exactly what they may do.
class UserAccessScreen extends ConsumerWidget {
  const UserAccessScreen({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailProvider(userId));
    final catalogue = ref.watch(permissionCatalogueProvider);
    final others = ref.watch(userListProvider).value?.items ?? const [];
    final youId = ref.watch(authControllerProvider).value?.id;

    return AppPageBody(
      children: [
        AppBreadcrumb(
          items: [
            AppBreadcrumbItem(
              'Access control',
              onTap: () => context.goNamed(AppRouteNames.accessControl),
            ),
            AppBreadcrumbItem(user.value?.name ?? 'User'),
          ],
        ),
        AsyncValueView<UserAccountModel>(
          value: user,
          onRetry: () => ref.invalidate(userDetailProvider(userId)),
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s20,
            children: [
              _Header(user: user, isYou: user.id == youId),
              AsyncValueView<List<PermissionModuleModel>>(
                value: catalogue,
                onRetry: () => ref.invalidate(permissionCatalogueProvider),
                data: (modules) => UserPermissionsEditor(
                  // A saved or reloaded user starts a fresh draft.
                  key: ValueKey('${user.id}:${user.permissions.join(',')}'),
                  user: user,
                  modules: modules,
                  isYou: user.id == youId,
                  otherUsers: [
                    for (final u in others)
                      if (u.id != user.id) u,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.user, required this.isYou});

  final UserAccountModel user;
  final bool isYou;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);
    final employee = user.employee;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Wrap(
        spacing: AppSpacing.s20,
        runSpacing: AppSpacing.s16,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s16,
            children: [
              AppAvatar(name: user.name, size: AppSizes.avatarLarge),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.s4,
                  children: [
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(user.name, style: AppTextStyles.headingLarge),
                        if (isYou)
                          const AppStatusBadge(
                            label: 'You',
                            tone: StatusTone.info,
                          ),
                        user.isActive
                            ? const AppStatusBadge(
                                label: 'Active',
                                tone: StatusTone.success,
                              )
                            : const AppStatusBadge(
                                label: 'Inactive',
                                tone: StatusTone.neutral,
                              ),
                      ],
                    ),
                    Text(user.email, style: muted),
                    Text(
                      [
                        if (employee == null)
                          'No linked employee'
                        else
                          'Employee: ${employee.name} · ${employee.ecNumber}',
                        'Last sign-in: '
                            '${lastSignInLabel(user.lastSignInAt, now)}',
                      ].join(' · '),
                      style: muted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.s10,
            runSpacing: AppSpacing.s8,
            children: [
              if (!isYou) UserStatusButton(user: user),
              AppButton(
                label: 'Edit details',
                icon: Icons.edit_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.goNamed(
                  AppRouteNames.userEdit,
                  pathParameters: {AppRouteParams.id: user.id},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
