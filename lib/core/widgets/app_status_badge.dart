import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

/// Visual tones for status pills. Features map their own statuses
/// (attendance, leave, employee) to a tone; this widget knows no statuses.
enum StatusTone {
  success(AppColors.successBg, AppColors.successFg),
  danger(AppColors.dangerBg, AppColors.dangerFg),
  warning(AppColors.warningBg, AppColors.warningFg),
  late(AppColors.lateBg, AppColors.lateFg),
  halfDay(AppColors.halfDayBg, AppColors.halfDayFg),
  offDayWorked(AppColors.offDayWorkedBg, AppColors.offDayWorkedFg),
  info(AppColors.primarySoft, AppColors.primary),
  neutral(AppColors.neutralBg, AppColors.neutralFg),
  inverse(AppColors.inverse, AppColors.onPrimary);

  const StatusTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    required this.label,
    required this.tone,
    this.showDot = false,
    super.key,
  });

  final String label;
  final StatusTone tone;

  /// Leading dot, used for live/daily status ("● Present").
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.badgeHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s10),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: AppSizes.badgeDot,
              height: AppSizes.badgeDot,
              decoration: BoxDecoration(
                color: tone.foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.s6),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionSemibold.copyWith(
                color: tone.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
