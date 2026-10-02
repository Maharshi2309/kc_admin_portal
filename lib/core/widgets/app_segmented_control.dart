import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_focus.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// Grey track with a white "thumb" on the selected option
/// (Active/Inactive, Full day/Half day, Approved/Pending in the design).
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.semanticLabel,
    this.compact = false,
    super.key,
  });

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T>? onChanged;
  final String? semanticLabel;

  /// 32 px option height instead of 36.
  final bool compact;

  /// Space between the track and the options.
  static const double _inset = AppSpacing.s4;

  @override
  Widget build(BuildContext context) {
    // Compact options are too small to tap on touch platforms; the full
    // height plus the track inset gives a 44 px tap area.
    final optionHeight = compact && !context.usesTouchInput
        ? AppSizes.buttonHeightSmall
        : AppSizes.segmentHeight;
    final last = segments.length - 1;

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceSunken,
          borderRadius: AppRadius.mdAll,
        ),
        child: Row(
          children: [
            for (final (index, segment) in segments.indexed)
              Expanded(
                child: _SegmentButton(
                  label: segment.label,
                  height: optionHeight,
                  // The track inset is part of each option's tap area.
                  inset: EdgeInsetsDirectional.only(
                    start: index == 0 ? _inset : 0,
                    end: index == last ? _inset : 0,
                    top: _inset,
                    bottom: _inset,
                  ),
                  isSelected: segment.value == selected,
                  onTap: onChanged == null
                      ? null
                      : () => onChanged!(segment.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatefulWidget {
  const _SegmentButton({
    required this.label,
    required this.height,
    required this.inset,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final double height;
  final EdgeInsetsGeometry inset;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<_SegmentButton> createState() => _SegmentButtonState();
}

/// Reachable with Tab; Enter or Space selects it.
class _SegmentButtonState extends State<_SegmentButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onTap;
    final isSelected = widget.isSelected;

    return Semantics(
      button: true,
      selected: isSelected,
      child: FocusableActionDetector(
        enabled: onTap != null,
        mouseCursor: onTap == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: widget.inset,
            child: AnimatedContainer(
              duration: AppDurations.hover,
              height: widget.height,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : Colors.transparent,
                borderRadius: AppRadius.smAll,
                boxShadow: isSelected ? AppShadows.segmentThumb : const [],
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: AppRadius.smAll,
                border: AppFocus.border(focused: _focused),
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.buttonSmall.copyWith(
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
