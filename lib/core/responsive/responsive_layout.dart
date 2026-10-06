import 'package:flutter/widgets.dart';

import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';

/// Builds a layout from the [ScreenSize] of the width available to this
/// widget (not the whole window), so it behaves correctly inside the
/// sidebar shell, split panes and dialogs.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({required this.builder, super.key});

  final Widget Function(
    BuildContext context,
    ScreenSize size,
    BoxConstraints constraints,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(
        context,
        // Desktop mode keeps desktop layouts in narrower spaces too.
        LayoutModeScope.of(context).apply(
          ScreenSize.fromWidth(constraints.maxWidth),
          MediaQuery.sizeOf(context).width,
        ),
        constraints,
      ),
    );
  }
}

/// Picks one of several builders by available width. Unset sizes fall back
/// to the next smaller one (see [ResponsiveValue]).
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    super.key,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final WidgetBuilder? largeDesktop;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size, _) => ResponsiveValue<WidgetBuilder>(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        largeDesktop: largeDesktop,
      ).resolve(size)(context),
    );
  }
}
