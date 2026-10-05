import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

/// Rounded horizontal bar (leave balance, hours worked).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.value,
    this.thick = false,
    this.color = AppColors.primary,
    this.semanticLabel,
    super.key,
  });

  /// Fraction between 0 and 1; values outside are clamped.
  final double value;
  final bool thick;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final height = thick ? AppSizes.progressThick : AppSizes.progressThin;

    return ClipRRect(
      borderRadius: AppRadius.pillAll,
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        color: color,
        backgroundColor: AppColors.divider,
        borderRadius: AppRadius.pillAll,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
