import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:kc_admin_portal/features/overtime/presentation/providers/overtime_providers.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';
import 'package:kc_admin_portal/shared/models/leave_balance_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

/// Search, filters and page of the employee list. Kept while the app runs,
/// so returning to the list restores it.
class EmployeeQueryNotifier extends Notifier<EmployeeQuery> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  Timer? _searchTimer;

  @override
  EmployeeQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    return const EmployeeQuery();
  }

  /// Applies typed search text after a short pause, so the API is not
  /// called on every keystroke.
  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => applySearch(text));
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search == state.search) return;
    state = state.copyWith(search: search, page: 1);
  }

  /// Department and position are independent filters.
  void setDepartment(JobRole? department) =>
      state = state.copyWith(department: department, page: 1);

  void setPosition(JobRole? position) =>
      state = state.copyWith(position: position, page: 1);

  void setJoined(DateTime? from, DateTime? to) =>
      state = state.copyWith(joinedFrom: from, joinedTo: to, page: 1);

  void setStatus(EmployeeStatus? status) =>
      state = state.copyWith(status: status, page: 1);

  void setPage(int page) => state = state.copyWith(page: page);

  void setPageSize(int pageSize) =>
      state = state.copyWith(pageSize: pageSize, page: 1);

  void clearFilters() {
    _searchTimer?.cancel();
    state = EmployeeQuery(pageSize: state.pageSize);
  }
}

final employeeQueryProvider =
    NotifierProvider<EmployeeQueryNotifier, EmployeeQuery>(
      EmployeeQueryNotifier.new,
    );

/// The current page of employees for [employeeQueryProvider].
final employeeListProvider = FutureProvider<EmployeeListModel>(
  (ref) => ref
      .watch(employeeRepositoryProvider)
      .list(ref.watch(employeeQueryProvider)),
  retry: (_, _) => null,
);

final employeeDetailProvider = FutureProvider.autoDispose
    .family<EmployeeModel, String>(
      (ref, id) => ref.watch(employeeRepositoryProvider).getById(id),
      retry: (_, _) => null,
    );

/// Suggested EC number for the add form.
final nextEcNumberProvider = FutureProvider.autoDispose<String>(
  (ref) => ref.watch(employeeRepositoryProvider).nextEcNumber(),
  retry: (_, _) => null,
);

typedef EmployeeMonth = ({String employeeId, DateTime month});

final employeeLeaveBalanceProvider = FutureProvider.autoDispose
    .family<LeaveBalanceModel, String>(
      (ref, id) => ref.watch(employeeRepositoryProvider).leaveBalance(id),
      retry: (_, _) => null,
    );

final employeeLeaveHistoryProvider = FutureProvider.autoDispose
    .family<List<LeaveHistoryItemModel>, String>(
      (ref, id) => ref.watch(employeeRepositoryProvider).leaveHistory(id),
      retry: (_, _) => null,
    );

/// Saves the add/edit form. State: idle (data), saving (loading) or failed
/// (error, whose `ValidationException.fieldErrors` the form shows per field).
class EmployeeFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Creates ([employeeId] null) or updates an employee. Returns the saved
  /// record, or null when saving failed.
  Future<EmployeeModel?> save({
    required EmployeeFormData data,
    String? employeeId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(employeeRepositoryProvider);
    try {
      final saved = employeeId == null
          ? await repository.create(data)
          : await repository.update(employeeId, data);
      _refreshAfterChange(ref, saved.id);
      if (ref.mounted) state = const AsyncData(null);
      return saved;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}

final employeeFormControllerProvider =
    AsyncNotifierProvider.autoDispose<EmployeeFormController, void>(
      EmployeeFormController.new,
      retry: (_, _) => null,
    );

/// Activates or deactivates employees (never deletes them).
class EmployeeStatusController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// The failure of the last [change], readable even after this controller
  /// was disposed.
  Object? lastError;

  /// Returns true when the change was saved.
  Future<bool> change(String employeeId, EmployeeStatus status) async {
    lastError = null;
    state = const AsyncLoading();
    final repository = ref.read(employeeRepositoryProvider);
    try {
      await repository.setStatus(employeeId, status);
      if (ref.mounted) {
        _refreshAfterChange(ref, employeeId);
        state = const AsyncData(null);
      }
      return true;
    } on Object catch (error, stack) {
      lastError = error;
      if (ref.mounted) state = AsyncError(error, stack);
      return false;
    }
  }
}

/// Kept alive (not auto-disposed): it is often only read from a table row
/// that may disappear while the request runs, and the list must still be
/// refreshed afterwards.
final employeeStatusControllerProvider =
    AsyncNotifierProvider<EmployeeStatusController, void>(
      EmployeeStatusController.new,
      retry: (_, _) => null,
    );

void _refreshAfterChange(Ref ref, String employeeId) {
  ref
    ..invalidate(employeeListProvider)
    ..invalidate(employeeDetailProvider(employeeId))
    ..invalidate(nextEcNumberProvider)
    ..invalidate(employeeSchedulesProvider(employeeId))
    // A schedule change recalculates expected hours and overtime.
    ..invalidate(overtimeReportProvider)
    ..invalidate(employeeCalendarProvider);
}

/// An employee's working-schedule versions, newest first.
final employeeSchedulesProvider = FutureProvider.autoDispose
    .family<List<WorkScheduleModel>, String>(
      (ref, id) => ref.watch(employeeRepositoryProvider).schedules(id),
      retry: (_, _) => null,
    );

/// Adds a schedule version. State: idle, saving or failed (the dialog shows
/// `ValidationException.fieldErrors` per field).
class ScheduleFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the new version, or null when saving failed.
  Future<WorkScheduleModel?> save(
    String employeeId,
    WorkScheduleInput input,
  ) async {
    state = const AsyncLoading();
    try {
      final saved = await ref
          .read(employeeRepositoryProvider)
          .addSchedule(employeeId, input);
      _refreshAfterChange(ref, employeeId);
      if (ref.mounted) state = const AsyncData(null);
      return saved;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }
}

final scheduleFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ScheduleFormController, void>(
      ScheduleFormController.new,
      retry: (_, _) => null,
    );

/// Active employees matching [search] (name or EC number), for pickers.
final employeeSearchProvider = FutureProvider.autoDispose
    .family<List<EmployeeModel>, String>((ref, search) async {
      final page = await ref
          .watch(employeeRepositoryProvider)
          .list(
            EmployeeQuery(search: search, pageSize: employeePickerResultCount),
          );
      return page.items;
    }, retry: (_, _) => null);

/// How many matches the employee picker lists.
const int employeePickerResultCount = 6;
