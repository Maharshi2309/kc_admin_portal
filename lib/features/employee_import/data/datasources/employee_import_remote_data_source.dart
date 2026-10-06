import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/env.dart';
import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

/// Importing employees from an Excel file (docs/ARCHITECTURE_MULTI_ORG.md
/// §D). The server reads the file, checks every row against its data and
/// writes the employees; the app picks the file, maps the columns and shows
/// the results.
abstract interface class EmployeeImportRemoteDataSource {
  /// The official template (`.xlsx`).
  Future<Uint8List> template();

  /// Uploads [bytes]: the server reads the headers and rows.
  Future<EmployeeImportModel> upload(Uint8List bytes, String fileName);

  /// Checks every row with [options].
  Future<EmployeeImportModel> check(String id, ImportOptionsModel options);

  Future<ImportRowsPageModel> rows(
    String id, {
    ImportRowFilter filter = ImportRowFilter.problems,
    int page = 1,
    int pageSize = 20,
  });

  /// Imports the rows that passed; checks them again first.
  Future<EmployeeImportModel> confirm(String id);

  /// The import's current state (polled while importing).
  Future<EmployeeImportModel> get(String id);

  /// The rows that weren't imported, with the reason (`.xlsx`).
  Future<Uint8List> report(String id);

  /// Abandons an import that hasn't been confirmed.
  Future<void> cancel(String id);
}

/// The largest file and row count accepted (the server checks too).
const int maxImportBytes = 5 * 1024 * 1024;
const int maxImportRows = 5000;

class EmployeeImportApiDataSource implements EmployeeImportRemoteDataSource {
  EmployeeImportApiDataSource(this._client);

  final ApiClient _client;

  static EmployeeImportModel _import(Object? json) =>
      EmployeeImportModel.fromJson(json! as Map<String, dynamic>);

  @override
  Future<Uint8List> template() =>
      _client.getBytes(ApiConstants.employeeImportTemplate);

  @override
  Future<EmployeeImportModel> upload(Uint8List bytes, String fileName) =>
      _client.post(
        ApiConstants.employeeImports,
        body: FormData.fromMap({
          'file': MultipartFile.fromBytes(bytes, filename: fileName),
        }),
        parse: _import,
      );

  @override
  Future<EmployeeImportModel> check(String id, ImportOptionsModel options) =>
      _client.put(
        ApiConstants.employeeImport(id),
        body: options.toJson(),
        parse: _import,
      );

  @override
  Future<ImportRowsPageModel> rows(
    String id, {
    ImportRowFilter filter = ImportRowFilter.problems,
    int page = 1,
    int pageSize = 20,
  }) => _client.get(
    ApiConstants.employeeImportRows(id),
    query: {'status': ?filter.query, 'page': page, 'pageSize': pageSize},
    parse: (json) =>
        ImportRowsPageModel.fromJson(json! as Map<String, dynamic>),
  );

  @override
  Future<EmployeeImportModel> confirm(String id) =>
      _client.post(ApiConstants.employeeImportConfirm(id), parse: _import);

  @override
  Future<EmployeeImportModel> get(String id) =>
      _client.get(ApiConstants.employeeImport(id), parse: _import);

  @override
  Future<Uint8List> report(String id) =>
      _client.getBytes(ApiConstants.employeeImportReport(id));

  @override
  Future<void> cancel(String id) => _client.delete(
    ApiConstants.employeeImport(id),
    parse: ApiClient.ignoreBody,
  );
}

final employeeImportRemoteDataSourceProvider =
    Provider<EmployeeImportRemoteDataSource>((ref) {
      if (ref.watch(envProvider).useMockApi) {
        return ref.watch(mockActiveTenantProvider).employeeImport;
      }
      // A new organization means new data: rebuild (§C).
      ref.watch(activeOrganizationIdProvider);
      return EmployeeImportApiDataSource(ref.watch(apiClientProvider));
    });
