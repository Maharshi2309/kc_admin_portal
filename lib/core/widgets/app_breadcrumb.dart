import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';

class AppBreadcrumbItem {
  const AppBreadcrumbItem(this.label, {this.onTap});

  final String label;

  /// `null` for the current page (rendered muted, not clickable).
  final VoidCallback? onTap;
}

/// "Employees / Add employee" trail above page titles.
class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({required this.items, super.key});

  final List<AppBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.smallSemibold.copyWith(
      color: AppColors.textMuted,
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.s8,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Text('/', style: muted),
          if (items[i].onTap == null)
            Text(items[i].label, style: muted)
          else
            Semantics(
              link: true,
              child: InkWell(
                onTap: items[i].onTap,
                borderRadius: AppRadius.smAll,
                child: Text(items[i].label, style: AppTextStyles.link),
              ),
            ),
        ],
      ],
    );
  }
}
