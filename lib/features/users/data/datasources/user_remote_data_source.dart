import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_mock_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';

/// Staff login accounts over the API. Throws an `AppException` on failure.
abstract interface class UserRemoteDataSource {
  Future<UserAccountListModel> list(UserQuery query);

  Future<UserAccountModel> getById(String id);

  Future<UserAccountModel> create(UserAccountInput input);

  Future<UserAccountModel> update(String id, UserAccountUpdate input);

  /// Replaces the user's permissions with [keys].
  Future<UserAccountModel> setPermissions(String id, List<String> keys);
}

class UserApiDataSource implements UserRemoteDataSource {
  UserApiDataSource(this._client);

  final ApiClient _client;

  static UserAccountModel _user(Object? json) =>
      UserAccountModel.fromJson(json! as Map<String, dynamic>);

  @override
  Future<UserAccountListModel> list(UserQuery query) => _client.get(
    ApiConstants.users,
    query: query.toQueryParameters(),
    parse: (json) =>
        UserAccountListModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<UserAccountModel> getById(String id) =>
      _client.get(ApiConstants.user(id), parse: _user);

  @override
  Future<UserAccountModel> create(UserAccountInput input) =>
      _client.post(ApiConstants.users, body: input.toJson(), parse: _user);

  @override
  Future<UserAccountModel> update(String id, UserAccountUpdate input) =>
      _client.patch(ApiConstants.user(id), body: input.toJson(), parse: _user);

  @override
  Future<UserAccountModel> setPermissions(String id, List<String> keys) =>
      _client.put(
        ApiConstants.userPermissions(id),
        body: {'permissions': keys},
        parse: _user,
      );
}

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  if (ref.watch(envProvider).useMockApi) {
    return UserMockDataSource(
      guard: ref.watch(mockGuardProvider),
      store: ref.watch(mockAccessStoreProvider),
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return UserApiDataSource(ref.watch(apiClientProvider));
});
