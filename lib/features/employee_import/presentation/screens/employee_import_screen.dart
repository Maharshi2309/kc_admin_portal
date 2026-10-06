import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:kc_admin_portal/app/router/route_names.dart';
import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/files/file_picking.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_breadcrumb.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_page.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/responsive_grid.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_remote_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/providers/employee_import_providers.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/widgets/import_mapping_step.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/widgets/import_review_step.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/widgets/import_widgets.dart';

/// "Import employees" (2026-10-06, docs/ARCHITECTURE_MULTI_ORG.md §D):
/// upload an Excel file, match its columns, review the checked rows, and
/// confirm. Nothing is saved before the confirmation; the server checks
/// every row. On phones each step is one screen; on desktop it's one wide
/// page with tables.
class EmployeeImportScreen extends ConsumerWidget {
  const EmployeeImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(employeeImportControllerProvider);

    return AppPageBody(
      children: [
        AppPageHeader(
          title: 'Import employees',
          subtitle: 'Add many employees at once from an Excel file',
          breadcrumb: AppBreadcrumb(
            items: [
              AppBreadcrumbItem(
                'Employees',
                onTap: () => context.goNamed(AppRouteNames.employees),
              ),
              const AppBreadcrumbItem('Import employees'),
            ],
          ),
        ),
        ImportStepIndicator(step: flow.step),
        switch (flow.step) {
          ImportStep.upload => const _UploadStep(),
          ImportStep.map => const ImportMappingStep(),
          ImportStep.review => const ImportReviewStep(),
          ImportStep.result => const _ResultStep(),
        },
      ],
    );
  }
}

class _UploadStep extends ConsumerWidget {
  const _UploadStep();

  static const List<String> _types = ['xlsx', 'xls'];

  Future<void> _choose(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final file = await ref.read(fileChooserProvider)(extensions: _types);
    if (file == null) return;
    if (file.bytes.length > maxImportBytes) {
      showAppSnackBarOn(
        messenger,
        'The file is larger than 5 MB. Split it into smaller files.',
        tone: SnackBarTone.error,
      );
      return;
    }
    await ref.read(employeeImportControllerProvider.notifier).upload(file);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(employeeImportControllerProvider);
    final muted = AppTextStyles.small.copyWith(color: AppColors.textMuted);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s16,
        children: [
          Text('Upload an Excel file', style: AppTextStyles.headingSmall),
          if (flow.error case final error?)
            AppAlertBanner(message: ErrorHandler.messageFor(error)),
          for (final line in const [
            'One row per employee, with a header row at the top.',
            'Your own column names and order are fine: you match them in '
                'the next step.',
            'Nothing is saved until you have checked the rows and '
                'confirmed.',
          ])
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s8,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: AppSizes.iconSmall,
                  color: AppColors.primary,
                ),
                Expanded(child: Text(line, style: AppTextStyles.body)),
              ],
            ),
          Text(
            'Excel .xlsx or .xls, up to 5 MB and '
            '${FormatUtils.count(maxImportRows)} rows.',
            style: muted,
          ),
          Wrap(
            spacing: AppSpacing.s10,
            runSpacing: AppSpacing.s10,
            children: [
              AppButton(
                label: 'Choose Excel file',
                icon: Icons.upload_file_rounded,
                isLoading: flow.busy,
                onPressed: () => _choose(context, ref),
              ),
              const DownloadTemplateButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultStep extends ConsumerWidget {
  const _ResultStep();

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(employeeImportControllerProvider.notifier)
        .downloadReport();
    showAppSnackBarOn(
      messenger,
      error == null
          ? 'Saved the rows that were not imported'
          : ErrorHandler.messageFor(error),
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(employeeImportControllerProvider).current!;
    final result = current.result ?? const ImportResultModel();
    final notImported = result.failed + result.skipped;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s20,
        children: [
          Row(
            spacing: AppSpacing.s12,
            children: [
              const Icon(
                Icons.task_alt_rounded,
                color: AppColors.successFg,
                size: AppSizes.iconLarge,
              ),
              Expanded(
                child: Text(
                  'Import completed',
                  style: AppTextStyles.headingSmall,
                ),
              ),
            ],
          ),
          ResponsiveGrid(
            minItemWidth: ImportCountTile.minWidth,
            spacing: AppSpacing.s12,
            children: [
              ImportCountTile(
                label: 'Imported',
                value: result.imported,
                tone: ImportTone.good,
              ),
              ImportCountTile(
                label: 'Updated',
                value: result.updated,
                tone: ImportTone.info,
              ),
              ImportCountTile(label: 'Skipped', value: result.skipped),
              ImportCountTile(
                label: 'Not imported',
                value: result.failed,
                tone: result.failed > 0 ? ImportTone.bad : ImportTone.plain,
              ),
            ],
          ),
          Wrap(
            spacing: AppSpacing.s10,
            runSpacing: AppSpacing.s10,
            children: [
              AppButton(
                label: 'View employees',
                icon: Icons.group_outlined,
                onPressed: () => context.goNamed(AppRouteNames.employees),
              ),
              if (notImported > 0)
                AppButton(
                  label: 'Download rows not imported',
                  icon: Icons.download_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _report(context, ref),
                ),
              AppButton(
                label: 'Import another file',
                variant: AppButtonVariant.ghost,
                onPressed: () => ref
                    .read(employeeImportControllerProvider.notifier)
                    .startOver(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Asks before importing: what will happen, in numbers.
Future<bool> confirmImport(BuildContext context, EmployeeImportModel current) {
  final counts = current.counts ?? const ImportCountsModel();
  final updating = current.duplicateStrategy == DuplicateStrategy.update;
  return showAppConfirmDialog(
    context,
    title:
        'Import ${FormatUtils.count(current.importable)} '
        '${current.importable == 1 ? 'row' : 'rows'}?',
    message: [
      'Rows that passed are saved now${updating ? '; existing employees are '
                'updated with the file\'s values' : ''}.',
      if (counts.errors > 0)
        '${FormatUtils.count(counts.errors)} with errors '
            '${counts.errors == 1 ? 'is' : 'are'} not imported.',
      if (counts.skipped > 0)
        '${FormatUtils.count(counts.skipped)} existing '
            '${counts.skipped == 1 ? 'employee is' : 'employees are'} '
            'left as they are.',
    ].join(' '),
    confirmLabel: 'Import',
  );
}
