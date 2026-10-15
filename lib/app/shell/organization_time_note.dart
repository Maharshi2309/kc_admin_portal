import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/models/time_zones.dart';

/// "Times in India (UTC+5:30)": shown only when this device's clock is on
/// another offset than the organization, so someone travelling (or an
/// organization elsewhere) isn't misled by the times on screen.
///
/// [banner]: a full-width strip (phones); otherwise a line of small text
/// (the header, under today's date).
class OrganizationTimeNote extends ConsumerWidget {
  const OrganizationTimeNote({this.banner = false, super.key});

  final bool banner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zone = ref.watch(activeTimeZoneProvider);
    final device = ref.watch(deviceUtcOffsetProvider)();
    final organization = CompanyTime.currentOffset;
    if (device == organization) return const SizedBox.shrink();

    final text =
        'Times in ${timeZoneShortName(zone)} (${utcOffsetLabel(organization)})';
    final style = AppTextStyles.caption.copyWith(color: AppColors.primary);
    final content = Row(
      mainAxisSize: banner ? MainAxisSize.max : MainAxisSize.min,
      spacing: AppSpacing.s6,
      children: [
        const Icon(
          Icons.public_rounded,
          size: AppSizes.iconSmall,
          color: AppColors.primary,
        ),
        Flexible(child: Text(text, style: style)),
      ],
    );
    return Tooltip(
      message:
          "Dates and times follow the organization's time zone. "
          'Your device is on ${utcOffsetLabel(device)}.',
      child: banner
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s6,
              ),
              color: AppColors.primarySoft,
              child: content,
            )
          : content,
    );
  }
}
