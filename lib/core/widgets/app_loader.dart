import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// Loading indicator, centered in the available space.
class AppLoader extends StatelessWidget {
  const AppLoader({this.message, this.small = false, super.key});

  final String? message;

  /// Smaller spinner for inline use (inside cards, buttons, table footers).
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? AppSizes.loaderSizeSmall : AppSizes.loaderSize;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: size,
              child: CircularProgressIndicator(
                strokeWidth: AppSizes.loaderStroke,
                semanticsLabel: message ?? 'Loading',
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.s12),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
