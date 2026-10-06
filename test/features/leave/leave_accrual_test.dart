import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/mock_leave_accrual.dart';

/// The approved paid-leave rules (2026-10-05) that the dev mock copies from
/// the backend: 1 Casual day per month, carried forward, no future months.
void main() {
  final accrual = LeaveAccrual(policyStart: DateTime(2026));
  final joinedEarlier = DateTime(2024, 9, 2);

  List<LeaveDay> days(DateTime first, int count) => [
    for (var i = 0; i < count; i++)
      (date: DateTime(first.year, first.month, first.day + i), days: 1.0),
  ];

  group('accruedThrough', () {
    test('counts from the policy start, the current month included', () {
      expect(accrual.accruedThrough(joinedEarlier, DateTime(2025, 12)), 0);
      expect(accrual.accruedThrough(joinedEarlier, DateTime(2026)), 1);
      expect(accrual.accruedThrough(joinedEarlier, DateTime(2026, 3, 31)), 3);
      // No year-end reset or cap.
      expect(accrual.accruedThrough(joinedEarlier, DateTime(2027, 2)), 14);
    });

    test('a later joiner earns from the joining month, in full', () {
      final joined = DateTime(2026, 6, 25);
      expect(accrual.accruedThrough(joined, DateTime(2026, 5)), 0);
      expect(accrual.accruedThrough(joined, DateTime(2026, 6)), 1);
      expect(accrual.accruedThrough(joined, DateTime(2026, 9)), 4);
    });
  });

  group('fits (no future months)', () {
    test('unused Jan–Feb days carry into March: 3 allowed, 4 refused', () {
      expect(accrual.fits(days(DateTime(2026, 3, 9), 3), joinedEarlier), true);
      expect(accrual.fits(days(DateTime(2026, 3, 9), 4), joinedEarlier), false);
    });

    test("can't use next month's day early", () {
      // 1 day in January is fine; 2 would use February's.
      expect(accrual.fits(days(DateTime(2026, 1, 12), 1), joinedEarlier), true);
      expect(
        accrual.fits(days(DateTime(2026, 1, 12), 2), joinedEarlier),
        false,
      );
    });

    test("booking ahead is fine once that month's days cover it", () {
      // Booked in March for June: 6 days earned by June.
      expect(accrual.fits(days(DateTime(2026, 6, 1), 6), joinedEarlier), true);
      expect(accrual.fits(days(DateTime(2026, 6, 1), 7), joinedEarlier), false);
    });

    test('earlier leave counts against later months', () {
      final existing = days(DateTime(2026, 2, 2), 2); // Jan + Feb used
      expect(
        accrual.fits([
          ...existing,
          ...days(DateTime(2026, 3, 2), 1),
        ], joinedEarlier),
        true,
      );
      expect(
        accrual.fits([
          ...existing,
          ...days(DateTime(2026, 3, 2), 2),
        ], joinedEarlier),
        false,
      );
    });

    test('half days count as 0.5', () {
      final halves = [
        (date: DateTime(2026, 1, 5), days: 0.5),
        (date: DateTime(2026, 1, 6), days: 0.5),
      ];
      expect(accrual.fits(halves, joinedEarlier), true);
      expect(
        accrual.fits([
          ...halves,
          (date: DateTime(2026, 1, 7), days: 0.5),
        ], joinedEarlier),
        false,
      );
    });
  });

  group('paidPart', () {
    test('the earliest days are paid, the latest left over', () {
      // 4 days in March, 3 earned: 3 paid.
      expect(
        accrual.paidPart(
          days(DateTime(2026, 3, 9), 4),
          const [],
          joinedEarlier,
        ),
        3,
      );
      // With 1 day already used: 2 paid.
      expect(
        accrual.paidPart(
          days(DateTime(2026, 3, 9), 4),
          days(DateTime(2026, 2, 2), 1),
          joinedEarlier,
        ),
        2,
      );
      // Nothing earned yet.
      expect(
        accrual.paidPart(
          days(DateTime(2025, 12, 1), 2),
          const [],
          joinedEarlier,
        ),
        0,
      );
    });
  });

  test('balanceAfter: earned to that month minus leave to that day', () {
    final casual = [
      ...days(DateTime(2026, 2, 2), 1),
      ...days(DateTime(2026, 3, 9), 2),
    ];
    expect(
      accrual.balanceAfter(casual, joinedEarlier, DateTime(2026, 2, 2)),
      1,
    );
    expect(
      accrual.balanceAfter(casual, joinedEarlier, DateTime(2026, 3, 10)),
      0,
    );
  });

  group('a carry-forward cap (per organization, 2026-10-06)', () {
    // 1 day a month from January, the balance holds at most 3.
    final capped = LeaveAccrual(
      policyStart: DateTime(2026),
      carryForwardCap: 3,
    );

    test('a full balance earns nothing', () {
      expect(
        capped.earnedThrough(const [], joinedEarlier, DateTime(2026, 6)),
        3,
      );
      expect(
        capped.balanceAfter(const [], joinedEarlier, DateTime(2026, 6)),
        3,
      );
    });

    test('using days makes room to earn again', () {
      // Jan 1, Feb 2, Mar 3, Apr full (earns 0) then 2 taken → 1,
      // May 2, Jun 3: earned 1+1+1+0+1+1 = 5.
      final april = days(DateTime(2026, 4, 6), 2);
      expect(capped.earnedThrough(april, joinedEarlier, DateTime(2026, 6)), 5);
      expect(
        capped.balanceAfter(april, joinedEarlier, DateTime(2026, 6, 30)),
        3,
      );
      expect(
        capped.balanceAfter(april, joinedEarlier, DateTime(2026, 4, 30)),
        1,
      );
    });

    test('never more than the cap in one go', () {
      expect(capped.fits(days(DateTime(2026, 6, 1), 3), joinedEarlier), true);
      expect(capped.fits(days(DateTime(2026, 6, 1), 4), joinedEarlier), false);
    });

    test('half a day a month', () {
      final half = LeaveAccrual(policyStart: DateTime(2026), perMonth: 0.5);
      expect(half.accruedThrough(joinedEarlier, DateTime(2026, 4)), 2);
      expect(half.fits(days(DateTime(2026, 4, 6), 2), joinedEarlier), true);
      expect(half.fits(days(DateTime(2026, 4, 6), 3), joinedEarlier), false);
    });
  });
}
