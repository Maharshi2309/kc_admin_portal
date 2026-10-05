import 'package:kc_admin_portal/core/utils/clock.dart';

/// One day of leave: its date and how much of a day it counts (1 or 0.5).
typedef LeaveDay = ({DateTime date, double days});

/// DEV ONLY (`USE_MOCK_API=true`): the backend's paid-leave rules
/// (docs/DATABASE_V2.md §3.7, approved 2026-10-05), so the dev mock behaves
/// like the real API. The app never decides balances itself.
///
/// - 1 Casual day is earned per month, from the later of the policy start
///   month and the joining month (counted in full), with no cap and no
///   year-end reset.
/// - Future months can't be used: for every month M, Casual days dated up
///   to M (approved and pending) must not exceed the days earned up to M.
class LeaveAccrual {
  const LeaveAccrual({required this.policyStart, this.perMonth = 1});

  /// The company's `leave_accrual_start_month`.
  final DateTime policyStart;
  final double perMonth;

  DateTime _start(DateTime joining) {
    final policy = policyStart.monthStart;
    final joined = joining.monthStart;
    return joined.isAfter(policy) ? joined : policy;
  }

  /// Days earned up to and including [month].
  double accruedThrough(DateTime joining, DateTime month) {
    final start = _start(joining);
    final m = month.monthStart;
    if (m.isBefore(start)) return 0;
    final months = (m.year - start.year) * 12 + m.month - start.month + 1;
    return months * perMonth;
  }

  /// Whether [days] respect the future-month rule. It can only break in a
  /// month that has leave (in between, earned days only grow).
  bool fits(Iterable<LeaveDay> days, DateTime joining) {
    final byMonth = <DateTime, double>{};
    for (final d in days) {
      final month = d.date.monthStart;
      byMonth[month] = (byMonth[month] ?? 0) + d.days;
    }
    final months = byMonth.keys.toList()..sort();
    var taken = 0.0;
    for (final month in months) {
      taken += byMonth[month]!;
      if (taken > accruedThrough(joining, month)) return false;
    }
    return true;
  }

  /// How much of [request] (in date order) Casual can cover next to the
  /// [existing] Casual leave: the longest run from the first day that still
  /// fits. The later days are the ones left over (they would be Unpaid).
  double paidPart(
    List<LeaveDay> request,
    List<LeaveDay> existing,
    DateTime joining,
  ) {
    final ordered = [...request]..sort((a, b) => a.date.compareTo(b.date));
    final accepted = <LeaveDay>[];
    for (final day in ordered) {
      if (!fits([...existing, ...accepted, day], joining)) break;
      accepted.add(day);
    }
    return accepted.fold(0, (sum, d) => sum + d.days);
  }

  /// Casual days left after the leave dated up to [through]: earned up to
  /// that month minus Casual leave dated up to that day.
  double balanceAfter(
    List<LeaveDay> casual,
    DateTime joining,
    DateTime through,
  ) {
    final day = through.dateOnly;
    final taken = casual
        .where((d) => !d.date.isAfter(day))
        .fold<double>(0, (sum, d) => sum + d.days);
    return accruedThrough(joining, day) - taken;
  }
}
