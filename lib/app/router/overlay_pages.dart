import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/widgets/app_side_sheet.dart';

final Color _barrierColor = AppColors.inverse.withValues(alpha: 0.4);

/// A route shown as a dialog over the previous page (e.g.
/// `/attendance/:id/edit`). Having its own URL means deep links and the
/// browser back button work. [child] is usually an `AppDialog`, which goes
/// full screen on phones by itself.
class DialogPage<T> extends CustomTransitionPage<T> {
  DialogPage({required super.child, super.key, super.name})
    : super(
        opaque: false,
        barrierDismissible: true,
        barrierColor: _barrierColor,
        barrierLabel: 'Close dialog',
        transitionDuration: AppDurations.sheet,
        reverseTransitionDuration: AppDurations.sheet,
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        ),
      );
}

/// A route shown as a side sheet sliding in from the right (e.g.
/// `/leave/add`). [child] is usually an `AppSideSheet`.
class SideSheetPage<T> extends CustomTransitionPage<T> {
  SideSheetPage({required super.child, super.key, super.name})
    : super(
        opaque: false,
        barrierDismissible: true,
        barrierColor: _barrierColor,
        barrierLabel: 'Close panel',
        transitionDuration: AppDurations.sheet,
        reverseTransitionDuration: AppDurations.sheet,
        transitionsBuilder: (context, animation, _, child) =>
            buildSideSheetTransition(context, animation, child),
      );
}
