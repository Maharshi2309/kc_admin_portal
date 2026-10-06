import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/data/repositories/organization_repository_impl.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';

/// The active organization's working defaults (EC number prefix, lateness,
/// default schedule), kept while the organization is open.
final organizationSettingsProvider = FutureProvider<OrganizationSettingsModel>(
  (ref) => ref.watch(organizationRepositoryProvider).settings(),
  retry: (_, _) => null,
);

/// How the organization's paid leave is earned, and its leave type names.
final leavePolicyProvider = FutureProvider<LeavePolicyModel>(
  (ref) => ref.watch(organizationRepositoryProvider).leavePolicy(),
  retry: (_, _) => null,
);

/// The organization's departments or positions, active and deactivated.
final catalogProvider =
    FutureProvider.family<List<CatalogItemModel>, CatalogKind>(
      (ref, kind) => ref.watch(organizationRepositoryProvider).catalog(kind),
      retry: (_, _) => null,
    );

/// What forms and filters offer: the active items, as references.
final catalogChoicesProvider = Provider.family<List<NamedRef>, CatalogKind>(
  (ref, kind) => [
    for (final item
        in ref.watch(catalogProvider(kind)).value ?? const <CatalogItemModel>[])
      if (item.isActive) NamedRef(id: item.id, name: item.name),
  ],
);

/// Saving settings, the profile, the logo and list items: the keys being
/// saved (for spinners), and the error of each, shown by the screen.
class OrganizationSettingsController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Runs [action] under [key]; returns the error, or null on success.
  Future<Object?> _run(String key, Future<void> Function() action) async {
    if (state.contains(key)) return null;
    state = {...state, key};
    try {
      await action();
      return null;
    } on Object catch (error) {
      return error;
    } finally {
      if (ref.mounted) state = {...state}..remove(key);
    }
  }

  /// Name, logo and time zone show in the sidebar and the organizations
  /// list, which come from the signed-in user: reload it.
  Future<void> _profileChanged() =>
      ref.read(authControllerProvider.notifier).refresh();

  Future<Object?> updateProfile({
    required String name,
    required String timezone,
  }) => _run('profile', () async {
    await ref
        .read(organizationRepositoryProvider)
        .updateProfile(name: name, timezone: timezone);
    await _profileChanged();
  });

  Future<Object?> uploadLogo(List<int> bytes, String fileName) =>
      _run('logo', () async {
        await ref
            .read(organizationRepositoryProvider)
            .uploadLogo(bytes, fileName);
        await _profileChanged();
      });

  Future<Object?> removeLogo() => _run('logo', () async {
    await ref.read(organizationRepositoryProvider).removeLogo();
    await _profileChanged();
  });

  Future<Object?> updateSettings(OrganizationSettingsModel settings) =>
      _run('settings', () async {
        await ref.read(organizationRepositoryProvider).updateSettings(settings);
        ref.invalidate(organizationSettingsProvider);
      });

  /// Balances are recalculated from the leave records, so everything that
  /// shows leave reloads.
  Future<Object?> updateLeavePolicy(LeavePolicyModel policy) => _run(
    'leave-policy',
    () async {
      await ref.read(organizationRepositoryProvider).updateLeavePolicy(policy);
      ref
        ..invalidate(leavePolicyProvider)
        ..invalidate(leaveTypesProvider);
      refreshAfterLeaveChange(ref);
    },
  );

  Future<Object?> addItem(CatalogKind kind, String name) => _run(
    '${kind.name}-new',
    () async {
      await ref.read(organizationRepositoryProvider).addCatalogItem(kind, name);
      ref.invalidate(catalogProvider(kind));
    },
  );

  Future<Object?> renameItem(CatalogKind kind, String id, String name) =>
      _run(id, () async {
        await ref
            .read(organizationRepositoryProvider)
            .renameCatalogItem(kind, id, name);
        _itemsChanged(kind);
      });

  Future<Object?> setItemActive(
    CatalogKind kind,
    String id, {
    required bool isActive,
  }) => _run(id, () async {
    await ref
        .read(organizationRepositoryProvider)
        .setCatalogItemActive(kind, id, isActive: isActive);
    _itemsChanged(kind);
  });

  /// A renamed department shows on every employee: reload what lists them.
  void _itemsChanged(CatalogKind kind) {
    ref
      ..invalidate(catalogProvider(kind))
      ..invalidate(employeeListProvider)
      ..invalidate(employeeDetailProvider);
  }
}

final organizationSettingsControllerProvider =
    NotifierProvider<OrganizationSettingsController, Set<String>>(
      OrganizationSettingsController.new,
    );
