import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/users/data/datasources/user_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remote);

  final UserRemoteDataSource _remote;

  @override
  Future<UserAccountListModel> list(UserQuery query) =>
      _remote.list(query.copyWith(search: query.search.trim()));

  @override
  Future<UserAccountModel> getById(String id) => _remote.getById(id);

  @override
  Future<UserAccountModel> create(UserAccountInput input) => _remote.create(
    input.copyWith(name: input.name.trim(), email: input.email.trim()),
  );

  @override
  Future<UserAccountModel> update(String id, UserAccountUpdate input) =>
      _remote.update(
        id,
        input.copyWith(name: input.name.trim(), email: input.email.trim()),
      );

  @override
  Future<UserAccountModel> setPermissions(String id, List<String> keys) =>
      _remote.setPermissions(id, keys.toSet().toList()..sort());

  @override
  Future<void> cancelInvitation(String id) => _remote.cancelInvitation(id);

  @override
  Future<void> resendInvitation(String id) => _remote.resendInvitation(id);
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider)),
);
