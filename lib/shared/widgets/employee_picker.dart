import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_avatar.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_loader.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/shared/models/employee_summary_model.dart';

/// Pick an active employee by name or EC number (design board 09). Shows the
/// chosen employee as a card with "Change".
class EmployeePicker extends ConsumerStatefulWidget {
  const EmployeePicker({
    required this.selected,
    required this.onSelected,
    this.label = 'Employee',
    this.isRequired = true,
    this.errorText,
    this.canChange = true,
    this.changeLabel = 'Change',
    this.helperText = 'Search by name or EC number, then pick from the list',
    super.key,
  });

  final EmployeeSummaryModel? selected;
  final ValueChanged<EmployeeSummaryModel?> onSelected;
  final String label;
  final bool isRequired;
  final String? errorText;

  /// False when the employee is fixed (e.g. editing a leave).
  final bool canChange;

  /// The button that clears the choice, e.g. "Remove" for an optional link.
  final String changeLabel;

  /// Shown under the search field while nobody is chosen.
  final String helperText;

  @override
  ConsumerState<EmployeePicker> createState() => _EmployeePickerState();
}

class _EmployeePickerState extends ConsumerState<EmployeePicker> {
  static const Duration _debounce = Duration(milliseconds: 300);

  final _search = TextEditingController();
  Timer? _timer;
  String _query = '';

  @override
  void dispose() {
    _timer?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(_debounce, () {
      if (mounted) setState(() => _query = text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return AppLabeledField(
      label: widget.label,
      isRequired: widget.isRequired,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s6,
        children: [
          if (selected != null)
            _SelectedCard(
              employee: selected,
              changeLabel: widget.changeLabel,
              onChange: widget.canChange
                  ? () {
                      _search.clear();
                      setState(() => _query = '');
                      widget.onSelected(null);
                    }
                  : null,
            )
          else ...[
            AppSearchField(
              hintText: 'Search by name or EC number',
              controller: _search,
              onChanged: _onChanged,
              onSubmitted: (text) => setState(() => _query = text.trim()),
            ),
            if (_query.isNotEmpty)
              _Results(query: _query, onSelected: widget.onSelected),
          ],
          AppFieldSubtext(
            errorText: widget.errorText,
            helperText: selected == null ? widget.helperText : null,
          ),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.query, required this.onSelected});

  final String query;
  final ValueChanged<EmployeeSummaryModel> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(employeeSearchProvider(query));
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: AppRadius.lgAll,
      ),
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: results.when(
        loading: () => const AppLoader(small: true),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.s10),
          child: Text(ErrorHandler.messageFor(error), style: muted),
        ),
        data: (employees) => employees.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.s10),
                child: Text(
                  'No active employee matches "$query"',
                  style: muted,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final e in employees)
                    InkWell(
                      borderRadius: AppRadius.smAll,
                      onTap: () => onSelected(
                        EmployeeSummaryModel(
                          id: e.id,
                          name: e.name,
                          ecNumber: e.ecNumber,
                          department: e.department,
                          position: e.position,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s8),
                        child: Row(
                          spacing: AppSpacing.s10,
                          children: [
                            AppAvatar(name: e.name, size: AppSizes.avatarSmall),
                            Expanded(
                              child: Text(
                                e.name,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySemibold,
                              ),
                            ),
                            Text(
                              '${e.ecNumber} · ${e.department.name}',
                              style: muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({
    required this.employee,
    required this.changeLabel,
    required this.onChange,
  });

  final String changeLabel;

  final EmployeeSummaryModel employee;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.lgAll,
      ),
      child: Row(
        spacing: AppSpacing.s12,
        children: [
          AppAvatar(name: employee.name),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Text(employee.name, style: AppTextStyles.bodyBold),
                Text(
                  [employee.ecNumber, ?employee.position?.name].join(' · '),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (onChange != null)
            AppButton(
              label: changeLabel,
              size: AppButtonSize.small,
              variant: AppButtonVariant.secondary,
              onPressed: onChange,
            ),
        ],
      ),
    );
  }
}
