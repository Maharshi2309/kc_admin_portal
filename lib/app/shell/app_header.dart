import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/shell/organization_time_note.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';

/// Top bar on tablet and desktop: global employee search and today's date
/// (with the organization's zone when the device is on another).
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the design also shows a
/// notifications bell, but no notifications are defined in the requirement
/// document, so it is left out.
class AppHeader extends ConsumerWidget {
  const AppHeader({
    required this.onSearchSubmitted,
    required this.searchFocusNode,
    super.key,
  });

  /// Called with the search text when the user presses Enter. Null hides
  /// the search (the role can't view employees).
  final ValueChanged<String>? onSearchSubmitted;
  final FocusNode searchFocusNode;

  static const double _searchMaxWidth = 420;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(clockProvider)();

    return Container(
      height: AppSizes.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
      decoration: const BoxDecoration(
        color: AppColors.surfaceChrome,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        spacing: AppSpacing.s16,
        children: [
          // Search takes up to its design width first; the date gets the rest.
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: onSearchSubmitted == null
                  ? null
                  : ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _searchMaxWidth,
                      ),
                      child: AppSearchField(
                        hintText: 'Search employee by name or EC number',
                        focusNode: searchFocusNode,
                        onChanged: (_) {},
                        onSubmitted: onSearchSubmitted,
                      ),
                    ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppSpacing.s2,
            children: [
              Text(
                AppDateFormat.long(today),
                style: AppTextStyles.smallSemibold.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const OrganizationTimeNote(),
            ],
          ),
        ],
      ),
    );
  }
}
