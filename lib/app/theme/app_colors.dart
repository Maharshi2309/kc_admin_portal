import 'package:flutter/painting.dart';

/// Color tokens taken from the Keshav Admin design canvas.
///
/// Widgets must use these tokens (or the [ThemeData] built from them),
/// never raw hex values.
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFFF4F5F2);
  static const Color surface = Color(0xFFFFFFFF);

  /// Sidebar, header and sticky footer bars.
  static const Color surfaceChrome = Color(0xFFFBFBF9);

  /// Table header background.
  static const Color surfaceSubtle = Color(0xFFFAFAF8);

  /// Table row hover.
  static const Color surfaceHover = Color(0xFFFAFBFD);

  /// Segmented-control track, nav item hover.
  static const Color surfaceSunken = Color(0xFFECEEEA);

  /// Read-only ("locked") inputs.
  static const Color surfaceLocked = Color(0xFFF4F5F2);

  /// Disabled inputs.
  static const Color surfaceDisabled = Color(0xFFF7F7F5);

  // Inverse (login brand panel, count badges)
  static const Color inverse = Color(0xFF16181D);
  static const Color onInverse = Color(0xFFF4F5F2);
  static const Color onInverseMuted = Color(0xFFB9BDC6);
  static const Color onInverseSubtle = Color(0xFF8D929C);

  // Text
  static const Color textPrimary = Color(0xFF16181D);
  static const Color textSecondary = Color(0xFF4A505C);
  static const Color textMuted = Color(0xFF5B616E);
  static const Color textDisabled = Color(0xFF8D929C);
  static const Color textPlaceholder = Color(0xFFA5AAB3);

  // Lines
  static const Color border = Color(0xFFE4E6EA);
  static const Color borderStrong = Color(0xFFD9DCE1);
  static const Color divider = Color(0xFFEEEFF1);
  static const Color chartAxis = Color(0xFFC9CDD3);

  /// Regular chart bars. Darker than the design's #9DB4EC so bars reach the
  /// 3:1 graphic contrast against white (validated: 3.0:1), while staying
  /// clearly distinct from [chartBarHighlight] (ΔE 19).
  static const Color chartBar = Color(0xFF6E8BDA);

  /// The emphasised bar (today).
  static const Color chartBarHighlight = primary;

  // Brand
  static const Color primary = Color(0xFF1D4FC4);
  static const Color primaryHover = Color(0xFF163C96);
  static const Color primarySoft = Color(0xFFE7EDFB);
  static const Color primarySubtle = Color(0xFFF7F9FE);
  static const Color primaryMuted = Color(0xFF9DB4EC);
  static const Color focusRing = Color(0xFFD5E0FA);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Status tones: background / foreground pairs
  static const Color successBg = Color(0xFFE3F3EA);
  static const Color successFg = Color(0xFF17603D);
  static const Color dangerBg = Color(0xFFFCE9E7);
  static const Color dangerFg = Color(0xFFA6281A);
  static const Color warningBg = Color(0xFFFDF1DD);
  static const Color warningFg = Color(0xFF8A4B06);
  static const Color lateBg = Color(0xFFFFF0E0);
  static const Color lateFg = Color(0xFF9A4A00);
  static const Color halfDayBg = Color(0xFFEEE8FA);
  static const Color halfDayFg = Color(0xFF5B35A8);

  /// Work on a holiday or weekly off (teal; 5.9:1 text contrast).
  static const Color offDayWorkedBg = Color(0xFFDDF3EF);
  static const Color offDayWorkedFg = Color(0xFF0D6458);
  static const Color neutralBg = Color(0xFFEEEFF1);
  static const Color neutralFg = Color(0xFF4A505C);

  // Status swatches (small dots on filter tiles)
  static const Color successSwatch = Color(0xFF1E7B4F);
  static const Color lateSwatch = Color(0xFFC76A00);
  static const Color warningSwatch = Color(0xFFD99A2B);
  static const Color dangerSwatch = Color(0xFFC4321F);

  // Alert banner
  static const Color dangerSurface = Color(0xFFFFF6F4);
  static const Color dangerBorder = Color(0xFFF3CFC9);

  /// Initials-avatar palette as (background, foreground) pairs.
  static const List<(Color, Color)> avatarPalette = [
    (primarySoft, primary),
    (warningBg, warningFg),
    (successBg, successFg),
    (halfDayBg, halfDayFg),
    (dangerBg, dangerFg),
  ];
}
