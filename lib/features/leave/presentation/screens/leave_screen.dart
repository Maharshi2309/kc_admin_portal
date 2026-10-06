import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/router/route_permissions.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_date_range_filter.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/features/leave/presentation/widgets/leave_balances_view.dart';
import 'package:kc_admin_portal/features/leave/presentation/widgets/leave_status_tabs.dart';
import 'package:kc_admin_portal/features/leave/presentation/widgets/leave_table.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/widgets/catalog_filter_dropdown.dart';

/// The Leave page's two tabs (requirement 2026-10-05).
enum LeaveView {
  requests('Requests'),
  balances('Balances');

  const LeaveView(this.label);

  final String label;

  /// `?view=balances`; anything else is Requests.
  static LeaveView fromQuery(String? value) =>
      value == balances.name ? balances : requests;
}

/// Leave for all employees (design board 08). Requests: status tabs,
/// filters, approval of pending requests, and the Add leave drawer.
/// Balances: each active employee's Casual balance, with totals.
class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({this.view = LeaveView.requests, super.key});

  final LeaveView view;

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  late final TextEditingController _search;

  static const double _searchMaxWidth = 300;
  static const double _viewSwitchWidth = 280;
  static const double _progressLineHeight = 2;

  /// How far back and ahead the date filter reaches.
  static const int _filterYearsBack = 5;
  static const int _filterYearsAhead = 1;

  @override
  void initState() {
    super.initState();
    // Created up front: on the Balances tab nothing else reads it, and
    // dispose() can't use ref.
    _search = TextEditingController(text: ref.read(leaveQueryProvider).search);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    ref.read(leaveQueryProvider.notifier).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Leaves',
          subtitle: 'Leave records, balances and status for all employees',
          actions: [
            if (canOpenRoute(AppRouteNames.leaveAdd, ref.watch(grantsProvider)))
              AppButton(
                label: 'Add leave',
                icon: Icons.add_rounded,
                onPressed: () => context.goNamed(AppRouteNames.leaveAdd),
              ),
          ],
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: _viewSwitchWidth,
            child: AppSegmentedControl<LeaveView>(
              semanticLabel: 'Leave view',
              selected: widget.view,
              onChanged: (view) => context.goNamed(
                AppRouteNames.leave,
                queryParameters: {
                  if (view == LeaveView.balances)
                    AppRouteParams.view: view.name,
                },
              ),
              segments: [
                for (final view in LeaveView.values)
                  AppSegment(value: view, label: view.label),
              ],
            ),
          ),
        ),
        switch (widget.view) {
          LeaveView.requests => _requests(context),
          LeaveView.balances => const LeaveBalancesView(),
        },
      ],
    );
  }

  Widget _requests(BuildContext context) {
    final query = ref.watch(leaveQueryProvider);
    final notifier = ref.read(leaveQueryProvider.notifier);
    final list = ref.watch(leaveListProvider);
    final types = ref.watch(leaveTypesProvider).value ?? const [];
    final today = ref.watch(clockProvider)();

    return AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (list.value case final data?)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s12,
                AppSpacing.s16,
                0,
              ),
              child: LeaveStatusTabs(
                counts: data.counts,
                selected: query.status,
                onSelected: notifier.setStatus,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Wrap(
              spacing: AppSpacing.s10,
              runSpacing: AppSpacing.s10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _searchMaxWidth),
                  child: AppSearchField(
                    hintText: 'Employee name or EC number',
                    compact: true,
                    controller: _search,
                    onChanged: notifier.setSearch,
                    onSubmitted: notifier.applySearch,
                  ),
                ),
                AppDateRangeFilter(
                  from: query.from,
                  to: query.to,
                  firstDate: DateTime(today.year - _filterYearsBack),
                  lastDate: DateTime(today.year + _filterYearsAhead, 12, 31),
                  onChanged: notifier.setDateRange,
                ),
                AppFilterDropdown<String>(
                  label: 'Leave type',
                  value: query.leaveTypeId,
                  onChanged: notifier.setLeaveType,
                  items: [
                    for (final t in types)
                      AppDropdownItem(value: t.id, label: t.name),
                  ],
                ),
                CatalogFilterDropdown(
                  kind: CatalogKind.departments,
                  value: query.departmentId,
                  onChanged: notifier.setDepartment,
                ),
                if (query.hasFilters)
                  AppButton(
                    label: 'Clear filters',
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.small,
                    onPressed: _clearFilters,
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
          AsyncValueView<LeaveListModel>(
            value: list,
            onRetry: () => ref.invalidate(leaveListProvider),
            isEmpty: (data) => data.items.isEmpty,
            empty: AppEmptyView(
              icon: Icons.event_available_outlined,
              title: query.hasFilters
                  ? 'No leave matches these filters'
                  : 'No leave records here yet',
              action: query.hasFilters
                  ? AppButton(
                      label: 'Clear filters',
                      variant: AppButtonVariant.secondary,
                      onPressed: _clearFilters,
                    )
                  : null,
            ),
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LeaveTable(leaves: data.items),
                AppPagination(
                  page: data.page,
                  pageSize: data.pageSize,
                  totalItems: data.total,
                  onPageChanged: notifier.setPage,
                  onPageSizeChanged: notifier.setPageSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
