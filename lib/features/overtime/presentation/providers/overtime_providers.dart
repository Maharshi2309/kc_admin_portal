import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';
import 'package:kc_admin_portal/features/overtime/data/repositories/overtime_repository_impl.dart';

/// Ready-made date ranges for the overtime section; [custom] keeps the
/// range the admin picked.
enum OvertimePeriod {
  thisMonth('This month'),
  lastMonth('Last month'),
  last3Months('Last 3 months'),
  thisYear('This year'),
  custom('Custom');

  const OvertimePeriod(this.label);

  final String label;

  /// The range for [today]; null for [custom].
  ({DateTime from, DateTime to})? rangeFor(DateTime today) {
    final day = today.dateOnly;
    return switch (this) {
      thisMonth => (from: day.monthStart, to: day),
      lastMonth => (
        from: DateTime(day.year, day.month - 1),
        to: DateTime(day.year, day.month, 0),
      ),
      last3Months => (from: DateTime(day.year, day.month - 2), to: day),
      thisYear => (from: DateTime(day.year), to: day),
      custom => null,
    };
  }
}

/// The selected period and range of one employee's overtime section.
typedef OvertimeSelection = ({
  OvertimePeriod period,
  DateTime from,
  DateTime to,
});

class OvertimeSelectionNotifier extends Notifier<OvertimeSelection> {
  OvertimeSelectionNotifier(this.employeeId);

  final String employeeId;

  DateTime get _today => ref.read(clockProvider)().dateOnly;

  @override
  OvertimeSelection build() {
    final range = OvertimePeriod.thisMonth.rangeFor(_today)!;
    return (period: OvertimePeriod.thisMonth, from: range.from, to: range.to);
  }

  void setPeriod(OvertimePeriod period) {
    final range = period.rangeFor(_today);
    if (range == null) return;
    state = (period: period, from: range.from, to: range.to);
  }

  void setRange(DateTime from, DateTime to) => state = (
    period: OvertimePeriod.custom,
    from: from.dateOnly,
    to: to.dateOnly,
  );
}

final overtimeSelectionProvider = NotifierProvider.autoDispose
    .family<OvertimeSelectionNotifier, OvertimeSelection, String>(
      OvertimeSelectionNotifier.new,
    );

/// Which employee and range.
typedef OvertimeKey = ({String employeeId, DateTime from, DateTime to});

final overtimeReportProvider = FutureProvider.autoDispose
    .family<OvertimeReportModel, OvertimeKey>(
      (ref, key) => ref
          .watch(overtimeRepositoryProvider)
          .report(key.employeeId, from: key.from, to: key.to),
      retry: (_, _) => null,
    );

/// The selected range's report for [employeeId].
final employeeOvertimeProvider = FutureProvider.autoDispose
    .family<OvertimeReportModel, String>((ref, employeeId) {
      final selection = ref.watch(overtimeSelectionProvider(employeeId));
      return ref.watch(
        overtimeReportProvider((
          employeeId: employeeId,
          from: selection.from,
          to: selection.to,
        )).future,
      );
    }, retry: (_, _) => null);
