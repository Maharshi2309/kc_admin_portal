import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/leave/data/repositories/leave_repository_impl.dart';
import 'package:kc_admin_portal/features/overtime/presentation/providers/overtime_providers.dart';
import 'package:kc_admin_portal/shared/models/job_role.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

/// Status tab, search, filters and page of the leave list.
class LeaveQueryNotifier extends Notifier<LeaveQuery> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  Timer? _searchTimer;

  @override
  LeaveQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    return const LeaveQuery();
  }

  void setStatus(LeaveStatus? status) =>
      state = state.copyWith(status: status, page: 1);

  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => applySearch(text));
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search != state.search) {
      state = state.copyWith(search: search, page: 1);
    }
  }

  void setDateRange(DateTime? from, DateTime? to) =>
      state = state.copyWith(from: from, to: to, page: 1);

  void setLeaveType(String? id) =>
      state = state.copyWith(leaveTypeId: id, page: 1);

  void setDepartment(JobRole? department) =>
      state = state.copyWith(department: department, page: 1);

  void setPage(int page) => state = state.copyWith(page: page);

  void setPageSize(int size) => state = state.copyWith(pageSize: size, page: 1);

  /// Keeps the selected tab and page size.
  void clearFilters() {
    _searchTimer?.cancel();
    state = LeaveQuery(status: state.status, pageSize: state.pageSize);
  }
}

final leaveQueryProvider = NotifierProvider<LeaveQueryNotifier, LeaveQuery>(
  LeaveQueryNotifier.new,
);

final leaveListProvider = FutureProvider<LeaveListModel>(
  (ref) =>
      ref.watch(leaveRepositoryProvider).list(ref.watch(leaveQueryProvider)),
  retry: (_, _) => null,
);

/// Search, department and page of the Balances tab.
class LeaveBalanceQueryNotifier extends Notifier<LeaveBalanceQuery> {
  Timer? _searchTimer;

  @override
  LeaveBalanceQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    return const LeaveBalanceQuery();
  }

  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(
      LeaveQueryNotifier.searchDebounce,
      () => applySearch(text),
    );
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search != state.search) {
      state = state.copyWith(search: search, page: 1);
    }
  }

  void setDepartment(JobRole? department) =>
      state = state.copyWith(department: department, page: 1);

  void setPage(int page) => state = state.copyWith(page: page);

  void setPageSize(int size) => state = state.copyWith(pageSize: size, page: 1);

  /// Keeps the page size.
  void clearFilters() {
    _searchTimer?.cancel();
    state = LeaveBalanceQuery(pageSize: state.pageSize);
  }
}

final leaveBalanceQueryProvider =
    NotifierProvider<LeaveBalanceQueryNotifier, LeaveBalanceQuery>(
      LeaveBalanceQueryNotifier.new,
    );

/// Every active employee's Casual balance, with totals (Balances tab).
final leaveBalanceListProvider = FutureProvider<LeaveBalanceListModel>(
  (ref) => ref
      .watch(leaveRepositoryProvider)
      .balances(ref.watch(leaveBalanceQueryProvider)),
  retry: (_, _) => null,
);

/// Leave types, kept for the session (used by filters and the drawer).
final leaveTypesProvider = FutureProvider<List<LeaveTypeModel>>(
  (ref) => ref.watch(leaveRepositoryProvider).types(),
  retry: (_, _) => null,
);

final leaveDetailProvider = FutureProvider.autoDispose
    .family<LeaveModel, String>(
      (ref, id) => ref.watch(leaveRepositoryProvider).getById(id),
      retry: (_, _) => null,
    );

/// Which month, for whom (null: no employee chosen yet).
typedef LeaveCalendarKey = ({DateTime month, String? employeeId});

/// Company holidays and the employee's weekly offs of a month, for the date
/// picker.
final leaveCalendarProvider = FutureProvider.autoDispose
    .family<LeaveCalendarModel, LeaveCalendarKey>(
      (ref, key) => ref
          .watch(leaveRepositoryProvider)
          .calendar(key.month, employeeId: key.employeeId),
      retry: (_, _) => null,
    );

/// The backend's day count and balance for what the drawer would save.
final leavePreviewProvider = FutureProvider.autoDispose
    .family<LeavePreviewModel, LeavePreviewRequest>(
      (ref, request) => ref.watch(leaveRepositoryProvider).preview(request),
      retry: (_, _) => null,
    );

/// Saves the add / edit drawer.
class LeaveFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the saved leave, or null when saving failed (see state).
  Future<LeaveModel?> save({
    required LeaveFormData data,
    String? leaveId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(leaveRepositoryProvider);
    try {
      final saved = leaveId == null
          ? await repository.create(data)
          : await repository.update(leaveId, data);
      if (ref.mounted) {
        refreshAfterLeaveChange(ref);
        state = const AsyncData(null);
      }
      return saved;
    } on Object catch (error, stack) {
      // Someone decided the leave meanwhile: reload it, so the sheet shows
      // that it can no longer be edited.
      if (error is ValidationException &&
          error.code == ApiConstants.leaveNotEditableCode) {
        refreshAfterLeaveChange(ref);
      }
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }
}

final leaveFormControllerProvider =
    AsyncNotifierProvider.autoDispose<LeaveFormController, void>(
      LeaveFormController.new,
      retry: (_, _) => null,
    );

/// Approve / reject / cancel. State: leave ids with an action in progress.
/// Kept alive because the row that starts an action may be rebuilt away.
class LeaveActions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Returns null on success, otherwise a user-facing error message.
  Future<String?> setStatus(String leaveId, LeaveStatus status) async {
    if (state.contains(leaveId)) return null;
    state = {...state, leaveId};
    try {
      await ref.read(leaveRepositoryProvider).setStatus(leaveId, status);
      refreshAfterLeaveChange(ref);
      return null;
    } on Object catch (error) {
      return ErrorHandler.messageFor(error);
    } finally {
      state = {...state}..remove(leaveId);
    }
  }
}

final leaveActionsProvider = NotifierProvider<LeaveActions, Set<String>>(
  LeaveActions.new,
);

/// Everything that shows leave, refreshed after any change.
void refreshAfterLeaveChange(Ref ref) {
  ref
    ..invalidate(leaveListProvider)
    ..invalidate(leaveBalanceListProvider)
    ..invalidate(leaveDetailProvider)
    ..invalidate(leavePreviewProvider)
    ..invalidate(employeeLeaveBalanceProvider)
    ..invalidate(employeeLeaveHistoryProvider)
    ..invalidate(overtimeReportProvider)
    ..invalidate(employeeCalendarProvider)
    ..invalidate(calendarDayProvider)
    ..invalidate(dashboardSummaryProvider);
}
