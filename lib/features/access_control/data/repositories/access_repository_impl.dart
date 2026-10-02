import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/access_control/data/datasources/access_remote_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/access_control/domain/repositories/access_repository.dart';

class AccessRepositoryImpl implements AccessRepository {
  AccessRepositoryImpl(this._remote);

  final AccessRemoteDataSource _remote;

  @override
  Future<List<PermissionModuleModel>> permissions() => _remote.permissions();
}

final accessRepositoryProvider = Provider<AccessRepository>(
  (ref) => AccessRepositoryImpl(ref.watch(accessRemoteDataSourceProvider)),
);
