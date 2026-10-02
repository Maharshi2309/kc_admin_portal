import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';

/// Sticky bar at the bottom of a form page: a hint on the left
/// ("* Required · 2 fields left") and the actions on the right.
///
/// The **last** action is the primary one. On phone widths the bar stays
/// short: the hint takes at most two lines and the buttons fill the width
/// (secondary actions side by side, the primary one full width below when
/// there are more than two). With large text the buttons stack.
class FormFooterBar extends StatelessWidget {
  const FormFooterBar({required this.actions, this.hint, super.key});

  final String? hint;
  final List<Widget> actions;

  static const int _compactHintLines = 2;

  /// Below this width (at normal text size) buttons side by side would cut
  /// their labels, so they stack.
  static const double _sideBySideMinWidth = 300;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.footerBarHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceChrome,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth < AppBreakpoints.tablet
              ? _compact(
                  stack:
                      constraints.maxWidth <
                      MediaQuery.textScalerOf(
                        context,
                      ).scale(_sideBySideMinWidth),
                )
              : _wide(),
        ),
      ),
    );
  }

  Widget _hintText({int? maxLines}) => Text(
    hint!,
    maxLines: maxLines,
    overflow: maxLines == null ? null : TextOverflow.ellipsis,
    style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
  );

  Widget _wide() => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: AppSpacing.s12,
    runSpacing: AppSpacing.s12,
    children: [
      if (hint != null) _hintText(),
      OverflowBar(
        spacing: AppSpacing.s12,
        overflowSpacing: AppSpacing.s8,
        overflowAlignment: OverflowBarAlignment.end,
        children: actions,
      ),
    ],
  );

  Widget _compact({required bool stack}) {
    Widget row(List<Widget> buttons) => Row(
      spacing: AppSpacing.s8,
      children: [for (final button in buttons) Expanded(child: button)],
    );
    final splitPrimary = actions.length > 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s8,
      children: [
        if (hint != null) _hintText(maxLines: _compactHintLines),
        if (stack)
          ...actions
        else if (splitPrimary) ...[
          row(actions.sublist(0, actions.length - 1)),
          actions.last,
        ] else
          row(actions),
      ],
    );
  }
}
