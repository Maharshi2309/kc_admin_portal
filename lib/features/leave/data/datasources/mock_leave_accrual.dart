import 'package:kc_admin_portal/core/utils/clock.dart';

/// One day of leave: its date and how much of a day it counts (1 or 0.5).
typedef LeaveDay = ({DateTime date, double days});

/// DEV ONLY (`USE_MOCK_API=true`): the backend's paid-leave rules
/// (docs/DATABASE_V2.md §3.7, approved 2026-10-05; per organization since
/// 2026-10-06), so the dev mock behaves like the real API. The app never
/// decides balances itself.
///
/// Month by month, from the later of the policy start month and the joining
/// month (counted in full):
///
/// 1. [perMonth] days are earned, but the balance never goes above
///    [carryForwardCap] (no cap: unused days carry forward without limit);
/// 2. paid leave dated in that month is taken off.
///
/// A future month's days can't be used: the balance must never go below
/// zero in any month (approved and pending leave count).
class LeaveAccrual {
  const LeaveAccrual({
    required this.policyStart,
    this.perMonth = 1,
    this.carryForwardCap,
  });

  /// The organization's `accrualStartMonth`.
  final DateTime policyStart;
  final double perMonth;

  /// The most days the balance can hold; null for no limit.
  final double? carryForwardCap;

  DateTime _start(DateTime joining) {
    final policy = policyStart.monthStart;
    final joined = joining.monthStart;
    return joined.isAfter(policy) ? joined : policy;
  }

  static DateTime _next(DateTime month) =>
      DateTime(month.year, month.month + 1);

  /// Days earned up to and including [month] when nothing is taken (the
  /// most a balance can have earned by then, ignoring the cap).
  double accruedThrough(DateTime joining, DateTime month) {
    final start = _start(joining);
    final m = month.monthStart;
    if (m.isBefore(start)) return 0;
    final months = (m.year - start.year) * 12 + m.month - start.month + 1;
    return months * perMonth;
  }

  /// Runs the months from the start up to [through] (inclusive), with the
  /// leave in [days] dated up to [until] (default: the end of [through]).
  /// Returns what was earned, the balance at the end, and the lowest
  /// balance reached after any month's leave.
  ({double earned, double balance, double lowest}) _run(
    Iterable<LeaveDay> days,
    DateTime joining,
    DateTime through, {
    DateTime? until,
  }) {
    final last = until?.dateOnly;
    final taken = <DateTime, double>{};
    for (final d in days) {
      if (last != null && d.date.isAfter(last)) continue;
      final month = d.date.monthStart;
      taken[month] = (taken[month] ?? 0) + d.days;
    }
    var earned = 0.0;
    var balance = 0.0;
    var lowest = 0.0;
    final start = _start(joining);
    final end = through.monthStart;
    // Leave before the start month has nothing to use.
    for (final entry in taken.entries) {
      if (entry.key.isBefore(start)) {
        balance -= entry.value;
        lowest = balance < lowest ? balance : lowest;
      }
    }
    for (var m = start; !m.isAfter(end); m = _next(m)) {
      final cap = carryForwardCap;
      final add = cap == null
          ? perMonth
          : (cap - balance).clamp(0, perMonth).toDouble();
      earned += add;
      balance += add - (taken[m] ?? 0);
      if (balance < lowest) lowest = balance;
    }
    return (earned: earned, balance: balance, lowest: lowest);
  }

  /// Days actually earned up to [month], given the leave taken (with a cap,
  /// a full balance earns nothing).
  double earnedThrough(
    Iterable<LeaveDay> days,
    DateTime joining,
    DateTime month,
  ) => _run(days, joining, month).earned;

  /// Whether [days] respect the rules: the balance never goes below zero.
  bool fits(Iterable<LeaveDay> days, DateTime joining) {
    if (days.isEmpty) return true;
    final last = days.map((d) => d.date).reduce((a, b) => a.isAfter(b) ? a : b);
    return _run(days, joining, last).lowest >= 0;
  }

  /// How much of [request] (in date order) paid leave can cover next to the
  /// [existing] paid leave: the longest run from the first day that still
  /// fits. The later days are the ones left over (they would be unpaid).
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

  /// Paid days left after the leave dated up to [through]: earned up to
  /// that month minus paid leave dated up to that day.
  double balanceAfter(
    List<LeaveDay> paid,
    DateTime joining,
    DateTime through,
  ) => _run(paid, joining, through, until: through).balance;
}
