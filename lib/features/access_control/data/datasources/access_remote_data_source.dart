import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_mock_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';

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
    return AccessMockDataSource(
      guard: ref.watch(mockGuardProvider),
      store: ref.watch(mockAccessStoreProvider),
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return AccessApiDataSource(ref.watch(apiClientProvider));
});
