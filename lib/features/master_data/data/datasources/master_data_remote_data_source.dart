import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/shared/models/list_entry.dart';

abstract interface class MasterDataRemoteDataSource {
  Future<List<ListEntry>> listDepartments();

  Future<List<ListEntry>> listPositions();
}

class MasterDataApiDataSource implements MasterDataRemoteDataSource {
  MasterDataApiDataSource(this._client);

  final ApiClient _client;

  static List<ListEntry> _entries(Object? json) =>
      (json! as List<Object?>)
          .map((item) => ListEntry.fromJson(item! as Map<String, dynamic>))
          .toList();

  @override
  Future<List<ListEntry>> listDepartments() =>
      _client.get(ApiConstants.departments, parse: _entries);

  @override
  Future<List<ListEntry>> listPositions() =>
      _client.get(ApiConstants.positions, parse: _entries);
}

final masterDataRemoteDataSourceProvider =
    Provider<MasterDataRemoteDataSource>(
      (ref) => MasterDataApiDataSource(ref.watch(apiClientProvider)),
    );
