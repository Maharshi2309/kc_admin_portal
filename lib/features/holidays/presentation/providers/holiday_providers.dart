import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:kc_admin_portal/features/holidays/data/repositories/holiday_repository_impl.dart';
import 'package:kc_admin_portal/features/leave/presentation/providers/leave_providers.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';

/// The Holidays page's year and name search.
typedef HolidayQuery = ({int year, String search});

class HolidayQueryNotifier extends Notifier<HolidayQuery> {
  static const Duration searchDebounce = Duration(milliseconds: 350);

  Timer? _searchTimer;

  @override
  HolidayQuery build() {
    ref.onDispose(() => _searchTimer?.cancel());
    // Another organization starts with fresh filters.
    ref.watch(activeOrganizationIdProvider);
    return (year: ref.read(clockProvider)().year, search: '');
  }

  void setYear(int year) => state = (year: year, search: state.search);
  void previousYear() => setYear(state.year - 1);
  void nextYear() => setYear(state.year + 1);

  void setSearch(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => applySearch(text));
  }

  void applySearch(String text) {
    _searchTimer?.cancel();
    final search = text.trim();
    if (search != state.search) state = (year: state.year, search: search);
  }
}

final holidayQueryProvider =
    NotifierProvider<HolidayQueryNotifier, HolidayQuery>(
      HolidayQueryNotifier.new,
    );

/// Holidays of the selected year matching the search, by date.
final holidayListProvider = FutureProvider.autoDispose<List<HolidayModel>>((
  ref,
) {
  final query = ref.watch(holidayQueryProvider);
  return ref
      .watch(holidayRepositoryProvider)
      .list(year: query.year, search: query.search);
}, retry: (_, _) => null);

final holidayDetailProvider = FutureProvider.autoDispose
    .family<HolidayModel, String>(
      (ref, id) => ref.watch(holidayRepositoryProvider).getById(id),
      retry: (_, _) => null,
    );

/// Adds or edits a holiday. State: idle, saving or failed (field errors
/// shown on the form).
class HolidayFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Returns the saved holiday, or null when saving failed.
  Future<HolidayModel?> save({
    required HolidayInput input,
    String? holidayId,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(holidayRepositoryProvider);
    try {
      final saved = holidayId == null
          ? await repository.create(input)
          : await repository.update(holidayId, input);
      refreshAfterHolidayChange(ref);
      if (ref.mounted) state = const AsyncData(null);
      return saved;
    } on Object catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      return null;
    }
  }
}

final holidayFormControllerProvider =
    AsyncNotifierProvider.autoDispose<HolidayFormController, void>(
      HolidayFormController.new,
      retry: (_, _) => null,
    );

/// Deletes holidays. State: the ids being deleted, so only their row shows
/// progress. Kept alive: the row goes away while the request runs.
class HolidayActions extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Returns null on success, otherwise a user-facing error message.
  Future<String?> delete(String id) async {
    if (state.contains(id)) return null;
    state = {...state, id};
    try {
      await ref.read(holidayRepositoryProvider).delete(id);
      refreshAfterHolidayChange(ref);
      return null;
    } on Object catch (error) {
      return ErrorHandler.messageFor(error);
    } finally {
      state = {...state}..remove(id);
    }
  }
}

final holidayActionsProvider = NotifierProvider<HolidayActions, Set<String>>(
  HolidayActions.new,
);

/// A holiday change recalculates attendance, leave days and balances on its
/// dates (docs/DATABASE_V2.md §3.5), so everything showing them refreshes.
void refreshAfterHolidayChange(Ref ref) {
  ref
    ..invalidate(holidayListProvider)
    ..invalidate(holidayDetailProvider)
    ..invalidate(leaveCalendarProvider)
    ..invalidate(monthlyAttendanceProvider);
  refreshAfterLeaveChange(ref);
  refreshAfterAttendanceChange(ref);
}
