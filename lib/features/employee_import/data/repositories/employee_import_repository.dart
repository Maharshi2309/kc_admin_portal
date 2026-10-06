import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_remote_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';

/// Importing employees from Excel. All methods throw an `AppException` on
/// failure.
class EmployeeImportRepository {
  EmployeeImportRepository(this._remote);

  final EmployeeImportRemoteDataSource _remote;

  Future<Uint8List> template() => _remote.template();

  Future<EmployeeImportModel> upload(Uint8List bytes, String fileName) =>
      _remote.upload(bytes, fileName);

  Future<EmployeeImportModel> check(String id, ImportOptionsModel options) =>
      _remote.check(id, options);

  Future<ImportRowsPageModel> rows(
    String id, {
    required ImportRowFilter filter,
    required int page,
    int pageSize = 20,
  }) => _remote.rows(id, filter: filter, page: page, pageSize: pageSize);

  Future<EmployeeImportModel> confirm(String id) => _remote.confirm(id);

  Future<EmployeeImportModel> get(String id) => _remote.get(id);

  Future<Uint8List> report(String id) => _remote.report(id);

  Future<void> cancel(String id) => _remote.cancel(id);
}

final employeeImportRepositoryProvider = Provider<EmployeeImportRepository>(
  (ref) => EmployeeImportRepository(
    ref.watch(employeeImportRemoteDataSourceProvider),
  ),
);
