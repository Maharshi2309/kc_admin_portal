import 'package:flutter/painting.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';

/// Type scale from the design: Plus Jakarta Sans for UI text,
/// IBM Plex Mono for EC numbers.
///
/// Letter spacing in the design is given in `em`; the values here are the
/// equivalent logical pixels for each size.
abstract final class AppTextStyles {
  static const String fontFamily = 'PlusJakartaSans';
  static const String monoFontFamily = 'IBMPlexMono';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.textPrimary,
    fontWeight: regular,
  );

  // Display & numbers
  /// Login brand headline (44).
  static final TextStyle display = _base.copyWith(
    fontSize: 44,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.88,
  );

  /// KPI card value (36).
  static final TextStyle kpiValue = _base.copyWith(
    fontSize: 36,
    fontWeight: bold,
    height: 1,
    letterSpacing: -0.72,
  );

  /// Status tile / leave-used value (30).
  static final TextStyle statLarge = _base.copyWith(
    fontSize: 30,
    fontWeight: bold,
    height: 1,
    letterSpacing: -0.6,
  );

  /// Leave-balance card value (28).
  static final TextStyle statMedium = _base.copyWith(
    fontSize: 28,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.56,
  );

  /// Small inline statistic, e.g. "86.4%" (20).
  static final TextStyle statSmall = _base.copyWith(
    fontSize: 20,
    fontWeight: bold,
  );

  /// Profile / summary figures, e.g. "22 / 24" (18).
  static final TextStyle statXSmall = _base.copyWith(
    fontSize: 18,
    fontWeight: bold,
  );

  // Headings
  /// Login form title (28).
  static final TextStyle headingLarge = _base.copyWith(
    fontSize: 28,
    fontWeight: bold,
    letterSpacing: -0.28,
  );

  /// Page title (26).
  static final TextStyle pageTitle = _base.copyWith(
    fontSize: 26,
    fontWeight: bold,
    letterSpacing: -0.26,
  );

  /// Profile name, dialog title (24 / 20).
  static final TextStyle headingMedium = _base.copyWith(
    fontSize: 24,
    fontWeight: bold,
    letterSpacing: -0.24,
  );
  static final TextStyle headingSmall = _base.copyWith(
    fontSize: 20,
    fontWeight: bold,
  );

  /// Card / section title (16).
  static final TextStyle sectionTitle = _base.copyWith(
    fontSize: 16,
    fontWeight: bold,
  );

  // Body
  static final TextStyle bodyLarge = _base.copyWith(fontSize: 16, height: 1.6);
  static final TextStyle body = _base.copyWith(fontSize: 14, height: 1.4);
  static final TextStyle bodyMedium = body.copyWith(fontWeight: medium);
  static final TextStyle bodySemibold = body.copyWith(fontWeight: semibold);
  static final TextStyle bodyBold = body.copyWith(fontWeight: bold);

  static final TextStyle small = _base.copyWith(fontSize: 13, height: 1.4);
  static final TextStyle smallSemibold = small.copyWith(fontWeight: semibold);

  static final TextStyle caption = _base.copyWith(fontSize: 12, height: 1.4);
  static final TextStyle captionSemibold = caption.copyWith(
    fontWeight: semibold,
  );
  static final TextStyle captionBold = caption.copyWith(fontWeight: bold);

  /// Tiny calendar tags, e.g. "LATE" (10).
  static final TextStyle micro = _base.copyWith(fontSize: 10, fontWeight: bold);

  /// Uppercase section label, e.g. "IDENTITY" (12, tracked).
  static final TextStyle overline = _base.copyWith(
    fontSize: 12,
    fontWeight: bold,
    letterSpacing: 0.72,
    color: AppColors.textMuted,
  );

  /// Uppercase table column header (12, tracked).
  static final TextStyle tableHeader = _base.copyWith(
    fontSize: 12,
    fontWeight: bold,
    letterSpacing: 0.48,
    color: AppColors.textMuted,
  );

  // Controls
  static final TextStyle button = _base.copyWith(
    fontSize: 14,
    fontWeight: semibold,
    height: 1,
  );
  static final TextStyle buttonSmall = button.copyWith(fontSize: 13);
  static final TextStyle buttonLarge = button.copyWith(
    fontSize: 15,
    fontWeight: bold,
  );
  static final TextStyle input = _base.copyWith(
    fontSize: 14,
    fontWeight: medium,
  );
  static final TextStyle inputLarge = input.copyWith(fontSize: 15);
  static final TextStyle label = _base.copyWith(
    fontSize: 13,
    fontWeight: semibold,
  );
  static final TextStyle link = small.copyWith(
    fontWeight: semibold,
    color: AppColors.primary,
  );

  // Monospace (EC numbers)
  static const TextStyle mono = TextStyle(
    fontFamily: monoFontFamily,
    fontSize: 13,
    fontWeight: medium,
    color: AppColors.textSecondary,
  );
  static final TextStyle monoLarge = mono.copyWith(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
}
