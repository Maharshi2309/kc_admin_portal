import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';

/// Every country as a dropdown choice: "India (+91)".
List<AppDropdownItem<String>> phoneCountryItems() => [
  for (final c in PhoneUtils.countries)
    AppDropdownItem(value: c.code, label: '${c.name} (+${c.dialCode})'),
];

/// A mobile number with its country code (2026-10-13): a "+91 ▾" button
/// before the number opens a searchable list of countries. A number typed
/// with "+" keeps its own code.
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    this.label = 'Mobile number',
    this.isRequired = true,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;

  /// ISO code of the chosen country, e.g. `IN`.
  final String country;
  final ValueChanged<String> onCountryChanged;
  final String label;
  final bool isRequired;
  final bool enabled;

  /// Error from the server.
  final String? errorText;
  final ValueChanged<String>? onChanged;

  static const int _maxLength = 20;

  @override
  Widget build(BuildContext context) {
    final chosen = PhoneUtils.country(country);
    return AppTextField(
      label: label,
      isRequired: isRequired,
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-().]')),
        LengthLimitingTextInputFormatter(_maxLength),
      ],
      prefixWidget: _CountryCodeButton(
        country: chosen,
        onPressed: enabled
            ? () async {
                final picked = await showPhoneCountryPicker(
                  context,
                  selected: country,
                );
                if (picked != null) onCountryChanged(picked);
              }
            : null,
      ),
      errorText: errorText,
      validator: (value) =>
          PhoneUtils.validate(value, country: country, required: isRequired),
      onChanged: onChanged,
    );
  }
}

class _CountryCodeButton extends StatelessWidget {
  const _CountryCodeButton({required this.country, required this.onPressed});

  final PhoneCountry country;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = onPressed == null
        ? AppColors.textDisabled
        : AppColors.textSecondary;
    return Semantics(
      button: true,
      label: 'Country code: ${country.name}, +${country.dialCode}. Change',
      excludeSemantics: true,
      child: Tooltip(
        message: 'Country code: ${country.name}',
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.smAll,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s2,
              children: [
                Text(
                  '+${country.dialCode}',
                  style: AppTextStyles.bodySemibold.copyWith(color: color),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  size: AppSizes.icon,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A searchable list of countries; returns the chosen ISO code.
Future<String?> showPhoneCountryPicker(
  BuildContext context, {
  required String selected,
}) => showDialog<String>(
  context: context,
  builder: (context) => _CountryPickerDialog(selected: selected),
);

class _CountryPickerDialog extends StatefulWidget {
  const _CountryPickerDialog({required this.selected});

  final String selected;

  @override
  State<_CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  String _query = '';

  static const double _listHeight = 420;
  static const double _minListHeight = 200;

  /// The dialog's title bar and search field on a phone.
  static const double _mobileChromeHeight = 220;
  static const double _maxWidth = 440;

  @override
  Widget build(BuildContext context) {
    final query = _query.toLowerCase().replaceAll('+', '');
    final countries = [
      // The current one first while not searching.
      if (query.isEmpty) PhoneUtils.country(widget.selected),
      for (final c in PhoneUtils.countries)
        if (query.isEmpty
            ? c.code != widget.selected
            : c.name.toLowerCase().contains(query) ||
                  c.code.toLowerCase() == query ||
                  c.dialCode.startsWith(query))
          c,
    ];
    // Phones: the dialog is full screen, so the list takes the rest of it.
    final listHeight = context.isMobile
        ? math.max(
            _minListHeight,
            MediaQuery.sizeOf(context).height - _mobileChromeHeight,
          )
        : _listHeight;
    final list = countries.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Text(
              'No country matches "$_query"',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
          )
        : ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final c = countries[index];
              final selected = c.code == widget.selected;
              return ListTile(
                dense: true,
                selected: selected,
                title: Text(c.name, style: AppTextStyles.body),
                trailing: Text(
                  '+${c.dialCode}',
                  style: AppTextStyles.bodySemibold.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                leading: selected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : const SizedBox(width: AppSizes.iconLarge),
                onTap: () => Navigator.of(context).pop(c.code),
              );
            },
          );
    return AppDialog(
      title: 'Country code',
      maxWidth: _maxWidth,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s12,
        children: [
          AppSearchField(
            hintText: 'Country or code, e.g. India or 91',
            autofocus: true,
            onChanged: (text) => setState(() => _query = text.trim()),
          ),
          SizedBox(height: listHeight, child: list),
        ],
      ),
    );
  }
}
