import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

/// Keyboard focus indication (WCAG 2.4.7). Buttons draw a 2 px outline
/// only while focused from the keyboard; taps and clicks don't focus them.
abstract final class AppFocus {
  /// A button's border: [base] normally, the focus outline when focused.
  /// On filled (blue) buttons the outline is dark and drawn outside, so it
  /// stays visible against the button colour.
  static WidgetStateProperty<BorderSide?> side({
    BorderSide? base,
    bool onFilled = false,
  }) => WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.focused)
        ? BorderSide(
            color: onFilled ? AppColors.inverse : AppColors.primary,
            width: AppSizes.focusOutline,
            strokeAlign: onFilled
                ? BorderSide.strokeAlignOutside
                : BorderSide.strokeAlignInside,
          )
        : base,
  );

  /// Border for custom focusable widgets (cards, segments).
  static Border? border({required bool focused}) => focused
      ? Border.all(color: AppColors.primary, width: AppSizes.focusOutline)
      : null;
}
