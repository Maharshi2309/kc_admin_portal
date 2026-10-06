import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/ec_number_text.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/organization/presentation/widgets/catalog_filter_dropdown.dart';

/// The Leave page's Balances tab: totals for the filtered employees, then
/// each active employee's Casual balance and Unpaid days (requirement
/// 2026-10-05). Every figure comes from `GET /leave-balances`.
class LeaveBalancesView extends ConsumerStatefulWidget {
  const LeaveBalancesView({super.key});

  @override
  ConsumerState<LeaveBalancesView> createState() => _LeaveBalancesViewState();
}

class _LeaveBalancesViewState extends ConsumerState<LeaveBalancesView> {
  late final _search = TextEditingController(
    text: ref.read(leaveBalanceQueryProvider).search,
  );

  static const double _searchMaxWidth = 300;
  static const double _progressLineHeight = 2;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    ref.read(leaveBalanceQueryProvider.notifier).clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(leaveBalanceQueryProvider);
    final notifier = ref.read(leaveBalanceQueryProvider.notifier);
    final list = ref.watch(leaveBalanceListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s16,
      children: [
        if (!ref.watch(paidLeaveEnabledProvider))
          const AppAlertBanner(
            tone: AlertTone.info,
            title: 'No paid leave in this organization',
            message:
                'Only unpaid leave is used, so there are no balances. Paid '
                'leave can be turned on in Settings.',
          )
        else if (list.value case final data?)
          LeaveBalanceSummary(totals: data.summary, filtered: query.hasFilters),
        AppCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Wrap(
                  spacing: AppSpacing.s10,
                  runSpacing: AppSpacing.s10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _searchMaxWidth,
                      ),
                      child: AppSearchField(
                        hintText: 'Employee name or EC number',
                        compact: true,
                        controller: _search,
                        onChanged: notifier.setSearch,
                        onSubmitted: notifier.applySearch,
                      ),
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
              AsyncValueView<LeaveBalanceListModel>(
                value: list,
                onRetry: () => ref.invalidate(leaveBalanceListProvider),
                isEmpty: (data) => data.items.isEmpty,
                empty: AppEmptyView(
                  icon: Icons.event_available_outlined,
                  title: query.hasFilters
                      ? 'No employees match these filters'
                      : 'No active employees yet',
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
                    _BalanceTable(rows: data.items),
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
        ),
      ],
    );
  }
}

/// "Casual earned · used · remaining · Unpaid taken" totals for every
/// employee matching the filters, with the organization's type names.
class LeaveBalanceSummary extends ConsumerWidget {
  const LeaveBalanceSummary({
    required this.totals,
    required this.filtered,
    super.key,
  });

  final LeaveBalanceTotalsModel totals;

  /// Whether the totals are for filtered employees only.
  final bool filtered;

  static const double _minTileWidth = 170;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paid = ref.watch(paidLeaveNameProvider);
    final unpaid = ref.watch(unpaidLeaveNameProvider);
    final perMonth = ref.watch(leavePolicyProvider).value?.daysPerMonth;
    final n = totals.employees;
    final who = '${FormatUtils.count(n)} active employee${n == 1 ? '' : 's'}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s8,
      children: [
        Text(
          filtered ? 'Totals for $who matching the filters' : 'Totals for $who',
          style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
        ),
        ResponsiveGrid(
          minItemWidth: _minTileWidth,
          spacing: AppSpacing.s12,
          children: [
            _SummaryTile(
              label: '$paid earned',
              value: totals.accrued,
              note: perMonth == null
                  ? 'Earned every month'
                  : '${FormatUtils.days(perMonth)} a month each',
            ),
            _SummaryTile(
              label: '$paid used',
              value: totals.used,
              note: totals.pending > 0
                  ? '+ ${FormatUtils.days(totals.pending)} pending'
                  : 'Approved leave',
            ),
            _SummaryTile(
              label: '$paid remaining',
              value: totals.remaining,
              note: 'Earned − used − pending',
              highlight: true,
            ),
            _SummaryTile(
              label: '$unpaid taken',
              value: totals.unpaidTaken,
              note: 'No fixed balance',
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.note,
    this.highlight = false,
  });

  final String label;
  final double value;
  final String note;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    return Semantics(
      container: true,
      label: '$label: ${FormatUtils.days(value)}, $note',
      excludeSemantics: true,
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s18,
          vertical: AppSpacing.s14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s4,
          children: [
            Text(label, style: AppTextStyles.smallSemibold),
            Text(
              FormatUtils.days(value),
              style: AppTextStyles.statSmall.copyWith(
                color: highlight ? AppColors.primary : null,
              ),
            ),
            Text(note, style: muted),
          ],
        ),
      ),
    );
  }
}

/// One row per active employee; tapping opens the profile.
class _BalanceTable extends ConsumerWidget {
  const _BalanceTable({required this.rows});

  final List<EmployeeLeaveBalanceModel> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canOpen = ref.can(AppPermission.employeeView);
    String days(double value) => FormatUtils.count(value);

    return ResponsiveDataView<EmployeeLeaveBalanceModel>(
      rows: rows,
      rowKey: (r) => r.employee.id,
      onRowTap: canOpen
          ? (r) => context.goNamed(
              AppRouteNames.employeeProfile,
              pathParameters: {AppRouteParams.id: r.employee.id},
            )
          : null,
      mobileItemBuilder: (context, r) => _MobileItem(row: r),
      columns: [
        AppDataColumn(
          label: 'Employee',
          flex: 2,
          minWidth: 200,
          cellBuilder: (context, r) => Row(
            spacing: AppSpacing.s10,
            children: [
              AppAvatar(name: r.employee.name, size: AppSizes.avatarSmall),
              Expanded(
                child: Text(
                  r.employee.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySemibold,
                ),
              ),
            ],
          ),
        ),
        AppDataColumn(
          label: 'EC number',
          minWidth: 110,
          priority: 2,
          cellBuilder: (context, r) => EcNumberText(r.employee.ecNumber),
        ),
        AppDataColumn(
          label: 'Department',
          minWidth: 150,
          priority: 3,
          cellBuilder: (context, r) => Text(
            r.employee.department?.name ?? '—',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppDataColumn(
          label: 'Earned',
          minWidth: 84,
          priority: 1,
          cellBuilder: (context, r) => Text(days(r.balance.accrued)),
        ),
        AppDataColumn(
          label: 'Used',
          minWidth: 76,
          cellBuilder: (context, r) => Text(days(r.balance.used)),
        ),
        AppDataColumn(
          label: 'Pending',
          minWidth: 88,
          priority: 1,
          cellBuilder: (context, r) =>
              Text(r.balance.pending > 0 ? days(r.balance.pending) : '—'),
        ),
        AppDataColumn(
          label: 'Remaining',
          minWidth: 104,
          cellBuilder: (context, r) => Text(
            FormatUtils.days(r.balance.remaining),
            style: AppTextStyles.bodyBold.copyWith(
              color: r.balance.remaining > 0
                  ? AppColors.primary
                  : AppColors.textMuted,
            ),
          ),
        ),
        AppDataColumn(
          label: 'Unpaid taken',
          minWidth: 118,
          cellBuilder: (context, r) => Text(
            r.balance.unpaidTaken > 0 ? days(r.balance.unpaidTaken) : '—',
          ),
        ),
      ],
    );
  }
}

class _MobileItem extends StatelessWidget {
  const _MobileItem({required this.row});

  final EmployeeLeaveBalanceModel row;

  @override
  Widget build(BuildContext context) {
    final b = row.balance;
    final muted = AppTextStyles.caption.copyWith(color: AppColors.textMuted);
    return Row(
      spacing: AppSpacing.s12,
      children: [
        AppAvatar(name: row.employee.name),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s2,
            children: [
              Text(
                row.employee.name,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySemibold,
              ),
              Text(
                [
                  '${FormatUtils.count(b.accrued)} earned',
                  '${FormatUtils.count(b.used)} used',
                  if (b.pending > 0) '${FormatUtils.count(b.pending)} pending',
                  if (b.unpaidTaken > 0)
                    '${FormatUtils.count(b.unpaidTaken)} unpaid',
                ].join(' · '),
                style: muted,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              FormatUtils.count(b.remaining),
              style: AppTextStyles.statXSmall.copyWith(
                color: b.remaining > 0
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
            Text('left', style: muted),
          ],
        ),
      ],
    );
  }
}
