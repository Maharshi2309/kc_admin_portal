import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_field_label.dart';
import 'package:kc_admin_portal/core/widgets/app_segmented_control.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/providers/employee_import_providers.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/widgets/import_widgets.dart';

/// Step 2: which portal field each Excel column fills (pre-filled from the
/// header names), what to do with existing EC numbers, and two options.
class ImportMappingStep extends ConsumerWidget {
  const ImportMappingStep({super.key});

  static const double _columnMinWidth = 300;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(employeeImportControllerProvider);
    final controller = ref.read(employeeImportControllerProvider.notifier);
    final current = flow.current!;
    final missing = flow.missingFields;
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s16,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s16,
            children: [
              Text('Match the columns', style: AppTextStyles.headingSmall),
              Text(
                '${current.fileName} · ${FormatUtils.count(current.rowCount)} '
                '${current.rowCount == 1 ? 'row' : 'rows'}. Choose the '
                'portal field for each column; columns set to "Don\'t '
                'import" are left out.',
                style: muted,
              ),
              if (missing.isNotEmpty)
                AppAlertBanner(
                  tone: AlertTone.info,
                  title: 'Still to match',
                  message: missing.map((f) => f.label).join(', '),
                ),
              ResponsiveGrid(
                minItemWidth: _columnMinWidth,
                maxColumns: 3,
                equalHeight: false,
                children: [
                  for (final (index, header) in current.headers.indexed)
                    _ColumnChoice(
                      header: header,
                      samples: [
                        for (final row in current.sampleRows)
                          if (index < row.length && row[index].isNotEmpty)
                            row[index],
                      ],
                      field: ImportField.fromKey(flow.mapping[header]),
                      enabled: !flow.busy,
                      onChanged: (field) =>
                          controller.matchColumn(header, field),
                    ),
                ],
              ),
            ],
          ),
        ),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s12,
            children: [
              AppLabeledField(
                label: 'Employees already here (same EC number)',
                child: AppSegmentedControl<DuplicateStrategy>(
                  semanticLabel: 'Existing employees',
                  selected: flow.duplicates,
                  onChanged: flow.busy ? null : controller.setDuplicates,
                  segments: const [
                    AppSegment(
                      value: DuplicateStrategy.skip,
                      label: 'Leave as they are',
                    ),
                    AppSegment(
                      value: DuplicateStrategy.update,
                      label: 'Update them',
                    ),
                  ],
                ),
              ),
              Text(
                flow.duplicates == DuplicateStrategy.skip
                    ? 'Rows with an EC number that already exists are skipped.'
                    : 'Only filled-in cells overwrite. You see every change '
                          'before confirming; working schedules are never '
                          'changed by an import.',
                style: muted,
              ),
              ImportOptionCheckbox(
                title: 'Create missing departments and positions',
                description:
                    "Names that aren't in Settings yet are added. Otherwise "
                    'those rows are errors.',
                value: flow.createMissing,
                onChanged: flow.busy ? null : controller.setCreateMissing,
              ),
              ImportOptionCheckbox(
                title: 'Give rows without an EC number the next number',
                description: 'Otherwise a missing EC number is an error.',
                value: flow.assignEcNumbers,
                onChanged: flow.busy ? null : controller.setAssignEcNumbers,
              ),
            ],
          ),
        ),
        if (flow.error case final error?)
          AppAlertBanner(message: ErrorHandler.messageFor(error)),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.s10,
          runSpacing: AppSpacing.s10,
          children: [
            AppButton(
              label: 'Choose another file',
              variant: AppButtonVariant.ghost,
              onPressed: flow.busy ? null : controller.startOver,
            ),
            AppButton(
              label: 'Check rows',
              icon: Icons.fact_check_outlined,
              isLoading: flow.busy,
              onPressed: missing.isEmpty ? controller.check : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// One Excel column: its header, a few values, and the portal field.
class _ColumnChoice extends StatelessWidget {
  const _ColumnChoice({
    required this.header,
    required this.samples,
    required this.field,
    required this.enabled,
    required this.onChanged,
  });

  final String header;
  final List<String> samples;
  final ImportField? field;
  final bool enabled;
  final ValueChanged<ImportField?> onChanged;

  /// The dropdown's value for "Don't import".
  static const String _ignore = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: field == null ? AppColors.surfaceSubtle : AppColors.surface,
        border: Border.all(
          color: field == null ? AppColors.border : AppColors.primaryMuted,
        ),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s8,
        children: [
          Text(header, style: AppTextStyles.bodySemibold),
          Text(
            samples.isEmpty
                ? 'Empty in the first rows'
                : 'e.g. ${samples.join(' · ')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          AppDropdown<String>(
            label: 'Imports as',
            value: field?.name ?? _ignore,
            enabled: enabled,
            items: [
              const AppDropdownItem(value: _ignore, label: "Don't import"),
              for (final f in ImportField.values)
                AppDropdownItem(
                  value: f.name,
                  label: f.isRequired ? '${f.label} *' : f.label,
                ),
            ],
            onChanged: (key) => onChanged(ImportField.fromKey(key)),
          ),
        ],
      ),
    );
  }
}
