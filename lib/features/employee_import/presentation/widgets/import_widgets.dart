import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employee_import/presentation/providers/employee_import_providers.dart';

/// "1 Upload › 2 Match columns › 3 Review › 4 Result" on wide screens;
/// "Step 2 of 4 · Match columns" on phones.
class ImportStepIndicator extends StatelessWidget {
  const ImportStepIndicator({required this.step, super.key});

  final ImportStep step;

  @override
  Widget build(BuildContext context) {
    const steps = ImportStep.values;
    if (context.isMobile) {
      return Text(
        'Step ${step.index + 1} of ${steps.length} · ${step.label}',
        style: AppTextStyles.smallSemibold.copyWith(color: AppColors.primary),
      );
    }
    return Semantics(
      label: 'Step ${step.index + 1} of ${steps.length}: ${step.label}',
      excludeSemantics: true,
      child: Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final s in steps) ...[
            _StepChip(
              number: s.index + 1,
              label: s.label,
              state: s.index < step.index
                  ? _StepState.done
                  : s == step
                  ? _StepState.current
                  : _StepState.later,
            ),
            if (s != steps.last)
              const Icon(
                Icons.chevron_right_rounded,
                size: AppSizes.iconSmall,
                color: AppColors.textMuted,
              ),
          ],
        ],
      ),
    );
  }
}

enum _StepState { done, current, later }

class _StepChip extends StatelessWidget {
  const _StepChip({
    required this.number,
    required this.label,
    required this.state,
  });

  final int number;
  final String label;
  final _StepState state;

  static const double _dot = 22;

  @override
  Widget build(BuildContext context) {
    final active = state != _StepState.later;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.s6,
      children: [
        Container(
          width: _dot,
          height: _dot,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : AppColors.surfaceSunken,
          ),
          child: state == _StepState.done
              ? const Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconSmall,
                  color: AppColors.onPrimary,
                )
              : Text(
                  '$number',
                  style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.onPrimary : AppColors.textMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
        Text(
          label,
          style: AppTextStyles.smallSemibold.copyWith(
            color: state == _StepState.current
                ? AppColors.textPrimary
                : AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

enum ImportTone { plain, good, info, warn, bad }

/// "Ready 143" style total.
class ImportCountTile extends StatelessWidget {
  const ImportCountTile({
    required this.label,
    required this.value,
    this.tone = ImportTone.plain,
    super.key,
  });

  final String label;
  final int value;
  final ImportTone tone;

  static const double minWidth = 130;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      ImportTone.plain => (AppColors.surfaceSubtle, AppColors.textPrimary),
      ImportTone.good => (AppColors.successBg, AppColors.successFg),
      ImportTone.info => (AppColors.primarySoft, AppColors.primary),
      ImportTone.warn => (AppColors.warningBg, AppColors.warningFg),
      ImportTone.bad => (AppColors.dangerSurface, AppColors.dangerFg),
    };
    return Semantics(
      label: '$label: ${FormatUtils.count(value)}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.lgAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s2,
          children: [
            Text(label, style: AppTextStyles.small.copyWith(color: foreground)),
            Text(
              FormatUtils.count(value),
              style: AppTextStyles.statSmall.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

/// A checked row's state.
class ImportRowStatusBadge extends StatelessWidget {
  const ImportRowStatusBadge(this.status, {super.key});

  final ImportRowStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (status) {
      ImportRowStatus.valid => ('Ready', StatusTone.success),
      ImportRowStatus.warning => ('Check', StatusTone.warning),
      ImportRowStatus.error => ('Error', StatusTone.danger),
      ImportRowStatus.skipped => ('Skipped', StatusTone.neutral),
      ImportRowStatus.imported => ('Imported', StatusTone.success),
      ImportRowStatus.updated => ('Updated', StatusTone.info),
      ImportRowStatus.failed => ('Not imported', StatusTone.danger),
      ImportRowStatus.unknown => ('Unknown', StatusTone.neutral),
    };
    return AppStatusBadge(label: label, tone: tone);
  }
}

/// "Download template": the official file with every field, an example
/// row and the organization's departments and positions.
class DownloadTemplateButton extends ConsumerWidget {
  const DownloadTemplateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      label: 'Download template',
      icon: Icons.download_rounded,
      variant: AppButtonVariant.secondary,
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final error = await ref
            .read(employeeImportControllerProvider.notifier)
            .downloadTemplate();
        showAppSnackBarOn(
          messenger,
          error == null
              ? 'Template saved: employee-import-template.xlsx'
              : ErrorHandler.messageFor(error),
          tone: error == null ? SnackBarTone.success : SnackBarTone.error,
        );
      },
    );
  }
}

/// A checkbox with a title and a short explanation (import options).
class ImportOptionCheckbox extends StatelessWidget {
  const ImportOptionCheckbox({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return MergeSemantics(
      child: InkWell(
        onTap: enabled ? () => onChanged!(!value) : null,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s8,
            children: [
              Checkbox(
                value: value,
                onChanged: enabled ? (checked) => onChanged!(checked!) : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.s10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.s2,
                    children: [
                      Text(title, style: AppTextStyles.bodySemibold),
                      Text(
                        description,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
