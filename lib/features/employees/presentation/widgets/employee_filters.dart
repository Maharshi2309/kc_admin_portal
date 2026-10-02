import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_date_range_filter.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/master_data/presentation/providers/master_data_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Search and filter row above the employee table. Wraps onto several lines
/// on narrow screens.
class EmployeeFilters extends ConsumerWidget {
  const EmployeeFilters({required this.searchController, super.key});

  final TextEditingController searchController;

  static const double _searchMaxWidth = 300;
  static final DateTime _earliestJoiningDate = DateTime(1970);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(employeeQueryProvider);
    final notifier = ref.read(employeeQueryProvider.notifier);
    final departments = ref.watch(departmentsProvider).value ?? const [];
    final today = ref.watch(clockProvider)();
    final designations = query.departmentId == null
        ? null
        : ref.watch(designationsProvider(query.departmentId!)).value;

    return Wrap(
      spacing: AppSpacing.s10,
      runSpacing: AppSpacing.s10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _searchMaxWidth),
          child: AppSearchField(
            hintText: 'Name or EC number',
            compact: true,
            controller: searchController,
            onChanged: notifier.setSearch,
            onSubmitted: notifier.applySearch,
          ),
        ),
        AppFilterDropdown<String>(
          label: 'Department',
          value: query.departmentId,
          onChanged: notifier.setDepartment,
          items: [
            for (final d in departments)
              AppDropdownItem(value: d.id, label: d.name),
          ],
        ),
        // Designations belong to a department, so this filter appears once
        // a department is chosen.
        if (designations != null)
          AppFilterDropdown<String>(
            label: 'Designation',
            value: query.designationId,
            onChanged: notifier.setDesignation,
            items: [
              for (final d in designations)
                AppDropdownItem(value: d.id, label: d.name),
            ],
          ),
        AppDateRangeFilter(
          label: 'Joined',
          from: query.joinedFrom,
          to: query.joinedTo,
          firstDate: _earliestJoiningDate,
          lastDate: DateTime(today.year + 1, 12, 31),
          onChanged: notifier.setJoined,
        ),
        AppFilterDropdown<EmployeeStatus>(
          label: 'Status',
          value: query.status,
          onChanged: notifier.setStatus,
          items: [
            for (final status in [
              EmployeeStatus.active,
              EmployeeStatus.inactive,
            ])
              AppDropdownItem(value: status, label: status.label),
          ],
        ),
        if (query.hasFilters)
          AppButton(
            label: 'Clear filters',
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.small,
            onPressed: () {
              searchController.clear();
              notifier.clearFilters();
            },
          ),
      ],
    );
  }
}
