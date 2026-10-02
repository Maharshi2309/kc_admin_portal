import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';

/// Staff login accounts. All methods throw an `AppException` on failure; the
/// backend stops people removing their own access and never leaves nobody
/// able to manage permissions.
abstract interface class UserRepository {
  Future<UserAccountListModel> list(UserQuery query);

  Future<UserAccountModel> getById(String id);

  Future<UserAccountModel> create(UserAccountInput input);

  Future<UserAccountModel> update(String id, UserAccountUpdate input);

  Future<UserAccountModel> setPermissions(String id, List<String> keys);
}
