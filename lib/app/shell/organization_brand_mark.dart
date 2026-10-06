import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';
import 'package:kc_admin_portal/shared/widgets/organization_logo.dart';

/// The signed-in organization's logo and name, over "Admin Portal", at the
/// top of the sidebar, rail and phone bar (2026-10-06). Falls back to the
/// product mark when there is no organization (a server without them).
class OrganizationBrandMark extends ConsumerWidget {
  const OrganizationBrandMark({this.showName = true, super.key});

  final bool showName;

  static const double _nameSize = 15;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organization = ref.watch(
      authControllerProvider.select((auth) => auth.value?.organization),
    );
    if (organization == null) return BrandMark(showName: showName);

    final logo = OrganizationLogo(
      name: organization.name,
      logoUrl: organization.logoUrl,
    );
    if (!showName) return logo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s12,
      children: [
        logo,
        // Shrinks with an ellipsis in the narrow sidebar at large font sizes.
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                organization.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold.copyWith(fontSize: _nameSize),
              ),
              Text(
                'Admin Portal',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
