import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/domain/repositories/organization_repository.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl(this._remote);

  final OrganizationRemoteDataSource _remote;

  @override
  Future<OrganizationModel> profile() => _remote.profile();

  @override
  Future<OrganizationModel> updateProfile({
    required String name,
    required String timezone,
  }) => _remote.updateProfile(name: name.trim(), timezone: timezone);

  @override
  Future<OrganizationModel> uploadLogo(List<int> bytes, String fileName) =>
      _remote.uploadLogo(bytes, fileName);

  @override
  Future<OrganizationModel> removeLogo() => _remote.removeLogo();

  @override
  Future<OrganizationSettingsModel> settings() => _remote.settings();

  @override
  Future<OrganizationSettingsModel> updateSettings(
    OrganizationSettingsModel settings,
  ) => _remote.updateSettings(
    settings.copyWith(
      ecNumberPrefix: settings.ecNumberPrefix.trim().toUpperCase(),
    ),
  );

  @override
  Future<LeavePolicyModel> leavePolicy() => _remote.leavePolicy();

  @override
  Future<LeavePolicyModel> updateLeavePolicy(LeavePolicyModel policy) =>
      _remote.updateLeavePolicy(
        policy.copyWith(
          paidLeaveName: policy.paidLeaveName.trim(),
          unpaidLeaveName: policy.unpaidLeaveName.trim(),
        ),
      );

  @override
  Future<List<CatalogItemModel>> catalog(CatalogKind kind) =>
      _remote.catalog(kind);

  @override
  Future<CatalogItemModel> addCatalogItem(CatalogKind kind, String name) =>
      _remote.addCatalogItem(kind, name.trim());

  @override
  Future<CatalogItemModel> renameCatalogItem(
    CatalogKind kind,
    String id,
    String name,
  ) => _remote.updateCatalogItem(kind, id, name: name.trim());

  @override
  Future<CatalogItemModel> setCatalogItemActive(
    CatalogKind kind,
    String id, {
    required bool isActive,
  }) => _remote.updateCatalogItem(kind, id, isActive: isActive);
}

final organizationRepositoryProvider = Provider<OrganizationRepository>(
  (ref) => OrganizationRepositoryImpl(
    ref.watch(organizationRemoteDataSourceProvider),
  ),
);
