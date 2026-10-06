import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:kc_admin_portal/shared/models/json_converters.dart';

part 'employee_import_models.freezed.dart';
part 'employee_import_models.g.dart';

/// The employee fields an Excel column can fill (docs/ARCHITECTURE_MULTI_ORG.md
/// §D), matching the employee model. Email is not one: employees have none.
enum ImportField {
  name('Employee name', isRequired: true),
  ecNumber('EC number', isRequired: true),
  mobile('Mobile number', isRequired: true),
  department('Department', isRequired: true),
  position('Position', isRequired: true),
  joiningDate('Joining date', isRequired: true),
  status('Status'),
  shiftStart('Shift start'),
  shiftEnd('Shift end'),
  breakMinutes('Break (minutes)'),
  weeklyOffs('Weekly off');

  const ImportField(this.label, {this.isRequired = false});

  final String label;
  final bool isRequired;

  static ImportField? fromKey(String? key) =>
      values.where((f) => f.name == key).firstOrNull;
}

/// What to do with a row whose EC number already exists.
@JsonEnum(fieldRename: FieldRename.snake)
enum DuplicateStrategy {
  /// Leave the existing employee as it is.
  skip,

  /// Overwrite only the mapped, non-empty cells (never the schedule).
  update,
}

/// Where an import is: uploaded (mapping next), validated (review next),
/// importing (running), completed or failed.
@JsonEnum(fieldRename: FieldRename.snake)
enum ImportStatus { uploaded, validated, importing, completed, failed, unknown }

/// A row's state after checking, and after importing.
@JsonEnum(fieldRename: FieldRename.snake)
enum ImportRowStatus {
  valid,
  warning,
  error,
  imported,
  updated,
  skipped,
  failed,
  unknown;

  bool get willBeImported => this == valid || this == warning;

  /// Shown as a problem in the review (or the report).
  bool get isProblem => this == error || this == failed;
}

/// Totals after checking: rows that will be imported or updated (valid, or
/// valid with a warning), rows that won't (errors), and existing employees
/// that will be left as they are (skipped).
@freezed
abstract class ImportCountsModel with _$ImportCountsModel {
  const factory ImportCountsModel({
    @Default(0) int valid,
    @Default(0) int warnings,
    @Default(0) int errors,

    /// Existing employees left as they are (Skip, or nothing to change).
    @Default(0) int skipped,
  }) = _ImportCountsModel;

  factory ImportCountsModel.fromJson(Map<String, dynamic> json) =>
      _$ImportCountsModelFromJson(json);
}

/// Totals after importing.
@freezed
abstract class ImportResultModel with _$ImportResultModel {
  const factory ImportResultModel({
    @Default(0) int imported,
    @Default(0) int updated,
    @Default(0) int skipped,
    @Default(0) int failed,
  }) = _ImportResultModel;

  factory ImportResultModel.fromJson(Map<String, dynamic> json) =>
      _$ImportResultModelFromJson(json);
}

/// One import (`/employee-imports/{id}`). The server keeps the parsed rows,
/// never the file, and deletes unconfirmed imports after 24 hours.
@freezed
abstract class EmployeeImportModel with _$EmployeeImportModel {
  const factory EmployeeImportModel({
    @JsonKey(fromJson: idFromJson) required String id,
    required String fileName,
    @JsonKey(unknownEnumValue: ImportStatus.unknown)
    required ImportStatus status,

    /// The file's column headers, in order.
    required List<String> headers,

    /// The first few rows, as text, for the mapping screen.
    @Default(<List<String>>[]) List<List<String>> sampleRows,
    required int rowCount,

    /// Header → field key, guessed from the header names.
    @Default(<String, String?>{}) Map<String, String?> suggestedMapping,

    /// What was last checked with (after `validated`).
    Map<String, String?>? mapping,
    @JsonKey(unknownEnumValue: DuplicateStrategy.skip)
    DuplicateStrategy? duplicateStrategy,
    @Default(false) bool createMissing,
    @Default(false) bool assignEcNumbers,
    ImportCountsModel? counts,

    /// While importing: rows done so far.
    @Default(0) int processed,
    ImportResultModel? result,
  }) = _EmployeeImportModel;

  const EmployeeImportModel._();

  factory EmployeeImportModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeImportModelFromJson(json);

  /// Rows that would be imported or updated.
  int get importable => (counts?.valid ?? 0) + (counts?.warnings ?? 0);
}

/// Body of `PUT /employee-imports/{id}`: how to read the file.
@freezed
abstract class ImportOptionsModel with _$ImportOptionsModel {
  const factory ImportOptionsModel({
    /// Header → field key; null or absent ignores the column.
    required Map<String, String?> mapping,
    required DuplicateStrategy duplicateStrategy,

    /// Create departments and positions the organization doesn't have yet.
    @Default(false) bool createMissing,

    /// Give rows without an EC number the next free one.
    @Default(false) bool assignEcNumbers,
  }) = _ImportOptionsModel;

  factory ImportOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$ImportOptionsModelFromJson(json);
}

/// One field an update would change: "Department: Tailor → Production".
@freezed
abstract class ImportChangeModel with _$ImportChangeModel {
  const factory ImportChangeModel({
    required String field,
    String? before,
    String? after,
  }) = _ImportChangeModel;

  factory ImportChangeModel.fromJson(Map<String, dynamic> json) =>
      _$ImportChangeModelFromJson(json);
}

/// One row of the file after checking (or importing).
@freezed
abstract class ImportRowModel with _$ImportRowModel {
  const factory ImportRowModel({
    /// The row number in the Excel file (the header is row 1).
    required int rowNumber,
    @JsonKey(unknownEnumValue: ImportRowStatus.unknown)
    required ImportRowStatus status,
    String? ecNumber,
    String? name,
    @Default(<String>[]) List<String> messages,
    @Default(<ImportChangeModel>[]) List<ImportChangeModel> changes,
  }) = _ImportRowModel;

  factory ImportRowModel.fromJson(Map<String, dynamic> json) =>
      _$ImportRowModelFromJson(json);
}

/// `GET /employee-imports/{id}/rows`.
@freezed
abstract class ImportRowsPageModel with _$ImportRowsPageModel {
  const factory ImportRowsPageModel({
    required List<ImportRowModel> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _ImportRowsPageModel;

  factory ImportRowsPageModel.fromJson(Map<String, dynamic> json) =>
      _$ImportRowsPageModelFromJson(json);
}

/// Which rows the review shows.
enum ImportRowFilter {
  problems('Errors and warnings'),
  errors('Errors'),
  warnings('Warnings'),
  all('All rows');

  const ImportRowFilter(this.label);

  final String label;

  /// The `status` query parameter.
  String? get query => switch (this) {
    problems => 'problems',
    errors => 'error',
    warnings => 'warning',
    all => null,
  };
}
