import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/files/file_picking.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employee_import/data/repositories/employee_import_repository.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';

/// The four steps (docs/ARCHITECTURE_MULTI_ORG.md §D): upload a file, match
/// its columns, review the checked rows, and the result.
enum ImportStep {
  upload('Upload'),
  map('Match columns'),
  review('Review'),
  result('Result');

  const ImportStep(this.label);

  final String label;
}

/// Where the import is, and what the person has chosen so far.
class ImportFlowState {
  const ImportFlowState({
    this.step = ImportStep.upload,
    this.current,
    this.mapping = const {},
    this.duplicates = DuplicateStrategy.skip,
    this.createMissing = false,
    this.assignEcNumbers = false,
    this.busy = false,
    this.error,
  });

  final ImportStep step;
  final EmployeeImportModel? current;

  /// Header → field key (null: ignored).
  final Map<String, String?> mapping;
  final DuplicateStrategy duplicates;
  final bool createMissing;
  final bool assignEcNumbers;

  /// Uploading, checking or importing.
  final bool busy;

  /// The last action's error, shown on the step.
  final Object? error;

  /// Required fields that no column is matched to yet. With "Update
  /// existing" only the EC number is needed (new rows are checked one by
  /// one).
  List<ImportField> get missingFields {
    final chosen = mapping.values.whereType<String>().toSet();
    return [
      for (final field in ImportField.values)
        if (field.isRequired &&
            !chosen.contains(field.name) &&
            !(field == ImportField.ecNumber && assignEcNumbers) &&
            !(duplicates == DuplicateStrategy.update &&
                field != ImportField.ecNumber))
          field,
    ];
  }

  ImportFlowState copyWith({
    ImportStep? step,
    EmployeeImportModel? current,
    Map<String, String?>? mapping,
    DuplicateStrategy? duplicates,
    bool? createMissing,
    bool? assignEcNumbers,
    bool? busy,
    Object? error,
    bool clearError = false,
  }) => ImportFlowState(
    step: step ?? this.step,
    current: current ?? this.current,
    mapping: mapping ?? this.mapping,
    duplicates: duplicates ?? this.duplicates,
    createMissing: createMissing ?? this.createMissing,
    assignEcNumbers: assignEcNumbers ?? this.assignEcNumbers,
    busy: busy ?? this.busy,
    error: clearError ? null : error ?? this.error,
  );
}

/// Runs the import flow. Every check happens on the server; this only
/// keeps the choices and moves between steps.
class EmployeeImportController extends Notifier<ImportFlowState> {
  Timer? _poll;

  /// How often an import that's still running is checked.
  static const Duration pollInterval = Duration(seconds: 1);

  @override
  ImportFlowState build() {
    ref.onDispose(() => _poll?.cancel());
    return const ImportFlowState();
  }

  EmployeeImportRepository get _repository =>
      ref.read(employeeImportRepositoryProvider);

  Future<void> _run(Future<void> Function() action) async {
    if (state.busy) return;
    state = state.copyWith(busy: true, clearError: true);
    try {
      await action();
      if (ref.mounted) state = state.copyWith(busy: false);
    } on Object catch (error) {
      if (ref.mounted) state = state.copyWith(busy: false, error: error);
    }
  }

  Future<void> upload(PickedFile file) => _run(() async {
    final upload = await _repository.upload(file.bytes, file.name);
    state = state.copyWith(
      step: ImportStep.map,
      current: upload,
      mapping: upload.suggestedMapping,
    );
  });

  /// Matches [header] to [field] (null: ignore it). A field goes to one
  /// column only, so another column with it is cleared.
  void matchColumn(String header, ImportField? field) {
    final mapping = {
      for (final MapEntry(:key, :value) in state.mapping.entries)
        key: field != null && value == field.name ? null : value,
    }..[header] = field?.name;
    state = state.copyWith(mapping: mapping, clearError: true);
  }

  void setDuplicates(DuplicateStrategy value) =>
      state = state.copyWith(duplicates: value, clearError: true);

  void setCreateMissing(bool value) =>
      state = state.copyWith(createMissing: value);

  void setAssignEcNumbers(bool value) =>
      state = state.copyWith(assignEcNumbers: value, clearError: true);

  Future<void> check() => _run(() async {
    final current = state.current!;
    final checked = await _repository.check(
      current.id,
      ImportOptionsModel(
        mapping: state.mapping,
        duplicateStrategy: state.duplicates,
        createMissing: state.createMissing,
        assignEcNumbers: state.assignEcNumbers,
      ),
    );
    ref.invalidate(importRowsProvider);
    state = state.copyWith(step: ImportStep.review, current: checked);
  });

  /// Back to matching the columns (the file stays uploaded).
  void backToMapping() =>
      state = state.copyWith(step: ImportStep.map, clearError: true);

  Future<void> confirm() => _run(() async {
    var current = await _repository.confirm(state.current!.id);
    // Large files run in the background: follow them until done.
    while (current.status == ImportStatus.importing) {
      state = state.copyWith(current: current);
      final done = Completer<void>();
      _poll = Timer(pollInterval, done.complete);
      await done.future;
      if (!ref.mounted) return;
      current = await _repository.get(current.id);
    }
    _employeesChanged();
    state = state.copyWith(step: ImportStep.result, current: current);
  });

  /// New employees, and maybe new departments and positions.
  void _employeesChanged() {
    ref
      ..invalidate(employeeListProvider)
      ..invalidate(nextEcNumberProvider)
      ..invalidate(dashboardSummaryProvider)
      ..invalidate(catalogProvider(CatalogKind.departments))
      ..invalidate(catalogProvider(CatalogKind.positions));
  }

  /// Starts over with another file; an unfinished import is abandoned.
  Future<void> startOver() async {
    final current = state.current;
    state = const ImportFlowState();
    if (current != null &&
        (current.status == ImportStatus.uploaded ||
            current.status == ImportStatus.validated)) {
      try {
        await _repository.cancel(current.id);
      } on Object {
        // It expires on its own after a day.
      }
    }
  }

  /// Saves the template; returns the error, or null.
  Future<Object?> downloadTemplate() =>
      _save('employee-import-template', () => _repository.template());

  /// Saves the rows that weren't imported; returns the error, or null.
  Future<Object?> downloadReport() => _save(
    'employees-not-imported',
    () => _repository.report(state.current!.id),
  );

  Future<Object?> _save(String name, Future<List<int>> Function() load) async {
    try {
      final bytes = await load();
      await ref.read(excelSaverProvider)(name, Uint8List.fromList(bytes));
      return null;
    } on Object catch (error) {
      return error;
    }
  }
}

final employeeImportControllerProvider =
    NotifierProvider.autoDispose<EmployeeImportController, ImportFlowState>(
      EmployeeImportController.new,
    );

/// One page of checked rows.
typedef ImportRowsKey = ({String id, ImportRowFilter filter, int page});

final importRowsProvider = FutureProvider.autoDispose
    .family<ImportRowsPageModel, ImportRowsKey>(
      (ref, key) => ref
          .watch(employeeImportRepositoryProvider)
          .rows(key.id, filter: key.filter, page: key.page),
      retry: (_, _) => null,
    );
