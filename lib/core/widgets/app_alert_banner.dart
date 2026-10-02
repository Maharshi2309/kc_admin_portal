import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

enum AlertTone { error, info }

/// Inline message box, e.g. a failed sign-in or "N employees have not
/// punched in yet". Announced to screen readers when it appears.
class AppAlertBanner extends StatelessWidget {
  const AppAlertBanner({
    required this.message,
    this.tone = AlertTone.error,
    this.title,
    this.action,
    super.key,
  });

  final String message;
  final AlertTone tone;
  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isError = tone == AlertTone.error;
    final foreground = isError ? AppColors.dangerFg : AppColors.primary;

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: isError ? AppColors.dangerSurface : AppColors.primarySubtle,
          border: Border.all(
            color: isError ? AppColors.dangerBorder : AppColors.primaryMuted,
          ),
          borderRadius: AppRadius.lgAll,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final content = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s12,
              children: [
                Icon(
                  isError
                      ? Icons.error_outline_rounded
                      : Icons.info_outline_rounded,
                  size: AppSizes.icon,
                  color: foreground,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s2,
                    children: [
                      if (title != null)
                        Text(title!, style: AppTextStyles.bodySemibold),
                      Text(
                        message,
                        style: AppTextStyles.small.copyWith(
                          color: title == null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (action != null && !_stacked(constraints)) action!,
              ],
            );
            if (action == null || !_stacked(constraints)) return content;

            // Narrow: the action goes under the message.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppSpacing.s12,
              children: [content, action!],
            );
          },
        ),
      ),
    );
  }

  /// Below this width an action sits under the message instead of beside it.
  static const double _actionBesideMinWidth = 560;

  static bool _stacked(BoxConstraints constraints) =>
      constraints.maxWidth < _actionBesideMinWidth;
}
