import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the user endpoints over
/// [MockAccessStore]. All of them need `permission.manage`.
class UserMockDataSource implements UserRemoteDataSource {
  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;

  UserMockDataSource({
    this.guard = const MockGuard.allowAll(),
    required this.store,
    this.latency = Duration.zero,
  });

  final MockAccessStore store;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  @override
  Future<UserAccountListModel> list(UserQuery query) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    return store.listUsers(query);
  }

  @override
  Future<UserAccountModel> getById(String id) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    return store.user(id);
  }

  @override
  Future<UserAccountModel> create(UserAccountInput input) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    return store.createUser(input);
  }

  @override
  Future<UserAccountModel> update(String id, UserAccountUpdate input) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    return store.updateUser(id, input);
  }

  @override
  Future<UserAccountModel> setPermissions(String id, List<String> keys) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    return store.setPermissions(id, keys);
  }

  @override
  Future<void> cancelInvitation(String id) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    store.cancelInvitation(id);
  }

  @override
  Future<void> resendInvitation(String id) async {
    await _wait();
    guard.require(AppPermission.permissionManage);
    store.pendingInvitation(id);
  }
}
