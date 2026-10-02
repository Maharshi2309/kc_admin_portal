import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

enum AppButtonVariant {
  /// Filled brand button: the main action on a screen.
  primary,

  /// White outlined button: secondary actions (Cancel, Export, Edit).
  secondary,

  /// Outlined button with red text: destructive actions (Deactivate, Delete).
  danger,

  /// Text-only button.
  ghost,
}

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;

  /// Shows a spinner and ignores taps while keeping the enabled look.
  final bool isLoading;

  /// Stretches to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final style = _sizeStyle.merge(_variantStyle);
    final effectiveOnPressed = isLoading ? _ignoreTap : onPressed;
    final child = _ButtonContent(
      label: label,
      icon: icon,
      isLoading: isLoading,
      iconSize: size == AppButtonSize.small
          ? AppSizes.iconSmall
          : AppSizes.icon,
    );

    final Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.secondary || AppButtonVariant.danger => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: isLoading ? '$label, loading' : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }

  static void _ignoreTap() {}

  ButtonStyle get _sizeStyle => switch (size) {
    AppButtonSize.small => ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(0, AppSizes.buttonHeightSmall),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.s12),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      ),
      textStyle: WidgetStatePropertyAll(AppTextStyles.buttonSmall),
    ),
    AppButtonSize.medium => const ButtonStyle(),
    AppButtonSize.large => ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(0, AppSizes.buttonHeightLarge),
      ),
      textStyle: WidgetStatePropertyAll(AppTextStyles.buttonLarge),
    ),
  };

  ButtonStyle get _variantStyle => switch (variant) {
    AppButtonVariant.danger => const ButtonStyle(
      foregroundColor: WidgetStatePropertyAll(AppColors.dangerFg),
    ),
    _ => const ButtonStyle(),
  };
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.iconSize,
  });

  final String label;
  final IconData? icon;
  final bool isLoading;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final foreground = DefaultTextStyle.of(context).style.color;
    final Widget? leading = isLoading
        ? SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: AppSizes.loaderStroke,
              color: foreground,
            ),
          )
        : icon == null
        ? null
        : Icon(icon, size: iconSize);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: AppSpacing.s8)],
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
