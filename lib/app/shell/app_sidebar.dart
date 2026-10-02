import 'package:flutter/material.dart';

import 'package:kc_admin_portal/app/shell/nav_destinations.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/shared/widgets/brand_mark.dart';

/// Desktop sidebar from the design: brand, section links, and a slot at the
/// bottom for the signed-in admin (added with authentication in Phase 5).
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    this.footer,
    super.key,
  });

  /// The sections the signed-in user may open.
  final List<AppNavDestination> destinations;

  /// -1 when the current page is not a shown section.
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceChrome,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
              child: BrandMark(),
            ),
            const SizedBox(height: AppSpacing.s28),
            Semantics(
              container: true,
              explicitChildNodes: true,
              label: 'Main navigation',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.s4,
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _SidebarItem(
                      destination: destinations[i],
                      isSelected: i == selectedIndex,
                      onTap: () => onSelected(i),
                    ),
                ],
              ),
            ),
            const Spacer(),
            ?footer,
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? AppColors.primary : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? AppColors.primarySoft : Colors.transparent,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          hoverColor: isSelected ? Colors.transparent : AppColors.surfaceSunken,
          child: Container(
            height: AppSizes.navItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
            child: Row(
              spacing: AppSpacing.s12,
              children: [
                Icon(
                  isSelected ? destination.selectedIcon : destination.icon,
                  size: AppSizes.icon,
                  color: foreground,
                ),
                Expanded(
                  child: Text(
                    destination.label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySemibold.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
