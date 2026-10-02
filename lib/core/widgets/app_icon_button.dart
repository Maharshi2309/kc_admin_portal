import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';

enum AppIconButtonVariant {
  /// 40 px, white with a border (header actions).
  outlined,

  /// 32 px, no border (row actions: view, edit, more).
  ghost,

  /// 28 px, no border: sits inside an input (password toggle, clear
  /// search). It has no background, so on touch platforms its tap area
  /// grows to [AppSizes.minTouchTarget] without changing how it looks.
  inField,
}

/// Icon-only button. [tooltip] is required: it is also the accessible label.
///
/// On touch platforms Material pads the tap area to 48 px even when the
/// visual size is smaller.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = AppIconButtonVariant.ghost,
    this.bordered = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;

  /// Adds a border to the ghost variant (pagination arrows, month switchers).
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == AppIconButtonVariant.outlined;
    final isInField = variant == AppIconButtonVariant.inField;
    final dimension = switch (variant) {
      AppIconButtonVariant.outlined => AppSizes.iconButton,
      AppIconButtonVariant.ghost => AppSizes.iconButtonGhost,
      AppIconButtonVariant.inField =>
        context.usesTouchInput
            ? AppSizes.minTouchTarget
            : AppSizes.iconButtonInField,
    };
    final hasBorder = isOutlined || bordered;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: isOutlined ? AppSizes.icon : AppSizes.iconSmall),
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size.square(dimension)),
        minimumSize: WidgetStatePropertyAll(Size.square(dimension)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: isInField ? MaterialTapTargetSize.shrinkWrap : null,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: isOutlined ? AppRadius.mdAll : AppRadius.smAll,
            side: hasBorder
                ? const BorderSide(color: AppColors.borderStrong)
                : BorderSide.none,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return isOutlined ? AppColors.background : AppColors.neutralBg;
          }
          return isOutlined ? AppColors.surface : Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textPlaceholder;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.textPrimary;
          }
          return AppColors.textSecondary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
