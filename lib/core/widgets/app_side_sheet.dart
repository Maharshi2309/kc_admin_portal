import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/widgets/app_overlay_panel.dart';

/// Panel that slides in from the right (e.g. "Add leave" in the design).
/// Takes the full width on screens narrower than [AppSizes.sideSheetWidth].
class AppSideSheet extends StatelessWidget {
  const AppSideSheet({
    required this.title,
    required this.body,
    this.subtitle,
    this.actions = const [],
    this.footerNote,
    this.onClose,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final List<Widget> actions;
  final String? footerNote;

  /// Defaults to closing the sheet.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final width = math.min(AppSizes.sideSheetWidth, screenWidth);

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        width: width,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: AppShadows.sideSheet,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            left: false,
            bottom: false,
            child: AppOverlayPanel(
              title: title,
              subtitle: subtitle,
              body: body,
              actions: actions,
              footerNote: footerNote,
              expandBody: true,
              onClose: onClose ?? () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens an [AppSideSheet] (returned by [builder]) with a slide-in animation.
Future<T?> showAppSideSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String barrierLabel = 'Close panel',
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: AppColors.inverse.withValues(alpha: 0.4),
    transitionDuration: AppDurations.sheet,
    pageBuilder: (context, _, _) => builder(context),
    transitionBuilder: (context, animation, _, child) =>
        buildSideSheetTransition(context, animation, child),
  );
}

/// Slide-in from the trailing edge, shared by [showAppSideSheet] and the
/// side-sheet route page.
Widget buildSideSheetTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  return SlideTransition(
    position: Tween<Offset>(
      begin: Offset(isRtl ? -1 : 1, 0),
      end: Offset.zero,
    ).animate(curved),
    child: child,
  );
}
