import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/master_data/data/datasources/master_data_remote_data_source.dart';
import 'package:kc_admin_portal/features/master_data/domain/repositories/master_data_repository.dart';
import 'package:kc_admin_portal/shared/models/list_entry.dart';

class MasterDataRepositoryImpl implements MasterDataRepository {
  MasterDataRepositoryImpl(this._remote);

  final MasterDataRemoteDataSource _remote;

  @override
  Future<List<ListEntry>> departments() => _remote.listDepartments();

  @override
  Future<List<ListEntry>> positions() => _remote.listPositions();
}

final masterDataRepositoryProvider = Provider<MasterDataRepository>(
  (ref) => MasterDataRepositoryImpl(
    ref.watch(masterDataRemoteDataSourceProvider),
  ),
);
