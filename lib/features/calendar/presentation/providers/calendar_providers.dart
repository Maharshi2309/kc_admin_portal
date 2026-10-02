import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/calendar/data/repositories/calendar_repository_impl.dart';

/// The month shown in one employee's calendar. Starts at the current month;
/// goes back freely and up to [monthsAhead] ahead (holidays, weekly offs and
/// planned leave).
class CalendarMonthNotifier extends Notifier<DateTime> {
  CalendarMonthNotifier(this.employeeId);

  final String employeeId;

  static const int monthsAhead = 12;

  DateTime get _current => ref.read(clockProvider)().monthStart;

  @override
  DateTime build() => _current;

  bool get canGoNext {
    final limit = DateTime(_current.year, _current.month + monthsAhead);
    return DateTime(
      state.year,
      state.month + 1,
    ).isBefore(DateTime(limit.year, limit.month + 1));
  }

  void previous() => state = DateTime(state.year, state.month - 1);

  void next() {
    if (canGoNext) state = DateTime(state.year, state.month + 1);
  }

  void thisMonth() => state = _current;
}

final calendarMonthProvider = NotifierProvider.autoDispose
    .family<CalendarMonthNotifier, DateTime, String>(CalendarMonthNotifier.new);

/// Which employee and month.
typedef CalendarKey = ({String employeeId, DateTime month});

final employeeCalendarProvider = FutureProvider.autoDispose
    .family<EmployeeCalendarModel, CalendarKey>(
      (ref, key) => ref
          .watch(calendarRepositoryProvider)
          .month(key.employeeId, key.month),
      retry: (_, _) => null,
    );

/// Which employee and date.
typedef CalendarDayKey = ({String employeeId, DateTime date});

final calendarDayProvider = FutureProvider.autoDispose
    .family<CalendarDayDetailModel, CalendarDayKey>(
      (ref, key) =>
          ref.watch(calendarRepositoryProvider).day(key.employeeId, key.date),
      retry: (_, _) => null,
    );
