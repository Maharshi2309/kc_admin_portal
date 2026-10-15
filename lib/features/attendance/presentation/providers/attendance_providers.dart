import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/overtime/presentation/providers/overtime_providers.dart';

/// Date, tile filter, search and department of the attendance screen.
class AttendanceQueryNotifier extends Notifier<AttendanceQuery> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  Timer? _searchTimer;

  @override
  AttendanceQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    // Another organization starts with fresh filters.
    ref.watch(activeOrganizationScopeProvider);
    return AttendanceQuery(date: _today);
  }

  DateTime get _today => ref.read(clockProvider)().dateOnly;

  bool get isToday => state.date == _today;

  /// Future dates are never shown.
  void setDate(DateTime date) {
    final day = date.dateOnly;
    if (day.isAfter(_today) || day == state.date) return;
    state = state.copyWith(date: day);
  }

  void previousDay() =>
      setDate(DateTime(state.date.year, state.date.month, state.date.day - 1));

  void nextDay() =>
      setDate(DateTime(state.date.year, state.date.month, state.date.day + 1));

  void setFilter(AttendanceFilter filter) =>
      state = state.copyWith(filter: filter);

  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => applySearch(text));
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search != state.search) state = state.copyWith(search: search);
  }

  void setDepartment(String? departmentId) =>
      state = state.copyWith(departmentId: departmentId);
}

final attendanceQueryProvider =
    NotifierProvider<AttendanceQueryNotifier, AttendanceQuery>(
      AttendanceQueryNotifier.new,
    );

/// Rows for [attendanceQueryProvider]; [loadMore] appends the next page.
class AttendanceDayNotifier extends AsyncNotifier<AttendanceDayModel> {
  @override
  Future<AttendanceDayModel> build() => ref
      .watch(attendanceRepositoryProvider)
      .day(ref.watch(attendanceQueryProvider));

  bool _loadingMore = false;

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return;
    _loadingMore = true;
    try {
      final next = await ref
          .read(attendanceRepositoryProvider)
          .day(ref.read(attendanceQueryProvider), page: current.page + 1);
      if (!ref.mounted) return;
      state = AsyncData(
        next.copyWith(items: [...current.items, ...next.items]),
      );
    } on AppException catch (error, stack) {
      if (ref.mounted) state = AsyncError<AttendanceDayModel>(error, stack);
    } finally {
      _loadingMore = false;
    }
  }
}

final attendanceDayProvider =
    AsyncNotifierProvider<AttendanceDayNotifier, AttendanceDayModel>(
      AttendanceDayNotifier.new,
      retry: (_, _) => null,
    );

/// Punch in / out actions. State: employee ids with an action in progress,
/// so only their row shows a spinner. Kept alive because rows that start an
/// action may be rebuilt away while it runs.
class AttendanceActions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Returns null on success, otherwise a user-facing error message.
  Future<String?> punchIn(String employeeId) => _run(
    employeeId,
    () => ref.read(attendanceRepositoryProvider).punchIn(employeeId),
  );

  Future<String?> punchOut(String employeeId) => _run(
    employeeId,
    () => ref.read(attendanceRepositoryProvider).punchOut(employeeId),
  );

  /// Returns how many were punched in, or throws an `AppException`.
  Future<int> punchInAll(DateTime date) async {
    final count = await ref.read(attendanceRepositoryProvider).punchInAll(date);
    refreshAfterAttendanceChange(ref);
    return count;
  }

  Future<String?> _run(
    String employeeId,
    Future<Object?> Function() action,
  ) async {
    if (state.contains(employeeId)) return null;
    state = {...state, employeeId};
    try {
      await action();
      refreshAfterAttendanceChange(ref);
      return null;
    } on Object catch (error) {
      return ErrorHandler.messageFor(error);
    } finally {
      state = {...state}..remove(employeeId);
    }
  }
}

final attendanceActionsProvider =
    NotifierProvider<AttendanceActions, Set<String>>(AttendanceActions.new);

/// Everything that shows attendance, refreshed after any change.
void refreshAfterAttendanceChange(Ref ref) {
  ref
    ..invalidate(attendanceDayProvider)
    ..invalidate(overtimeReportProvider)
    ..invalidate(employeeCalendarProvider)
    ..invalidate(calendarDayProvider)
    ..invalidate(dashboardSummaryProvider)
    ..invalidate(monthlyAttendanceProvider)
    ..invalidate(employeeAttendanceLogProvider)
    ..invalidate(employeeListProvider);
}

final attendanceRecordProvider = FutureProvider.autoDispose
    .family<AttendanceRecordModel, String>(
      (ref, id) => ref.watch(attendanceRepositoryProvider).getById(id),
      retry: (_, _) => null,
    );

/// Saves a correction (existing record) or a missing record (new).
class AttendanceCorrectionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the saved record, or null when saving failed (see state).
  Future<AttendanceRecordModel?> save({
    required AttendanceCorrectionData data,
    String? recordId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(attendanceRepositoryProvider);
    try {
      final saved = recordId == null
          ? await repository.create(data)
          : await repository.correct(recordId, data);
      if (ref.mounted) {
        refreshAfterAttendanceChange(ref);
        state = const AsyncData(null);
      }
      return saved;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }
}

final attendanceCorrectionControllerProvider =
    AsyncNotifierProvider.autoDispose<AttendanceCorrectionController, void>(
      AttendanceCorrectionController.new,
      retry: (_, _) => null,
    );

/// One employee's daily records for a month (profile "Attendance log").
final employeeAttendanceLogProvider = FutureProvider.autoDispose
    .family<List<AttendanceRecordModel>, EmployeeMonth>(
      (ref, key) => ref
          .watch(attendanceRepositoryProvider)
          .employeeLog(key.employeeId, key.month),
      retry: (_, _) => null,
    );
