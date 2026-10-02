import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';

/// Circular initials avatar. The color is picked from the avatar palette by
/// the name, so the same person always gets the same color.
class AppAvatar extends StatelessWidget {
  const AppAvatar({required this.name, this.size = AppSizes.avatar, super.key});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colorsFor(name);

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Text(
          FormatUtils.initials(name),
          // Decorative and sized to the circle, so it ignores the system
          // font size (the name is always shown or announced alongside).
          textScaler: TextScaler.noScaling,
          style: AppTextStyles.captionBold.copyWith(
            color: foreground,
            // Initials scale with the avatar (13 px at 36 px, 22 px at 64 px).
            fontSize: size * 0.36,
          ),
        ),
      ),
    );
  }

  static (Color, Color) _colorsFor(String name) {
    const palette = AppColors.avatarPalette;
    final hash = name.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    return palette[hash % palette.length];
  }
}
