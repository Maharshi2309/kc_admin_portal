import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_feedback_view.dart';

/// Friendly error state with an optional retry button.
///
/// [message] must already be user-facing text; never pass a raw exception.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    this.title = 'Something went wrong',
    this.message,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppFeedbackView(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.dangerFg,
      iconBackground: AppColors.dangerBg,
      title: title,
      message: message,
      compact: compact,
      action: onRetry == null
          ? null
          : AppButton(
              label: 'Try again',
              icon: Icons.refresh_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: onRetry,
            ),
    );
  }
}
