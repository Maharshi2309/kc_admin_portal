import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// Label shown above form fields, with a red asterisk for required fields.
class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(this.text, {this.isRequired = false, super.key});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.dangerFg),
            ),
        ],
      ),
      style: AppTextStyles.label,
    );
  }
}

/// Stacks an [AppFieldLabel] above a field with the design's 6 px gap.
class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    required this.label,
    required this.child,
    this.isRequired = false,
    this.trailing,
    super.key,
  });

  final String? label;
  final bool isRequired;

  /// Widget aligned to the right of the label (e.g. "Forgot password?").
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (label == null) return child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trailing case final trailing?)
          // The trailing link moves under the label when both don't fit
          // (e.g. "Forgot password?" with large text).
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.s8,
            children: [
              AppFieldLabel(label!, isRequired: isRequired),
              trailing,
            ],
          )
        else
          AppFieldLabel(label!, isRequired: isRequired),
        const SizedBox(height: AppSpacing.s6),
        child,
      ],
    );
  }
}

/// Error text (if any), otherwise helper text, shown below a field.
class AppFieldSubtext extends StatelessWidget {
  const AppFieldSubtext({this.errorText, this.helperText, super.key});

  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final text = errorText ?? helperText;
    if (text == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s6),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: errorText != null ? AppColors.dangerFg : AppColors.textMuted,
        ),
      ),
    );
  }
}
