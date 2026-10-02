import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';

/// A quick-set button under a time field, e.g. "Shift start 09:30".
class AppTimeShortcut {
  const AppTimeShortcut({required this.label, required this.time});

  final String label;
  final TimeOfDay time;
}

/// Labelled 24-hour time field. Opens the time picker; optional shortcut
/// buttons set common times in one tap.
class AppTimeField extends StatelessWidget {
  const AppTimeField({
    required this.value,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.hintText = 'Set time',
    this.helperText,
    this.errorText,
    this.validator,
    this.shortcuts = const [],
    this.onClear,
    this.enabled = true,
    super.key,
  });

  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final String? label;
  final bool isRequired;
  final String hintText;
  final String? helperText;

  /// Error from the server, shown in place of validator errors while set.
  final String? errorText;
  final FormFieldValidator<TimeOfDay>? validator;
  final List<AppTimeShortcut> shortcuts;

  /// Shows a "Clear" shortcut when set and a value is present.
  final VoidCallback? onClear;
  final bool enabled;

  static String format(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      key: ValueKey(value),
      initialValue: value,
      validator: validator,
      forceErrorText: errorText,
      enabled: enabled,
      builder: (state) => AppLabeledField(
        label: label,
        isRequired: isRequired,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _TimeButton(
              value: value,
              hintText: hintText,
              hasError: state.hasError,
              onTap: enabled ? () => _pick(context, state) : null,
            ),
            if (enabled && (shortcuts.isNotEmpty || onClear != null))
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s8),
                child: Wrap(
                  spacing: AppSpacing.s6,
                  runSpacing: AppSpacing.s6,
                  children: [
                    for (final shortcut in shortcuts)
                      AppButton(
                        label: shortcut.label,
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.secondary,
                        onPressed: () {
                          state.didChange(shortcut.time);
                          onChanged(shortcut.time);
                        },
                      ),
                    if (onClear != null && value != null)
                      AppButton(
                        label: 'Clear',
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.ghost,
                        onPressed: onClear,
                      ),
                  ],
                ),
              ),
            AppFieldSubtext(errorText: state.errorText, helperText: helperText),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(
    BuildContext context,
    FormFieldState<TimeOfDay> state,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    state.didChange(picked);
    onChanged(picked);
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.value,
    required this.hintText,
    required this.hasError,
    required this.onTap,
  });

  final TimeOfDay? value;
  final String hintText;
  final bool hasError;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = value == null
        // A state ("Not punched out"), not a hint, so it keeps text contrast.
        ? AppTextStyles.input.copyWith(color: AppColors.textMuted)
        : AppTextStyles.inputLarge.copyWith(
            fontWeight: AppTextStyles.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
          );

    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        color: onTap == null ? AppColors.surfaceDisabled : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(
            color: hasError ? AppColors.dangerFg : AppColors.borderStrong,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
              child: Row(
                spacing: AppSpacing.s10,
                children: [
                  const Icon(Icons.schedule_rounded, size: AppSizes.iconSmall),
                  Expanded(
                    child: Text(
                      value == null ? hintText : AppTimeField.format(value!),
                      style: style,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
