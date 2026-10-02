import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/holidays/presentation/providers/holiday_providers.dart';
import 'package:kc_admin_portal/features/holidays/presentation/widgets/holiday_table.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// Company holidays by year. A holiday applies to every employee: nobody is
/// marked absent on it, and it isn't counted in leave days.
class HolidaysScreen extends ConsumerStatefulWidget {
  const HolidaysScreen({super.key});

  @override
  ConsumerState<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends ConsumerState<HolidaysScreen> {
  late final _search = TextEditingController(
    text: ref.read(holidayQueryProvider).search,
  );

  static const double _searchMaxWidth = 300;
  static const double _progressLineHeight = 2;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(holidayQueryProvider);
    final notifier = ref.read(holidayQueryProvider.notifier);
    final list = ref.watch(holidayListProvider);
    final count = list.value?.length;

    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Holidays',
          subtitle:
              'Company holidays apply to every employee. Nobody is marked '
              'absent on a holiday.',
          actions: [
            if (ref.can(AppPermission.holidayCreate))
              AppButton(
                label: 'Add holiday',
                icon: Icons.add_rounded,
                onPressed: () => context.goNamed(AppRouteNames.holidayAdd),
              ),
          ],
        ),
        AppCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Wrap(
                  spacing: AppSpacing.s16,
                  runSpacing: AppSpacing.s10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _YearSwitcher(
                      year: query.year,
                      onPrevious: notifier.previousYear,
                      onNext: notifier.nextYear,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _searchMaxWidth,
                      ),
                      child: AppSearchField(
                        hintText: 'Holiday name',
                        compact: true,
                        controller: _search,
                        onChanged: notifier.setSearch,
                        onSubmitted: notifier.applySearch,
                      ),
                    ),
                    if (count != null)
                      Text(
                        count == 1 ? '1 holiday' : '$count holidays',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: _progressLineHeight,
                child: list.isLoading && list.hasValue
                    ? const LinearProgressIndicator()
                    : const Divider(height: 1, color: AppColors.border),
              ),
              AsyncValueView<List<HolidayModel>>(
                value: list,
                onRetry: () => ref.invalidate(holidayListProvider),
                isEmpty: (items) => items.isEmpty,
                empty: AppEmptyView(
                  icon: Icons.event_available_outlined,
                  title: query.search.isEmpty
                      ? 'No holidays in ${query.year}'
                      : 'No holidays match "${query.search}"',
                  action: query.search.isEmpty
                      ? !ref.can(AppPermission.holidayCreate)
                            ? null
                            : AppButton(
                                label: 'Add holiday',
                                variant: AppButtonVariant.secondary,
                                onPressed: () =>
                                    context.goNamed(AppRouteNames.holidayAdd),
                              )
                      : AppButton(
                          label: 'Clear search',
                          variant: AppButtonVariant.secondary,
                          onPressed: () {
                            _search.clear();
                            notifier.applySearch('');
                          },
                        ),
                ),
                data: (items) => HolidayTable(holidays: items),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "‹ 2026 ›".
class _YearSwitcher extends StatelessWidget {
  const _YearSwitcher({
    required this.year,
    required this.onPrevious,
    required this.onNext,
  });

  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s8,
      children: [
        AppIconButton(
          icon: Icons.chevron_left_rounded,
          tooltip: 'Previous year',
          bordered: true,
          onPressed: onPrevious,
        ),
        Semantics(
          liveRegion: true,
          child: Text('$year', style: AppTextStyles.bodyBold),
        ),
        AppIconButton(
          icon: Icons.chevron_right_rounded,
          tooltip: 'Next year',
          bordered: true,
          onPressed: onNext,
        ),
      ],
    );
  }
}
