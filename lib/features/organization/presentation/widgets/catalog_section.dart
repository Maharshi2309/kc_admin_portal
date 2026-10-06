import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dialog.dart';
import 'package:kc_admin_portal/core/widgets/app_icon_button.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/core/widgets/async_value_view.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';

/// The organization's departments or positions: add, rename, deactivate and
/// reactivate. Nothing is deleted: employees keep a deactivated one, but it
/// can't be chosen for anyone else.
class CatalogSection extends ConsumerStatefulWidget {
  const CatalogSection({required this.kind, super.key});

  final CatalogKind kind;

  @override
  ConsumerState<CatalogSection> createState() => _CatalogSectionState();
}

class _CatalogSectionState extends ConsumerState<CatalogSection> {
  final _newName = TextEditingController();
  String? _addError;

  @override
  void dispose() {
    _newName.dispose();
    super.dispose();
  }

  CatalogKind get kind => widget.kind;

  Future<void> _add() async {
    final name = _newName.text.trim();
    if (name.isEmpty) {
      setState(() => _addError = 'Enter a name');
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .addItem(kind, name);
    if (!mounted) return;
    if (error == null) {
      _newName.clear();
      setState(() => _addError = null);
      showAppSnackBarOn(
        messenger,
        '${kind.singular} "$name" added',
        tone: SnackBarTone.success,
      );
    } else {
      setState(() => _addError = _fieldError(error, 'name'));
      if (_addError == null) {
        showAppSnackBarOn(
          messenger,
          ErrorHandler.messageFor(error),
          tone: SnackBarTone.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(catalogProvider(kind));
    final busy = ref.watch(organizationSettingsControllerProvider);
    final adding = busy.contains('${kind.name}-new');

    return SectionCard(
      title: kind.plural,
      subtitle: kind == CatalogKind.departments
          ? 'Where people work, e.g. Accounts or Production'
          : 'Job titles, e.g. Tailor or Manager (not app access)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s12,
        children: [
          AsyncValueView<List<CatalogItemModel>>(
            value: items,
            compact: true,
            onRetry: () => ref.invalidate(catalogProvider(kind)),
            isEmpty: (list) => list.isEmpty,
            empty: Text(
              'No ${kind.plural.toLowerCase()} yet. Add the first one below.',
              style: AppTextStyles.small.copyWith(color: AppColors.textMuted),
            ),
            data: (list) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, item) in list.indexed) ...[
                  if (index > 0) const Divider(height: 1),
                  _ItemRow(
                    kind: kind,
                    item: item,
                    busy: busy.contains(item.id),
                  ),
                ],
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s8,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _newName,
                  hintText: 'New ${kind.singular.toLowerCase()}',
                  enabled: !adding,
                  maxLength: 60,
                  errorText: _addError,
                  textCapitalization: TextCapitalization.words,
                  onFieldSubmitted: (_) => _add(),
                  onChanged: (_) {
                    if (_addError != null) setState(() => _addError = null);
                  },
                ),
              ),
              AppButton(
                label: 'Add',
                icon: Icons.add_rounded,
                variant: AppButtonVariant.secondary,
                isLoading: adding,
                onPressed: _add,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String? _fieldError(Object error, String field) =>
    error is ValidationException ? error.fieldErrors[field] : null;

class _ItemRow extends ConsumerWidget {
  const _ItemRow({required this.kind, required this.item, required this.busy});

  final CatalogKind kind;
  final CatalogItemModel item;
  final bool busy;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final deactivating = item.isActive;
    if (deactivating) {
      final people = item.employeeCount;
      final confirmed = await showAppConfirmDialog(
        context,
        title: 'Deactivate "${item.name}"?',
        message:
            "It can't be chosen for anyone from now on. "
            '${people == 0
                ? 'Nobody has it.'
                : people == 1
                ? '1 employee keeps it.'
                : '$people employees keep it.'} '
            'You can reactivate it later.',
        confirmLabel: 'Deactivate',
        isDestructive: true,
      );
      if (!confirmed) return;
    }
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .setItemActive(kind, item.id, isActive: !deactivating);
    showAppSnackBarOn(
      messenger,
      error != null
          ? ErrorHandler.messageFor(error)
          : '"${item.name}" ${deactivating ? 'deactivated' : 'reactivated'}',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = item.employeeCount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        spacing: AppSpacing.s8,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.s2,
              children: [
                Wrap(
                  spacing: AppSpacing.s8,
                  runSpacing: AppSpacing.s4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: AppTextStyles.bodySemibold.copyWith(
                        color: item.isActive ? null : AppColors.textMuted,
                      ),
                    ),
                    if (!item.isActive)
                      const AppStatusBadge(
                        label: 'Inactive',
                        tone: StatusTone.neutral,
                      ),
                  ],
                ),
                Text(
                  count == 1 ? '1 employee' : '$count employees',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.edit_outlined,
            tooltip: 'Rename ${item.name}',
            onPressed: busy
                ? null
                : () => showDialog<void>(
                    context: context,
                    builder: (_) => _RenameDialog(kind: kind, item: item),
                  ),
          ),
          AppIconButton(
            icon: item.isActive
                ? Icons.block_rounded
                : Icons.check_circle_outline_rounded,
            tooltip:
                '${item.isActive ? 'Deactivate' : 'Reactivate'} '
                '${item.name}',
            onPressed: busy ? null : () => _toggle(context, ref),
          ),
        ],
      ),
    );
  }
}

class _RenameDialog extends ConsumerStatefulWidget {
  const _RenameDialog({required this.kind, required this.item});

  final CatalogKind kind;
  final CatalogItemModel item;

  @override
  ConsumerState<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends ConsumerState<_RenameDialog> {
  late final _name = TextEditingController(text: widget.item.name);
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name');
      return;
    }
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(organizationSettingsControllerProvider.notifier)
        .renameItem(widget.kind, widget.item.id, name);
    if (!mounted) return;
    if (error == null) {
      showAppSnackBarOn(
        messenger,
        'Renamed to "$name"',
        tone: SnackBarTone.success,
      );
      await navigator.maybePop();
    } else {
      setState(
        () => _error =
            _fieldError(error, 'name') ?? ErrorHandler.messageFor(error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref
        .watch(organizationSettingsControllerProvider)
        .contains(widget.item.id);
    return AppDialog(
      title: 'Rename ${widget.kind.singular.toLowerCase()}',
      subtitle: 'Every employee with it shows the new name',
      maxWidth: AppSizes.confirmDialogMaxWidth,
      fullscreenOnMobile: false,
      actions: [
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.secondary,
          onPressed: saving ? null : () => Navigator.of(context).maybePop(),
        ),
        AppButton(label: 'Save', isLoading: saving, onPressed: _save),
      ],
      body: AppTextField(
        label: 'Name',
        controller: _name,
        autofocus: true,
        maxLength: 60,
        enabled: !saving,
        errorText: _error,
        textCapitalization: TextCapitalization.words,
        onFieldSubmitted: (_) => _save(),
      ),
    );
  }
}
