import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_focus.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// White rounded card with a hairline border.
///
/// With [onTap] the whole card is clickable and highlights on hover
/// (the dashboard KPI cards in the design). It is also reachable with Tab,
/// shows a focus outline, and opens with Enter or Space.
class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.onTap,
    this.semanticLabel,
    this.clip = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  /// Clips children to the rounded corners (cards containing tables).
  final bool clip;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;
    final highlighted = interactive && _hovered;

    final card = AnimatedContainer(
      duration: AppDurations.hover,
      clipBehavior: widget.clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(
          color: highlighted ? AppColors.primary : AppColors.border,
        ),
        boxShadow: highlighted ? AppShadows.cardHover : const [],
      ),
      // Drawn over the card so focusing never shifts its content.
      foregroundDecoration: BoxDecoration(
        borderRadius: AppRadius.cardAll,
        border: AppFocus.border(focused: interactive && _focused),
      ),
      child: Padding(padding: widget.padding, child: widget.child),
    );

    if (!interactive) return card;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap!();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: card,
        ),
      ),
    );
  }
}

/// Card with a header row (title, optional subtitle and trailing action such
/// as an [AppLink]) above its content.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.s24,
      vertical: AppSpacing.s20,
    ),
    this.gap = AppSpacing.s16,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Space between the header and the content.
  final double gap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(title, style: AppTextStyles.sectionTitle),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.s2),
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
              ?trailing,
            ],
          ),
          SizedBox(height: gap),
          child,
        ],
      ),
    );
  }
}
