import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/permission_providers.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_filters.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/employee_table.dart';

/// Employee list with search, filters and pagination (design board 03).
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the design also shows Export,
/// bulk row selection and a "Joined" date filter; they are not in the
/// requirement document and are left out until confirmed.
class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({this.initialSearch, super.key});

  /// Search text passed from the header search (`?search=`).
  final String? initialSearch;

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  static const double _progressLineHeight = 2;

  late final _searchController = TextEditingController(
    text: ref.read(employeeQueryProvider).search,
  );

  @override
  void initState() {
    super.initState();
    _applyInitialSearch();
  }

  @override
  void didUpdateWidget(EmployeesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSearch != widget.initialSearch) _applyInitialSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Runs a search handed over from the header, after this frame (providers
  /// must not change while widgets build).
  void _applyInitialSearch() {
    final search = widget.initialSearch;
    if (search == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text = search;
      ref.read(employeeQueryProvider.notifier).applySearch(search);
    });
  }

  void _addEmployee() => context.goNamed(AppRouteNames.employeeAdd);

  /// "124 active · 4 inactive" (design), or the total when the backend
  /// does not send counts.
  static String _subtitle(EmployeeListModel page) {
    final counts = page.counts;
    if (counts == null) {
      return page.total == 1
          ? '1 employee'
          : '${FormatUtils.count(page.total)} employees';
    }
    return '${FormatUtils.count(counts.active)} active · '
        '${FormatUtils.count(counts.inactive)} inactive';
  }

  @override
  Widget build(BuildContext context) {
    final employees = ref.watch(employeeListProvider);
    final page = employees.value;

    final canAdd = ref.can(AppPermission.employeeCreate);

    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Employees',
          subtitle: page == null ? null : _subtitle(page),
          actions: [
            if (canAdd) ...[
              AppButton(
                label: 'Import employees',
                icon: Icons.upload_file_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.goNamed(AppRouteNames.employeeImport),
              ),
              AppButton(
                label: 'Add employee',
                icon: Icons.add_rounded,
                onPressed: _addEmployee,
              ),
            ],
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
                child: EmployeeFilters(searchController: _searchController),
              ),
              // Thin progress line while a new page or filter loads; the
              // previous rows stay visible meanwhile.
              SizedBox(
                height: _progressLineHeight,
                child: employees.isLoading && employees.hasValue
                    ? const LinearProgressIndicator()
                    : const Divider(height: 1, color: AppColors.border),
              ),
              AsyncValueView<EmployeeListModel>(
                value: employees,
                onRetry: () => ref.invalidate(employeeListProvider),
                isEmpty: (page) => page.items.isEmpty,
                empty: _EmptyState(
                  onClearFilters: () {
                    _searchController.clear();
                    ref.read(employeeQueryProvider.notifier).clearFilters();
                  },
                  onAdd: canAdd ? _addEmployee : null,
                ),
                data: (page) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EmployeeTable(employees: page.items),
                    AppPagination(
                      page: page.page,
                      pageSize: page.pageSize,
                      totalItems: page.total,
                      onPageChanged: ref
                          .read(employeeQueryProvider.notifier)
                          .setPage,
                      onPageSizeChanged: ref
                          .read(employeeQueryProvider.notifier)
                          .setPageSize,
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

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.onClearFilters, required this.onAdd});

  final VoidCallback onClearFilters;

  /// Null when the role can't add employees.
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(employeeQueryProvider).hasFilters;

    return filtered
        ? AppEmptyView(
            icon: Icons.search_off_rounded,
            title: 'No employees match these filters',
            message: 'Try a different name or EC number, or clear the filters.',
            action: AppButton(
              label: 'Clear filters',
              variant: AppButtonVariant.secondary,
              onPressed: onClearFilters,
            ),
          )
        : AppEmptyView(
            icon: Icons.group_add_outlined,
            title: 'No employees added yet',
            message: onAdd == null
                ? null
                : 'Import them from Excel or add your first employee.',
            action: onAdd == null
                ? null
                : Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.s10,
                    runSpacing: AppSpacing.s10,
                    children: [
                      AppButton(
                        label: 'Import employees',
                        icon: Icons.upload_file_rounded,
                        variant: AppButtonVariant.secondary,
                        onPressed: () =>
                            context.goNamed(AppRouteNames.employeeImport),
                      ),
                      AppButton(
                        label: 'Add employee',
                        icon: Icons.add_rounded,
                        onPressed: onAdd,
                      ),
                    ],
                  ),
          );
  }
}
