import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';

/// Dashboard headline number. The whole card opens its section, as in the
/// design ("View employees →").
class KpiCard extends StatelessWidget {
  const KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
    required this.actionLabel,
    required this.onTap,
    this.percent,
    this.valueText,
    this.caption,
    super.key,
  });

  final String label;
  final int value;
  final IconData icon;
  final StatusTone tone;
  final String actionLabel;

  /// Null when the role can't open the section: the card is not a link.
  final VoidCallback? onTap;

  /// Share of employees scheduled today, as sent by the backend; hidden
  /// when null.
  final double? percent;

  /// Shown instead of the counted [value], e.g. "42h 30m".
  final String? valueText;

  /// A short line under the value when the card is not a link, e.g.
  /// "8 employees".
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final percentText = percent == null
        ? ''
        : ', ${FormatUtils.percent(percent!)}';
    final shown = valueText ?? FormatUtils.count(value);

    return AppCard(
      onTap: onTap,
      semanticLabel:
          '$label: $shown$percentText${caption == null ? '' : ', $caption'}'
          '${onTap == null ? '' : '. $actionLabel'}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s14,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s8,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySemibold.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                _IconTile(icon: icon, tone: tone),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: AppSpacing.s10,
              children: [
                if (valueText == null)
                  Text(shown, style: AppTextStyles.kpiValue)
                else
                  // "42h 30m" shrinks a little on narrow cards rather than
                  // breaking over two lines.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(shown, style: AppTextStyles.kpiValue),
                  ),
                if (percent != null)
                  Text(
                    FormatUtils.percent(percent!),
                    style: AppTextStyles.bodyBold.copyWith(
                      color: tone == StatusTone.neutral
                          ? AppColors.textSecondary
                          : tone.foreground,
                    ),
                  ),
              ],
            ),
            if (onTap == null && caption != null)
              Text(
                caption!,
                style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
              ),
            if (onTap != null)
              Row(
                spacing: AppSpacing.s6,
                children: [
                  Flexible(child: Text(actionLabel, style: AppTextStyles.link)),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: AppSizes.iconSmall,
                    color: AppColors.primary,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.tone});

  final IconData icon;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.iconTile,
      height: AppSizes.iconTile,
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: AppRadius.lgAll,
      ),
      child: Icon(icon, size: AppSizes.icon, color: tone.foreground),
    );
  }
}
