import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/responsive/app_breakpoints.dart';
import 'package:kc_admin_portal/core/responsive/layout_mode.dart';

/// A value that differs per [ScreenSize]. Unset sizes fall back to the next
/// smaller size that is set, so `ResponsiveValue(mobile: 1, desktop: 3)`
/// gives 1 on tablet and 3 on large desktop.
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  const ResponsiveValue.all(T value)
    : mobile = value,
      tablet = null,
      desktop = null,
      largeDesktop = null;

  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  T resolve(ScreenSize size) => switch (size) {
    ScreenSize.mobile => mobile,
    ScreenSize.tablet => tablet ?? mobile,
    ScreenSize.desktop => desktop ?? tablet ?? mobile,
    ScreenSize.largeDesktop => largeDesktop ?? desktop ?? tablet ?? mobile,
  };
}

/// Horizontal page padding per size (the design uses 32 px on desktop).
const ResponsiveValue<double> pagePaddingValue = ResponsiveValue(
  mobile: AppSpacing.s16,
  tablet: AppSpacing.s24,
  desktop: AppSpacing.s32,
);

/// Screen-level helpers based on the full window width.
///
/// Use these for app-wide decisions (navigation style, full-screen dialogs).
/// For a widget's own layout, prefer `ResponsiveBuilder`, which uses the
/// width actually available to it.
extension ResponsiveContext on BuildContext {
  /// The size class of the window, after the person's layout choice
  /// ([LayoutMode]).
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    return LayoutModeScope.of(this).apply(ScreenSize.fromWidth(width), width);
  }

  /// Android and iOS, including mobile browsers: compact controls get
  /// [AppSizes.minTouchTarget] tap areas.
  bool get usesTouchInput => switch (Theme.of(this).platform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => true,
    TargetPlatform.linux ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => false,
  };

  bool get isMobile => screenSize.isMobile;
  bool get isTablet => screenSize.isTablet;
  bool get isDesktop => screenSize.isDesktop;

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) => ResponsiveValue<T>(
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    largeDesktop: largeDesktop,
  ).resolve(screenSize);
}
