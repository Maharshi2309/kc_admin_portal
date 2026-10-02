import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/master_data/data/datasources/master_data_remote_data_source.dart';
import 'package:kc_admin_portal/features/master_data/data/models/master_data_models.dart';
import 'package:kc_admin_portal/features/master_data/domain/repositories/master_data_repository.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  MasterDataRepositoryImpl(this._remote);

  final MasterDataRemoteDataSource _remote;

  @override
  Future<List<DepartmentModel>> departments() => _remote.departments();

  @override
  Future<List<DesignationModel>> designations(String departmentId) =>
      _remote.designations(departmentId);
}

final masterDataRepositoryProvider = Provider<MasterDataRepository>(
  (ref) =>
      MasterDataRepositoryImpl(ref.watch(masterDataRemoteDataSourceProvider)),
);
