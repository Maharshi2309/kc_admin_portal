import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_focus_ring.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// Compact search input with a leading search icon and a clear button.
///
/// Debouncing belongs in the provider that receives [onChanged].
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.compact = false,
    this.autofocus = false,
    super.key,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  /// 36 px tall variant used inside table toolbars.
  final bool compact;
  final bool autofocus;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  TextEditingController? _ownedController;

  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final designHeight = widget.compact
        ? AppSizes.chipHeight
        : AppSizes.buttonHeight;
    final height = context.usesTouchInput
        ? math.max(designHeight, AppSizes.minTouchTarget)
        : designHeight;

    return AppFocusRing(
      child: SizedBox(
        height: height,
        child: TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          style: AppTextStyles.input,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.zero,
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: AppSizes.iconSmall,
            ),
            prefixIconConstraints: BoxConstraints.tight(Size.square(height)),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : AppIconButton(
                      variant: AppIconButtonVariant.inField,
                      onPressed: _clear,
                      tooltip: 'Clear search',
                      icon: Icons.close_rounded,
                    ),
            ),
            suffixIconConstraints: BoxConstraints.tight(Size.square(height)),
          ),
        ),
      ),
    );
  }
}
