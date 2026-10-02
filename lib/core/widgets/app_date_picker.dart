import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';

/// Labelled single-date field. Opens the Material calendar, or a Cupertino
/// wheel picker on iOS.
///
/// Allowed ranges ([firstDate]/[lastDate]) are business rules and must be
/// supplied by the caller, never defaulted here.
class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.label,
    this.isRequired = false,
    this.hintText = 'Select date',
    this.helperText,
    this.errorText,
    this.validator,
    this.enabled = true,
    this.today,
    super.key,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? label;
  final bool isRequired;
  final String hintText;
  final String? helperText;

  /// Error from the server (e.g. "EC number already exists"). Shown in
  /// place of validator errors while set.
  final String? errorText;
  final FormFieldValidator<DateTime>? validator;
  final bool enabled;

  /// Today, from the app clock (`clockProvider`): where the picker opens
  /// when empty, and which date is labelled "Today". Defaults to the company
  /// clock.
  final DateTime? today;

  DateTime get _today => today ?? CompanyTime.now();

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
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
            _DateButton(
              today: _today,
              value: value,
              hintText: hintText,
              hasError: state.hasError,
              onTap: enabled
                  ? () async {
                      final picked = await _pick(context);
                      if (picked == null) return;
                      state.didChange(picked);
                      onChanged(picked);
                    }
                  : null,
            ),
            AppFieldSubtext(errorText: state.errorText, helperText: helperText),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pick(BuildContext context) {
    final initial = _clamp(value ?? _today);
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      return _pickCupertino(context, initial);
    }
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  Future<DateTime?> _pickCupertino(BuildContext context, DateTime initial) {
    var selected = initial;
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (popupContext) => Container(
        color: AppColors.surface,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  onPressed: () => Navigator.of(popupContext).pop(selected),
                  child: const Text('Done'),
                ),
              ),
              SizedBox(
                height: AppSizes.menuMaxHeight * 0.7,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initial,
                  minimumDate: firstDate,
                  maximumDate: lastDate,
                  onDateTimeChanged: (date) => selected = date,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DateTime _clamp(DateTime date) {
    if (date.isBefore(firstDate)) return firstDate;
    if (date.isAfter(lastDate)) return lastDate;
    return date;
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.value,
    required this.hintText,
    required this.hasError,
    required this.onTap,
    required this.today,
  });

  final DateTime? value;
  final DateTime today;
  final String hintText;
  final bool hasError;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = value != null && AppDateFormat.isSameDay(value!, today);

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
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: AppSizes.iconSmall,
                  ),
                  const SizedBox(width: AppSpacing.s10),
                  Expanded(
                    child: Text(
                      value == null ? hintText : AppDateFormat.long(value!),
                      style: AppTextStyles.input.copyWith(
                        color: value == null ? AppColors.textPlaceholder : null,
                      ),
                    ),
                  ),
                  if (isToday)
                    Text(
                      'Today',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
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
