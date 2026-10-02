/// Width classes used for every responsive decision in the app.
enum ScreenSize {
  /// < 600: phones. Bottom navigation, single column, list items instead of tables.
  mobile,

  /// 600 – 1023: tablets, small laptop windows. Navigation rail, two columns.
  tablet,

  /// 1024 – 1439: laptops. Full sidebar, layouts as in the design.
  desktop,

  /// ≥ 1440: large monitors. Same as desktop, content width capped.
  largeDesktop;

  static ScreenSize fromWidth(double width) {
    if (width >= AppBreakpoints.largeDesktop) return largeDesktop;
    if (width >= AppBreakpoints.desktop) return desktop;
    if (width >= AppBreakpoints.tablet) return tablet;
    return mobile;
  }

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;

  /// Desktop or large desktop.
  bool get isDesktop => index >= desktop.index;

  bool isAtLeast(ScreenSize other) => index >= other.index;
}

/// The only place breakpoint numbers are defined.
///
/// - 600: Material's compact/medium boundary; below it two form columns or a
///   table no longer fit.
/// - 1024: smallest width where the 248 px sidebar still leaves room for the
///   design's 4-card KPI row and main tables.
/// - 1440: width of the design canvas; above it content stops growing.
abstract final class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;

  /// Page content never grows wider than this; extra space is split evenly
  /// on both sides.
  static const double maxContentWidth = 1440;

  /// Maximum width of single-form pages (add/edit screens).
  static const double maxFormWidth = 1120;
}
