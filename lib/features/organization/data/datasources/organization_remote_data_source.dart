import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';

/// The active organization's profile, settings and lists
/// (docs/ARCHITECTURE_MULTI_ORG.md §F). No organization id is ever sent:
/// the server works on the session's organization.
abstract interface class OrganizationRemoteDataSource {
  Future<OrganizationModel> profile();

  Future<OrganizationModel> updateProfile({
    required String name,
    required String timezone,
  });

  /// PNG or JPEG, at most [maxLogoBytes].
  Future<OrganizationModel> uploadLogo(List<int> bytes, String fileName);

  Future<OrganizationModel> removeLogo();

  Future<OrganizationSettingsModel> settings();

  Future<OrganizationSettingsModel> updateSettings(
    OrganizationSettingsModel settings,
  );

  /// The paid and unpaid leave types and how paid leave is earned.
  Future<LeavePolicyModel> leavePolicy();

  Future<LeavePolicyModel> updateLeavePolicy(LeavePolicyModel policy);

  /// Departments or positions, active and deactivated, by name.
  Future<List<CatalogItemModel>> catalog(CatalogKind kind);

  Future<CatalogItemModel> addCatalogItem(CatalogKind kind, String name);

  /// Renames and/or (de)activates.
  Future<CatalogItemModel> updateCatalogItem(
    CatalogKind kind,
    String id, {
    String? name,
    bool? isActive,
  });
}

/// The largest logo accepted (the server checks too).
const int maxLogoBytes = 1024 * 1024;

class OrganizationApiDataSource implements OrganizationRemoteDataSource {
  OrganizationApiDataSource(this._client);

  final ApiClient _client;

  static Map<String, dynamic> _map(Object? json) =>
      json! as Map<String, dynamic>;

  static OrganizationModel _organization(Object? json) =>
      OrganizationModel.fromJson(_map(json));

  static OrganizationSettingsModel _settings(Object? json) =>
      OrganizationSettingsModel.fromJson(_map(json));

  static CatalogItemModel _item(Object? json) =>
      CatalogItemModel.fromJson(_map(json));

  static String _path(CatalogKind kind) => kind == CatalogKind.departments
      ? ApiConstants.departments
      : ApiConstants.positions;

  @override
  Future<OrganizationModel> profile() =>
      _client.get(ApiConstants.organization, parse: _organization);

  @override
  Future<OrganizationModel> updateProfile({
    required String name,
    required String timezone,
  }) => _client.patch(
    ApiConstants.organization,
    body: {'name': name, 'timezone': timezone},
    parse: _organization,
  );

  @override
  Future<OrganizationModel> uploadLogo(List<int> bytes, String fileName) =>
      _client.post(
        ApiConstants.organizationLogo,
        body: FormData.fromMap({
          'logo': MultipartFile.fromBytes(bytes, filename: fileName),
        }),
        parse: _organization,
      );

  @override
  Future<OrganizationModel> removeLogo() =>
      _client.delete(ApiConstants.organizationLogo, parse: _organization);

  @override
  Future<OrganizationSettingsModel> settings() =>
      _client.get(ApiConstants.organizationSettings, parse: _settings);

  @override
  Future<OrganizationSettingsModel> updateSettings(
    OrganizationSettingsModel settings,
  ) => _client.patch(
    ApiConstants.organizationSettings,
    body: settings.toJson(),
    parse: _settings,
  );

  static LeavePolicyModel _policy(Object? json) =>
      LeavePolicyModel.fromJson(_map(json));

  @override
  Future<LeavePolicyModel> leavePolicy() =>
      _client.get(ApiConstants.leavePolicy, parse: _policy);

  @override
  Future<LeavePolicyModel> updateLeavePolicy(LeavePolicyModel policy) => _client
      .patch(ApiConstants.leavePolicy, body: policy.toJson(), parse: _policy);

  @override
  Future<List<CatalogItemModel>> catalog(CatalogKind kind) => _client.get(
    _path(kind),
    parse: (json) => [for (final item in json! as List<Object?>) _item(item)],
  );

  @override
  Future<CatalogItemModel> addCatalogItem(CatalogKind kind, String name) =>
      _client.post(_path(kind), body: {'name': name}, parse: _item);

  @override
  Future<CatalogItemModel> updateCatalogItem(
    CatalogKind kind,
    String id, {
    String? name,
    bool? isActive,
  }) => _client.patch(
    '${_path(kind)}/$id',
    body: {'name': ?name, 'isActive': ?isActive},
    parse: _item,
  );
}

final organizationRemoteDataSourceProvider =
    Provider<OrganizationRemoteDataSource>((ref) {
      if (ref.watch(envProvider).useMockApi) {
        return ref.watch(mockActiveTenantProvider).organization;
      }
      // A new organization means new data: rebuild (§C).
      ref.watch(activeOrganizationIdProvider);
      return OrganizationApiDataSource(ref.watch(apiClientProvider));
    });
