import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/master_data/data/datasources/master_data_mock_data_source.dart';
import 'package:kc_admin_portal/features/master_data/data/models/master_data_models.dart';

abstract interface class MasterDataRemoteDataSource {
  Future<List<DepartmentModel>> departments();

  Future<List<DesignationModel>> designations(String departmentId);
}

class MasterDataApiDataSource implements MasterDataRemoteDataSource {
  MasterDataApiDataSource(this._client);

  final ApiClient _client;

  static List<T> _list<T>(
    Object? json,
    T Function(Map<String, dynamic>) fromJson,
  ) => (json! as List<Object?>)
      .map((item) => fromJson(item! as Map<String, dynamic>))
      .toList();

  @override
  Future<List<DepartmentModel>> departments() => _client.get(
    ApiConstants.departments,
    parse: (json) => _list(json, DepartmentModel.fromJson),
  );

  @override
  Future<List<DesignationModel>> designations(String departmentId) =>
      _client.get(
        ApiConstants.departmentDesignations(departmentId),
        parse: (json) => _list(json, DesignationModel.fromJson),
      );
}

final masterDataRemoteDataSourceProvider = Provider<MasterDataRemoteDataSource>(
  (ref) {
    if (ref.watch(envProvider).useMockApi) {
      return MasterDataMockDataSource(
        guard: ref.watch(mockGuardProvider),
        latency: ref.watch(mockLatencyProvider),
      );
    }
    return MasterDataApiDataSource(ref.watch(apiClientProvider));
  },
);
