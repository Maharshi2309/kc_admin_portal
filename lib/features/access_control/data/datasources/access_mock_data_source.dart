import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_remote_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';

/// DEV ONLY (`USE_MOCK_API=true`): the permission catalogue endpoint over
/// [MockAccessStore].
class AccessMockDataSource implements AccessRemoteDataSource {
  AccessMockDataSource({
    required this.store,
    this.guard = const MockGuard.allowAll(),
    this.latency = Duration.zero,
  });

  final MockAccessStore store;

  /// Checks the signed-in user's permissions, like the backend (§4.2).
  final MockGuard guard;
  final Duration latency;

  @override
  Future<List<PermissionModuleModel>> permissions() async {
    await Future<void>.delayed(latency);
    guard.require(AppPermission.permissionManage);
    return store.catalogue();
  }
}
