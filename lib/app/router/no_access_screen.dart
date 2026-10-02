import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/shell/nav_destinations.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

/// Shown when the signed-in user's permissions don't include the page they
/// asked for (e.g. an old link), or include no page at all.
class NoAccessScreen extends ConsumerWidget {
  const NoAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grants = ref.watch(grantsProvider);
    final home = homeLocationFor(grants);
    final section = visibleBranches(grants).firstOrNull;
    final signOut = AppButton(
      label: 'Sign out',
      variant: home == null
          ? AppButtonVariant.primary
          : AppButtonVariant.secondary,
      onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.s24),
              child: BrandMark(),
            ),
            Expanded(
              child: AppEmptyView(
                icon: Icons.lock_outline_rounded,
                title: home == null
                    ? 'You have no access yet'
                    : 'You don’t have access to this page',
                message: home == null
                    ? 'Ask an administrator to give you permissions.'
                    : 'Your permissions don’t include it. Ask an '
                          'administrator if you need it.',
                action: Wrap(
                  spacing: AppSpacing.s10,
                  runSpacing: AppSpacing.s10,
                  alignment: WrapAlignment.center,
                  children: [
                    signOut,
                    if (home != null)
                      AppButton(
                        label: section == null
                            ? 'Go back'
                            : 'Go to ${appNavDestinations[section].label}',
                        onPressed: () => context.go(home),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
