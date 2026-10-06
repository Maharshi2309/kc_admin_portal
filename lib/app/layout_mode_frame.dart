import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';

/// Applies the person's [LayoutMode] to the whole app, in one place: it
/// tells the layout below which mode is chosen, and in mobile mode on a
/// screen wider than a phone shows the app in a phone-width column, so
/// every screen, dialog and menu uses its real phone layout.
class LayoutModeFrame extends ConsumerWidget {
  const LayoutModeFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(layoutModeProvider);
    final media = MediaQuery.of(context);
    final width = media.size.width;
    const column = LayoutMode.mobileColumnWidth;

    Widget app = LayoutModeScope(mode: mode, child: child);
    if (mode == LayoutMode.mobile && width > column) {
      app = ColoredBox(
        color: AppColors.surfaceSunken,
        child: Center(
          child: SizedBox(
            width: column,
            child: ClipRect(
              child: MediaQuery(
                data: media.copyWith(size: Size(column, media.size.height)),
                child: app,
              ),
            ),
          ),
        ),
      );
    }
    return app;
  }
}
