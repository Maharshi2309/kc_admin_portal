import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/storage/local_storage.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.tokenStorage});

  final AuthRemoteDataSource remote;
  final TokenStorage tokenStorage;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
    bool keepSignedIn = true,
  }) async {
    final response = await remote.login(email: email, password: password);
    await tokenStorage.writeToken(response.accessToken, persist: keepSignedIn);
    return response.user;
  }

  @override
  Future<UserModel?> restoreSession() async {
    final token = await tokenStorage.readToken();
    if (token == null || token.isEmpty) return null;

    try {
      return await remote.me();
    } on UnauthorizedException {
      await tokenStorage.clear();
      return null;
    }
    // Other errors (offline, server down) propagate so the app can offer a
    // retry instead of silently signing the user out.
  }

  @override
  Future<void> signOut() async {
    try {
      await remote.logout();
    } on AppException {
      // Signing out locally must always succeed, even offline.
    } finally {
      await tokenStorage.clear();
    }
  }

  @override
  Future<void> clearSession() => tokenStorage.clear();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remote: ref.watch(authRemoteDataSourceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);
