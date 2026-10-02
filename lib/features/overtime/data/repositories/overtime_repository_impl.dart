import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_remote_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';
import 'package:kc_admin_portal/features/overtime/domain/repositories/overtime_repository.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  OvertimeRepositoryImpl(this._remote);

  final OvertimeRemoteDataSource _remote;

  @override
  Future<OvertimeReportModel> report(
    String employeeId, {
    required DateTime from,
    required DateTime to,
  }) => _remote.report(employeeId, from: from, to: to);
}

final overtimeRepositoryProvider = Provider<OvertimeRepository>(
  (ref) => OvertimeRepositoryImpl(ref.watch(overtimeRemoteDataSourceProvider)),
);
