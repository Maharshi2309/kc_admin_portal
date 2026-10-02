import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_mock_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/login_response_model.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

/// Auth endpoints of the REST API.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  /// The user the current token belongs to.
  Future<UserModel> me();

  Future<void> logout();
}

class AuthApiDataSource implements AuthRemoteDataSource {
  AuthApiDataSource(this._client);

  final ApiClient _client;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) => _client.post(
    ApiConstants.login,
    body: {'email': email, 'password': password},
    parse: (json) => LoginResponseModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<UserModel> me() => _client.get(
    ApiConstants.me,
    parse: (json) => UserModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<void> logout() =>
      _client.post(ApiConstants.logout, parse: ApiClient.ignoreBody);
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final env = ref.watch(envProvider);
  if (env.useMockApi) {
    return AuthMockDataSource(
      store: ref.watch(mockAccessStoreProvider),
      readToken: ref.watch(tokenStorageProvider).readToken,
      latency: ref.watch(mockLatencyProvider),
    );
  }
  return AuthApiDataSource(ref.watch(apiClientProvider));
});
