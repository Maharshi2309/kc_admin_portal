import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/app/theme/app_colors.dart';
import 'package:kc_admin_portal/app/theme/app_dimensions.dart';
import 'package:kc_admin_portal/app/theme/app_text_styles.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/responsive/responsive_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_alert_banner.dart';
import 'package:kc_admin_portal/core/widgets/app_button.dart';
import 'package:kc_admin_portal/core/widgets/app_card.dart';
import 'package:kc_admin_portal/core/widgets/app_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_filter_dropdown.dart';
import 'package:kc_admin_portal/core/widgets/app_snackbar.dart';
import 'package:kc_admin_portal/core/widgets/form_footer_bar.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';

/// What one user may do: a row per module, a checkbox per permission, with
/// shortcuts to select all, clear all, or copy another user's permissions.
/// Nothing is saved until "Save permissions".
///
/// [isYou]: people can't take "Manage users and permissions" from
/// themselves (the server refuses it too), so that box is locked.
class UserPermissionsEditor extends ConsumerStatefulWidget {
  const UserPermissionsEditor({
    required this.user,
    required this.modules,
    required this.otherUsers,
    required this.isYou,
    super.key,
  });

  final UserAccountModel user;
  final List<PermissionModuleModel> modules;

  /// Users whose permissions can be copied.
  final List<UserAccountModel> otherUsers;
  final bool isYou;

  @override
  ConsumerState<UserPermissionsEditor> createState() =>
      _UserPermissionsEditorState();
}

class _UserPermissionsEditorState extends ConsumerState<UserPermissionsEditor> {
  late Set<String> _draft = {...widget.user.permissions};

  Set<String> get _saved => widget.user.permissions.toSet();

  Set<String> get _allKeys => {
    for (final m in widget.modules)
      for (final p in m.permissions) p.key,
  };

  static final String _manage = AppPermission.permissionManage.key;

  /// Keys the user may not change here.
  Set<String> get _locked =>
      widget.isYou && _saved.contains(_manage) ? {_manage} : const {};

  int get _changes =>
      _draft.difference(_saved).length + _saved.difference(_draft).length;

  void _set(Set<String> next) => setState(() => _draft = {...next, ..._locked});

  void _toggle(String key, {required bool on}) {
    if (_locked.contains(key)) return;
    _set(on ? ({..._draft, key}) : ({..._draft}..remove(key)));
  }

  void _toggleModule(PermissionModuleModel module, {required bool on}) {
    final keys = module.permissions.map((p) => p.key);
    _set(on ? {..._draft, ...keys} : ({..._draft}..removeAll(keys)));
  }

  void _copyFrom(String? userId) {
    final source = widget.otherUsers.where((u) => u.id == userId).firstOrNull;
    if (source == null) return;
    _set(source.permissions.where(_allKeys.contains).toSet());
    showAppSnackBar(
      context,
      'Copied the permissions of ${source.name}. Save to apply them.',
    );
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(userPermissionsControllerProvider.notifier)
        .save(widget.user.id, _draft);
    showAppSnackBarOn(
      messenger,
      error ?? 'Permissions of ${widget.user.name} saved',
      tone: error == null ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(userPermissionsControllerProvider).isLoading;
    final changes = _changes;
    final hint = changes == 1 ? '1 unsaved change' : '$changes unsaved changes';
    final total = _allKeys.length;
    final selected = _draft.where(_allKeys.contains).length;
    final actions = [
      AppButton(
        label: 'Discard',
        variant: AppButtonVariant.secondary,
        onPressed: saving ? null : () => setState(() => _draft = _saved),
      ),
      AppButton(label: 'Save permissions', isLoading: saving, onPressed: _save),
    ];

    return AppCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.s12,
              children: [
                Wrap(
                  spacing: AppSpacing.s12,
                  runSpacing: AppSpacing.s10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            'Permissions',
                            style: AppTextStyles.sectionTitle,
                          ),
                        ),
                        Text(
                          selected == total
                              ? 'Full access: all $total permissions'
                              : '$selected of $total permissions',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        AppButton(
                          label: 'Select all',
                          size: AppButtonSize.small,
                          variant: AppButtonVariant.secondary,
                          onPressed: saving || selected == total
                              ? null
                              : () => _set(_allKeys),
                        ),
                        AppButton(
                          label: 'Clear all',
                          size: AppButtonSize.small,
                          variant: AppButtonVariant.secondary,
                          onPressed: saving || _draft.length == _locked.length
                              ? null
                              : () => _set(const {}),
                        ),
                        if (widget.otherUsers.isNotEmpty)
                          AppFilterDropdown<String>(
                            label: 'Copy from',
                            allLabel: null,
                            value: null,
                            items: [
                              for (final u in widget.otherUsers)
                                AppDropdownItem(value: u.id, label: u.name),
                            ],
                            onChanged: saving ? (_) {} : _copyFrom,
                          ),
                      ],
                    ),
                  ],
                ),
                if (widget.isYou && _locked.isNotEmpty)
                  const AppAlertBanner(
                    tone: AlertTone.info,
                    message:
                        'This is you. "Manage users and permissions" stays on '
                        'so you can\'t lock yourself out.',
                  ),
                if (!widget.user.isActive)
                  const AppAlertBanner(
                    tone: AlertTone.info,
                    message:
                        'This user is deactivated and can\'t sign in, whatever '
                        'their permissions.',
                  ),
                if (changes > 0)
                  Wrap(
                    spacing: AppSpacing.s10,
                    runSpacing: AppSpacing.s8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        hint,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      ...actions,
                    ],
                  ),
              ],
            ),
          ),
          for (final module in widget.modules) ...[
            const Divider(height: 1, color: AppColors.border),
            _ModuleRow(
              module: module,
              selected: _draft,
              locked: _locked,
              enabled: !saving,
              onToggle: _toggle,
              onToggleAll: _toggleModule,
            ),
          ],
          if (changes > 0) FormFooterBar(hint: hint, actions: actions),
        ],
      ),
    );
  }
}

/// One module: an "all" checkbox with the module name, then its
/// permissions. Side by side on wide screens, stacked on narrow ones.
class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.module,
    required this.selected,
    required this.locked,
    required this.enabled,
    required this.onToggle,
    required this.onToggleAll,
  });

  final PermissionModuleModel module;
  final Set<String> selected;

  /// Checked and not changeable (your own "Manage users and permissions").
  final Set<String> locked;
  final bool enabled;
  final void Function(String key, {required bool on}) onToggle;
  final void Function(PermissionModuleModel module, {required bool on})
  onToggleAll;

  static const double _sideBySideMinWidth = 640;
  static const double _moduleWidth = 240;

  @override
  Widget build(BuildContext context) {
    final keys = module.permissions.map((p) => p.key).toList();
    final on = keys.where(selected.contains).length;
    final all = on == keys.length;

    // Holding other permissions of a module without its "view" one makes
    // them unusable in the app, which is easy to miss.
    final view = module.permissions
        .where((p) => p.action == 'view')
        .firstOrNull;
    final missingView = view != null && on > 0 && !selected.contains(view.key);

    final header = _Check(
      value: all ? true : (on == 0 ? false : null),
      enabled: enabled && !keys.every(locked.contains),
      semanticLabel: 'All ${module.label} permissions',
      onChanged: () => onToggleAll(module, on: !all),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(module.label, style: AppTextStyles.bodySemibold),
          Text(
            '$on of ${keys.length}',
            style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );

    final permissions = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.s4,
      children: [
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s4,
          children: [
            for (final p in module.permissions)
              _Check(
                value: selected.contains(p.key),
                enabled: enabled && !locked.contains(p.key),
                semanticLabel: p.label,
                onChanged: () => onToggle(p.key, on: !selected.contains(p.key)),
                child: Text(p.label, style: AppTextStyles.body),
              ),
          ],
        ),
        if (missingView)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.s8),
            child: Text(
              'Without "${view.label}", these permissions cannot be used.',
              style: AppTextStyles.caption.copyWith(color: AppColors.warningFg),
            ),
          ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s8,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth >= _sideBySideMinWidth
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: _moduleWidth, child: header),
                  Expanded(child: permissions),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSpacing.s24,
                    ),
                    child: permissions,
                  ),
                ],
              ),
      ),
    );
  }
}

/// A checkbox with its label as one tap target. [value] null is "some".
class _Check extends StatelessWidget {
  const _Check({
    required this.value,
    required this.enabled,
    required this.semanticLabel,
    required this.onChanged,
    required this.child,
  });

  final bool? value;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback onChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final minHeight = context.usesTouchInput ? AppSizes.minTouchTarget : 40.0;
    return MergeSemantics(
      child: InkWell(
        onTap: enabled ? onChanged : null,
        borderRadius: AppRadius.mdAll,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.s10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: semanticLabel,
                  child: Checkbox(
                    value: value,
                    tristate: value == null,
                    onChanged: enabled ? (_) => onChanged() : null,
                  ),
                ),
                Flexible(child: ExcludeSemantics(child: child)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
