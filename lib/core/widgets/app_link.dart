import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// Inline text link with an optional trailing chevron, e.g. "Details ›" or
/// "All 11 ›" in card headers.
class AppLink extends StatelessWidget {
  const AppLink({
    required this.label,
    required this.onPressed,
    this.showChevron = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s4,
          ),
        ),
        textStyle: WidgetStatePropertyAll(AppTextStyles.link),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? AppColors.primaryHover
              : AppColors.primary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(label)),
          if (showChevron) ...[
            const SizedBox(width: AppSpacing.s2),
            const Icon(Icons.chevron_right_rounded, size: AppSizes.iconSmall),
          ],
        ],
      ),
    );
  }
}
