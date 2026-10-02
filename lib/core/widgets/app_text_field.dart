import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// Labelled text input matching the design: label above, helper/error below,
/// a soft focus ring around the input box, optional prefix text (e.g. "+91")
/// and a locked (read-only) state.
///
/// Works inside a [Form]: [validator] runs on `FormState.validate()`.
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.isRequired = false,
    this.labelTrailing,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixText,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.large = false,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.monospace = false,
    super.key,
  });

  final String? label;
  final bool isRequired;
  final Widget? labelTrailing;
  final TextEditingController? controller;

  /// Used only when [controller] is null.
  final String? initialValue;
  final FocusNode? focusNode;
  final String? hintText;
  final String? helperText;

  /// Error from the server (e.g. "EC number already exists"). Shown in
  /// place of validator errors while set.
  final String? errorText;

  /// Fixed text before the input, separated by a divider (e.g. "+91").
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  /// Obscures the text and adds a show/hide toggle.
  final bool isPassword;

  /// Read-only "locked" look (grey background), e.g. a system-assigned value.
  final bool readOnly;
  final bool enabled;

  /// 48 px tall variant used on the login screen.
  final bool large;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;

  /// Renders the value in the mono font (EC numbers).
  final bool monospace;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  bool _obscured = true;
  bool _hasFocus = false;

  /// The [AppTextField.errorText] the user has since edited the text under.
  /// A server error (e.g. "name already exists") describes the old value, and
  /// while shown it also fails `validate()`, which would block saving again.
  String? _editedPastError;

  TextEditingController get _controller =>
      widget.controller ??
      (_ownedController ??= TextEditingController(text: widget.initialValue));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncFormValue);
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownedController)?.removeListener(
        _syncFormValue,
      );
      _controller.addListener(_syncFormValue);
      _syncFormValue();
    }
    if (widget.errorText != oldWidget.errorText) _editedPastError = null;
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocusNode)?.removeListener(
        _handleFocusChange,
      );
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_syncFormValue);
    _focusNode.removeListener(_handleFocusChange);
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  /// Keeps the form value in step with programmatic controller changes.
  void _syncFormValue() {
    final field = _fieldKey.currentState;
    if (field != null && field.value != _controller.text) {
      _markErrorEdited();
      field.didChange(_controller.text);
    }
  }

  void _markErrorEdited() {
    if (widget.errorText != null && _editedPastError != widget.errorText) {
      setState(() => _editedPastError = widget.errorText);
    }
  }

  void _handleFocusChange() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: _fieldKey,
      initialValue: _controller.text,
      validator: widget.validator,
      forceErrorText: widget.errorText == _editedPastError
          ? null
          : widget.errorText,
      enabled: widget.enabled,
      builder: (state) => AppLabeledField(
        label: widget.label,
        isRequired: widget.isRequired,
        trailing: widget.labelTrailing,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _FocusRing(
              visible: _hasFocus && widget.enabled && !widget.readOnly,
              child: _buildInput(state),
            ),
            AppFieldSubtext(
              errorText: state.errorText,
              helperText: widget.helperText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(FormFieldState<String> state) {
    final isLocked = widget.readOnly || !widget.enabled;
    final baseStyle = widget.monospace
        ? AppTextStyles.monoLarge
        : (widget.large ? AppTextStyles.inputLarge : AppTextStyles.input);
    final verticalPadding = widget.large ? AppSpacing.s14 : AppSpacing.s12;
    final borderColor = state.hasError
        ? AppColors.dangerFg
        : AppColors.borderStrong;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: (value) {
        _markErrorEdited();
        state.didChange(value);
        widget.onChanged?.call(value);
      },
      onSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      obscureText: widget.isPassword && _obscured,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      style: baseStyle.copyWith(
        color: isLocked ? AppColors.textSecondary : null,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        fillColor: widget.readOnly
            ? AppColors.surfaceLocked
            : (widget.enabled ? AppColors.surface : AppColors.surfaceDisabled),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: verticalPadding,
        ),
        enabledBorder: _border(borderColor),
        focusedBorder: _border(
          state.hasError ? AppColors.dangerFg : AppColors.primary,
        ),
        prefixIcon: _buildPrefix(),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: _buildSuffix(),
        suffixIconConstraints: const BoxConstraints(),
        counterText: '',
      ),
    );
  }

  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: AppRadius.mdAll,
    borderSide: BorderSide(color: color),
  );

  Widget? _buildPrefix() {
    if (widget.prefixText == null && widget.prefixIcon == null) return null;

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.prefixIcon != null)
            Icon(widget.prefixIcon, size: AppSizes.icon),
          if (widget.prefixText != null)
            Container(
              padding: const EdgeInsets.only(right: AppSpacing.s10),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppColors.border)),
              ),
              child: Text(
                widget.prefixText!,
                style: AppTextStyles.bodySemibold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.s10),
        ],
      ),
    );
  }

  Widget? _buildSuffix() {
    final passwordToggle = widget.isPassword
        ? AppIconButton(
            variant: AppIconButtonVariant.inField,
            onPressed: () => setState(() => _obscured = !_obscured),
            tooltip: _obscured ? 'Show password' : 'Hide password',
            icon: _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          )
        : null;
    final suffix = widget.suffix ?? passwordToggle;
    if (suffix == null) return null;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s6),
      child: suffix,
    );
  }
}

/// Soft brand-colored ring shown around a focused input box.
class _FocusRing extends StatelessWidget {
  const _FocusRing({required this.visible, required this.child});

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.hover,
      decoration: BoxDecoration(
        borderRadius: AppRadius.mdAll,
        boxShadow: visible ? AppShadows.focusRing : const [],
      ),
      child: child,
    );
  }
}
