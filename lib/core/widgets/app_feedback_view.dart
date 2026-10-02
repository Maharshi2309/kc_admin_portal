import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// Shared layout for [AppErrorView] and [AppEmptyView]: icon, title,
/// message and an optional action, centered and width-limited.
class AppFeedbackView extends StatelessWidget {
  const AppFeedbackView({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    this.message,
    this.action,
    this.compact = false,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String? message;
  final Widget? action;

  /// Tighter spacing for use inside cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.feedbackMaxWidth),
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.s16 : AppSpacing.s32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSizes.iconFeature,
                height: AppSizes.iconFeature,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: AppRadius.lgAll,
                ),
                child: Icon(icon, color: iconColor, size: AppSizes.icon),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.s6),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: AppSpacing.s20),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
