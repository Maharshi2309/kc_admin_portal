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
import 'package:kc_admin_portal/core/widgets/app_choice_chips.dart';
import 'package:kc_admin_portal/core/widgets/app_empty_view.dart';
import 'package:kc_admin_portal/core/widgets/app_pagination.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_data_view.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/providers/employee_import_providers.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/screens/employee_import_screen.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/widgets/import_widgets.dart';

/// Step 3: what the server found in every row, before anything is saved.
/// Problem rows first; all rows on request. Confirming imports the rows
/// that passed.
class ImportReviewStep extends ConsumerStatefulWidget {
  const ImportReviewStep({super.key});

  @override
  ConsumerState<ImportReviewStep> createState() => _ImportReviewStepState();
}

class _ImportReviewStepState extends ConsumerState<ImportReviewStep> {
  late ImportRowFilter _filter = _firstFilter();
  int _page = 1;

  ImportRowFilter _firstFilter() {
    final counts = ref.read(employeeImportControllerProvider).current?.counts;
    return (counts?.errors ?? 0) + (counts?.warnings ?? 0) > 0
        ? ImportRowFilter.problems
        : ImportRowFilter.all;
  }

  Future<void> _confirm() async {
    final current = ref.read(employeeImportControllerProvider).current!;
    if (!await confirmImport(context, current)) return;
    await ref.read(employeeImportControllerProvider.notifier).confirm();
  }

  @override
  Widget build(BuildContext context) {
    final flow = ref.watch(employeeImportControllerProvider);
    final controller = ref.read(employeeImportControllerProvider.notifier);
    final current = flow.current!;
    final counts = current.counts ?? const ImportCountsModel();
    final importing = flow.busy && current.status == ImportStatus.importing;
    final rows = ref.watch(
      importRowsProvider((id: current.id, filter: _filter, page: _page)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s16,
      children: [
        ResponsiveGrid(
          minItemWidth: ImportCountTile.minWidth,
          spacing: AppSpacing.s12,
          children: [
            ImportCountTile(label: 'Rows', value: current.rowCount),
            ImportCountTile(
              label: 'Ready',
              value: counts.valid,
              tone: ImportTone.good,
            ),
            ImportCountTile(
              label: 'Ready, please check',
              value: counts.warnings,
              tone: counts.warnings > 0 ? ImportTone.warn : ImportTone.plain,
            ),
            ImportCountTile(
              label: 'Errors',
              value: counts.errors,
              tone: counts.errors > 0 ? ImportTone.bad : ImportTone.plain,
            ),
            if (counts.skipped > 0)
              ImportCountTile(label: 'Skipped', value: counts.skipped),
          ],
        ),
        if (counts.errors > 0)
          const AppAlertBanner(
            tone: AlertTone.info,
            title: 'Rows with errors are not imported',
            message:
                'Fix them in the file and upload it again, or import the '
                'other rows now and the rest later.',
          ),
        if (flow.error case final error?)
          AppAlertBanner(message: ErrorHandler.messageFor(error)),
        AppCard(
          padding: EdgeInsets.zero,
          clip: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: AppChoiceChips<ImportRowFilter>(
                  selected: _filter,
                  onSelected: (filter) => setState(() {
                    _filter = filter;
                    _page = 1;
                  }),
                  choices: [
                    for (final filter in ImportRowFilter.values)
                      AppChoice(value: filter, label: filter.label),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              AsyncValueView<ImportRowsPageModel>(
                value: rows,
                onRetry: () => ref.invalidate(importRowsProvider),
                isEmpty: (page) => page.items.isEmpty,
                empty: AppEmptyView(
                  icon: Icons.task_alt_rounded,
                  title: _filter == ImportRowFilter.all
                      ? 'No rows'
                      : 'No ${_filter.label.toLowerCase()}',
                  compact: true,
                ),
                data: (page) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RowsTable(rows: page.items),
                    AppPagination(
                      page: page.page,
                      pageSize: page.pageSize,
                      totalItems: page.total,
                      onPageChanged: (value) => setState(() => _page = value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (importing)
          Row(
            spacing: AppSpacing.s12,
            children: [
              const SizedBox.square(
                dimension: AppSizes.iconLarge,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              Text(
                'Importing… ${FormatUtils.count(current.processed)} of '
                '${FormatUtils.count(current.importable)}',
                style: AppTextStyles.bodySemibold,
              ),
            ],
          ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.s10,
          runSpacing: AppSpacing.s10,
          children: [
            AppButton(
              label: 'Back to columns',
              variant: AppButtonVariant.ghost,
              onPressed: flow.busy ? null : controller.backToMapping,
            ),
            AppButton(
              label: current.importable == 0
                  ? 'Nothing to import'
                  : 'Import ${FormatUtils.count(current.importable)} '
                        '${current.importable == 1 ? 'row' : 'rows'}',
              icon: Icons.playlist_add_check_rounded,
              isLoading: flow.busy,
              onPressed: current.importable == 0 ? null : _confirm,
            ),
          ],
        ),
      ],
    );
  }
}

class _RowsTable extends StatelessWidget {
  const _RowsTable({required this.rows});

  final List<ImportRowModel> rows;

  static String details(ImportRowModel row) => [
    ...row.messages,
    for (final change in row.changes)
      '${change.field}: ${change.before ?? '—'} → ${change.after ?? '—'}',
  ].join('\n');

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.small.copyWith(color: AppColors.textSecondary);
    return ResponsiveDataView<ImportRowModel>(
      rows: rows,
      rowKey: (row) => row.rowNumber,
      mobileItemBuilder: (context, row) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s6,
        children: [
          Row(
            spacing: AppSpacing.s8,
            children: [
              Expanded(
                child: Text(
                  'Row ${row.rowNumber} · ${row.name ?? 'No name'}',
                  style: AppTextStyles.bodySemibold,
                ),
              ),
              ImportRowStatusBadge(row.status),
            ],
          ),
          if (row.ecNumber case final ec?)
            Text(
              ec,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          if (details(row).isNotEmpty) Text(details(row), style: muted),
        ],
      ),
      columns: [
        AppDataColumn(
          label: 'Row',
          minWidth: 64,
          cellBuilder: (context, row) => Text('${row.rowNumber}'),
        ),
        AppDataColumn(
          label: 'EC number',
          minWidth: 110,
          cellBuilder: (context, row) => Text(row.ecNumber ?? '—'),
        ),
        AppDataColumn(
          label: 'Name',
          flex: 2,
          minWidth: 160,
          cellBuilder: (context, row) => Text(
            row.name ?? '—',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySemibold,
          ),
        ),
        AppDataColumn(
          label: 'Status',
          minWidth: 130,
          cellBuilder: (context, row) => ImportRowStatusBadge(row.status),
        ),
        AppDataColumn(
          label: 'Details',
          flex: 4,
          minWidth: 240,
          cellBuilder: (context, row) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
            child: Text(details(row), style: muted),
          ),
        ),
      ],
    );
  }
}
