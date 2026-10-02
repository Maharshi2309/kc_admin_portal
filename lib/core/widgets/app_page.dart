import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/responsive_layout.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';

/// Scrollable page content with responsive padding. Content is centered and
/// never wider than [maxWidth], so pages stay readable on wide monitors.
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    required this.children,
    this.maxWidth = AppBreakpoints.maxContentWidth,
    this.spacing = AppSpacing.s20,
    this.controller,
    super.key,
  });

  final List<Widget> children;
  final double maxWidth;

  /// Vertical gap between [children].
  final double spacing;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size, _) {
        final padding = pagePaddingValue.resolve(size);

        return SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: size.isMobile ? AppSpacing.s16 : AppSpacing.s28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: spacing,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Page title block: optional breadcrumb, title, subtitle and actions.
/// Actions sit on the right on wide screens and wrap below the title on phones.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    this.subtitle,
    this.breadcrumb,
    this.actions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? breadcrumb;
  final List<Widget> actions;

  static const double _maxActionsShare = 0.6;

  @override
  Widget build(BuildContext context) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (breadcrumb != null) ...[
          breadcrumb!,
          const SizedBox(height: AppSpacing.s6),
        ],
        Semantics(
          header: true,
          child: Text(title, style: AppTextStyles.pageTitle),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(
            subtitle!,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
        ],
      ],
    );
    if (actions.isEmpty) return titleBlock;

    final actionBar = Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSpacing.s12,
      runSpacing: AppSpacing.s8,
      children: actions,
    );

    return ResponsiveBuilder(
      builder: (context, size, constraints) => size.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s16,
              children: [titleBlock, actionBar],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: AppSpacing.s16,
              children: [
                Expanded(child: titleBlock),
                // Actions keep their natural width; past this share of the
                // row they wrap instead of squeezing the title.
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * _maxActionsShare,
                  ),
                  child: actionBar,
                ),
              ],
            ),
    );
  }
}
