import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

/// The permission catalogue over the API. Throws an `AppException` on
/// failure. (Each user's permissions are part of the user endpoints.)
abstract interface class AccessRemoteDataSource {
  /// The permission catalogue, grouped by module.
  Future<List<PermissionModuleModel>> permissions();
}

class AccessApiDataSource implements AccessRemoteDataSource {
  AccessApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<List<PermissionModuleModel>> permissions() => _client.get(
    ApiConstants.permissions,
    parse: (json) => (json! as List)
        .map((m) => PermissionModuleModel.fromJson(m! as Map<String, dynamic>))
        .toList(),
  );
}

final accessRemoteDataSourceProvider = Provider<AccessRemoteDataSource>((ref) {
  if (ref.watch(envProvider).useMockApi) {
    return ref.watch(mockActiveTenantProvider).accessSource;
  }
  // A new organization means new data: rebuild (docs/ARCHITECTURE_MULTI_ORG.md §C).
  ref.watch(activeOrganizationScopeProvider);
  return AccessApiDataSource(ref.watch(apiClientProvider));
});
