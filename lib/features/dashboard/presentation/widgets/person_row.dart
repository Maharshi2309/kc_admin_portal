import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';

/// One person in a dashboard list: avatar, name, a subtitle and an optional
/// trailing badge or button, with a divider above.
class PersonRow extends StatelessWidget {
  const PersonRow({
    required this.name,
    required this.subtitle,
    this.subtitleIsMono = false,
    this.trailing,
    super.key,
  });

  final String name;
  final String subtitle;

  /// Subtitle starts with an EC number and uses the mono font.
  final bool subtitleIsMono;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        spacing: AppSpacing.s12,
        children: [
          AppAvatar(name: name, size: AppSizes.avatarSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySemibold,
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: subtitleIsMono
                      ? AppTextStyles.mono.copyWith(
                          fontSize: AppTextStyles.caption.fontSize,
                        )
                      : AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
