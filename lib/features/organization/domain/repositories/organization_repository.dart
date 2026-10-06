import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// The active organization's profile, settings, departments and
/// positions. All methods throw an `AppException` on failure.
abstract interface class OrganizationRepository {
  Future<OrganizationModel> profile();

  Future<OrganizationModel> updateProfile({
    required String name,
    required String timezone,
  });

  Future<OrganizationModel> uploadLogo(List<int> bytes, String fileName);

  Future<OrganizationModel> removeLogo();

  Future<OrganizationSettingsModel> settings();

  Future<OrganizationSettingsModel> updateSettings(
    OrganizationSettingsModel settings,
  );

  Future<LeavePolicyModel> leavePolicy();

  Future<LeavePolicyModel> updateLeavePolicy(LeavePolicyModel policy);

  Future<List<CatalogItemModel>> catalog(CatalogKind kind);

  Future<CatalogItemModel> addCatalogItem(CatalogKind kind, String name);

  Future<CatalogItemModel> renameCatalogItem(
    CatalogKind kind,
    String id,
    String name,
  );

  Future<CatalogItemModel> setCatalogItemActive(
    CatalogKind kind,
    String id, {
    required bool isActive,
  });
}
