import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_focus_ring.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({required this.value, required this.label, this.meta});

  final T value;
  final String label;

  /// Muted text on the right of the option, e.g. "18 people".
  final String? meta;
}

/// Labelled select field. With [searchable] the user can type to filter the
/// options (department list in the design).
///
/// Works inside a [Form]: [validator] runs on `FormState.validate()`.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.isRequired = false,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.searchable = false,
    this.enabled = true,
    super.key,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? label;
  final bool isRequired;
  final String? hintText;
  final String? helperText;

  /// Error from the server (e.g. "EC number already exists"). Shown in
  /// place of validator errors while set.
  final String? errorText;
  final FormFieldValidator<T>? validator;
  final bool searchable;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      // Re-create the field state when the selected value changes from outside.
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
            AppFocusRing(
              child: _LabelSyncedDropdownMenu<T>(
                value: value,
                items: items,
                initialSelection: value,
                enabled: enabled,
                hintText: hintText,
                expandedInsets: EdgeInsets.zero,
                enableFilter: searchable,
                enableSearch: searchable,
                requestFocusOnTap: searchable,
                menuHeight: AppSizes.menuMaxHeight,
                textStyle: AppTextStyles.input,
                // The labels name the open/close button for screen readers.
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSizes.icon,
                  semanticLabel: 'Show options',
                ),
                selectedTrailingIcon: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: AppSizes.icon,
                  semanticLabel: 'Hide options',
                ),
                inputDecorationTheme: _decoration(context, state.hasError),
                onSelected: (selected) {
                  state.didChange(selected);
                  onChanged(selected);
                },
                dropdownMenuEntries: [
                  for (final item in items)
                    DropdownMenuEntry<T>(
                      value: item.value,
                      label: item.label,
                      trailingIcon: item.meta == null
                          ? null
                          : Text(
                              item.meta!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
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

  /// Same 44 px height as [AppTextField]; red border when invalid.
  InputDecorationThemeData _decoration(BuildContext context, bool hasError) {
    final touchSearchable = searchable && context.usesTouchInput;
    final base = Theme.of(context).inputDecorationTheme.copyWith(
      constraints: const BoxConstraints.tightFor(height: AppSizes.inputHeight),
      // A searchable field has its own open/close button next to the text.
      // On touch it drops the menu's default 4 px inset so the button fills
      // the field height (a 44 px tap area) without changing the field.
      isCollapsed: touchSearchable ? true : null,
      suffixIconConstraints: touchSearchable
          ? const BoxConstraints.tightFor(
              width: AppSizes.minTouchTarget,
              height: AppSizes.minTouchTarget,
            )
          : null,
    );
    if (!hasError) return base;

    const errorBorder = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: AppColors.dangerFg),
    );
    return base.copyWith(
      enabledBorder: errorBorder,
      focusedBorder: errorBorder,
    );
  }
}

/// A [DropdownMenu] that shows the selected option's label even when the
/// options arrive after the first build (edit forms load departments and
/// designations asynchronously). DropdownMenu itself reads its selection
/// only once; rebuilding it instead would close a menu the user has open.
class _LabelSyncedDropdownMenu<T> extends StatefulWidget {
  const _LabelSyncedDropdownMenu({
    required this.value,
    required this.items,
    required this.initialSelection,
    required this.enabled,
    required this.hintText,
    required this.expandedInsets,
    required this.enableFilter,
    required this.enableSearch,
    required this.requestFocusOnTap,
    required this.menuHeight,
    required this.textStyle,
    required this.trailingIcon,
    required this.selectedTrailingIcon,
    required this.inputDecorationTheme,
    required this.onSelected,
    required this.dropdownMenuEntries,
  });

  final T? value;
  final List<AppDropdownItem<T>> items;
  final T? initialSelection;
  final bool enabled;
  final String? hintText;
  final EdgeInsets expandedInsets;
  final bool enableFilter;
  final bool enableSearch;
  final bool requestFocusOnTap;
  final double menuHeight;
  final TextStyle textStyle;
  final Widget trailingIcon;
  final Widget selectedTrailingIcon;
  final InputDecorationThemeData inputDecorationTheme;
  final ValueChanged<T?> onSelected;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;

  @override
  State<_LabelSyncedDropdownMenu<T>> createState() =>
      _LabelSyncedDropdownMenuState<T>();
}

class _LabelSyncedDropdownMenuState<T>
    extends State<_LabelSyncedDropdownMenu<T>> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(_LabelSyncedDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.items.length != oldWidget.items.length) {
      // After this frame: the menu listens to the controller.
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSelected());
    }
  }

  void _showSelected() {
    if (!mounted) return;
    final label = widget.items
        .where((item) => item.value == widget.value)
        .firstOrNull
        ?.label;
    if (label != null && _controller.text != label) _controller.text = label;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DropdownMenu<T>(
    controller: _controller,
    initialSelection: widget.initialSelection,
    enabled: widget.enabled,
    hintText: widget.hintText,
    expandedInsets: widget.expandedInsets,
    enableFilter: widget.enableFilter,
    enableSearch: widget.enableSearch,
    requestFocusOnTap: widget.requestFocusOnTap,
    menuHeight: widget.menuHeight,
    textStyle: widget.textStyle,
    trailingIcon: widget.trailingIcon,
    selectedTrailingIcon: widget.selectedTrailingIcon,
    inputDecorationTheme: widget.inputDecorationTheme,
    onSelected: widget.onSelected,
    dropdownMenuEntries: widget.dropdownMenuEntries,
  );
}
