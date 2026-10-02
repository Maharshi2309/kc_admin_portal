import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';

/// The permission catalogue. Throws an `AppException` on failure.
abstract interface class AccessRepository {
  Future<List<PermissionModuleModel>> permissions();
}
