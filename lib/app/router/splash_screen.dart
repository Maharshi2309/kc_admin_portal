import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_error_view.dart';
import 'package:kc_admin_portal/core/widgets/app_loader.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

/// Shown while the stored session is checked at start-up. If the check
/// fails (e.g. offline), offers a retry instead of signing the user out.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.s16,
            children: [
              const BrandMark(),
              if (auth.hasError && !auth.isLoading)
                AppErrorView(
                  title: 'Could not check your session',
                  message: ErrorHandler.messageFor(auth.error!),
                  onRetry: () => ref.invalidate(authControllerProvider),
                )
              else
                const AppLoader(small: true),
            ],
          ),
        ),
      ),
    );
  }
}
