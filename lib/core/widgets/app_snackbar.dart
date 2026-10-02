import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';

enum SnackBarTone { info, success, error }

/// Shows a short confirmation or error message at the bottom of the screen.
void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarTone tone = SnackBarTone.info,
}) => showAppSnackBarOn(ScaffoldMessenger.of(context), message, tone: tone);

/// Same as [showAppSnackBar] for a messenger captured earlier, for messages
/// shown after an `await` when the calling widget may have been removed
/// (e.g. a table row that disappears once its employee is deactivated).
void showAppSnackBarOn(
  ScaffoldMessengerState messenger,
  String message, {
  SnackBarTone tone = SnackBarTone.info,
}) {
  final icon = switch (tone) {
    SnackBarTone.info => null,
    SnackBarTone.success => Icons.check_circle_rounded,
    SnackBarTone.error => Icons.error_rounded,
  };
  final iconColor = switch (tone) {
    SnackBarTone.error => AppColors.dangerBorder,
    _ => AppColors.successBg,
  };

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: AppDurations.snackBar,
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.icon, color: iconColor),
              const SizedBox(width: AppSpacing.s10),
            ],
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
