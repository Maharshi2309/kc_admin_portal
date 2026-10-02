import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';

/// Shared content layout for dialogs and side sheets: header (title,
/// subtitle, close), scrollable body and a footer with an optional note on
/// the left and actions on the right.
class AppOverlayPanel extends StatelessWidget {
  const AppOverlayPanel({
    required this.title,
    required this.body,
    required this.onClose,
    this.subtitle,
    this.actions = const [],
    this.footerNote,
    this.expandBody = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final VoidCallback onClose;
  final List<Widget> actions;

  /// Small muted text in the footer, e.g. "Logged as: Admin · 28 Sep 2026".
  final String? footerNote;

  /// Fill all available height (full-screen dialogs, side sheets) instead of
  /// sizing to content.
  final bool expandBody;

  @override
  Widget build(BuildContext context) {
    final scrollBody = SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: body,
    );

    return Column(
      mainAxisSize: expandBody ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(title: title, subtitle: subtitle, onClose: onClose),
        if (expandBody)
          Expanded(child: scrollBody)
        else
          Flexible(child: scrollBody),
        if (actions.isNotEmpty || footerNote != null)
          _Footer(note: footerNote, actions: actions),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s24,
        AppSpacing.s20,
        AppSpacing.s16,
        AppSpacing.s16,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: AppTextStyles.headingSmall),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.close_rounded,
            tooltip: 'Close',
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.note, required this.actions});

  final String? note;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceChrome,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Wrap(
          // Actions sit on the right; with a note, the note takes the left.
          alignment: note == null
              ? WrapAlignment.end
              : WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.s12,
          runSpacing: AppSpacing.s12,
          children: [
            if (note != null)
              Text(
                note!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
