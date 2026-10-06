import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/catalogs.dart';
import '../../helpers/fake_dashboard.dart';

void main() {
  late LeaveMockDataSource source;
  // Sanjay Makwana: active, no leave in the sample data.
  const sanjay = '10';

  setUp(
    () => source = LeaveMockDataSource(
      now: () => testNow,
      employees: EmployeeMockDataSource.seed(testNow),
    ),
  );

  LeaveFormData form({
    DateTime? start,
    DateTime? end,
    String type = 'casual',
    bool half = false,
  }) => LeaveFormData(
    employeeId: sanjay,
    leaveTypeId: type,
    startDate: start ?? DateTime(2026, 10, 5),
    endDate: end ?? DateTime(2026, 10, 7),
    isHalfDay: half,
    reason: LeaveReason.travel,
    status: LeaveStatus.approved,
  );

  test('counts working days only (Sundays and holidays excluded)', () {
    // Thu 1, Fri 2 (Gandhi Jayanti), Sat 3 Oct → 2 days.
    expect(
      source.countDays(
        sanjay,
        DateTime(2026, 10, 1),
        DateTime(2026, 10, 3),
        isHalfDay: false,
      ),
      2,
    );
    // Sat 3, Sun 4, Mon 5 Oct → 2 days.
    expect(
      source.countDays(
        sanjay,
        DateTime(2026, 10, 3),
        DateTime(2026, 10, 5),
        isHalfDay: false,
      ),
      2,
    );
    expect(
      source.countDays(
        sanjay,
        DateTime(2026, 10, 5),
        DateTime(2026, 10, 5),
        isHalfDay: true,
      ),
      0.5,
    );
  });

  test("each employee's own weekly offs are not counted", () {
    // Employee 3 has Saturday and Sunday off: Sat 3, Sun 4, Mon 5 Oct → 1.
    expect(
      source.countDays(
        '3',
        DateTime(2026, 10, 3),
        DateTime(2026, 10, 5),
        isHalfDay: false,
      ),
      1,
    );
    // A half day on a weekly off is nothing.
    expect(
      source.countDays(
        '3',
        DateTime(2026, 10, 3),
        DateTime(2026, 10, 3),
        isHalfDay: true,
      ),
      0,
    );
  });

  test('the leave calendar has the employee weekly offs', () async {
    final sanjays = await source.calendar(
      DateTime(2026, 10),
      employeeId: sanjay,
    );
    expect(sanjays.weeklyOffDays, [DateTime.sunday]);
    expect(sanjays.weekOffDates, hasLength(4)); // Sundays 4, 11, 18, 25
    expect(sanjays.isWeekOff(DateTime(2026, 10, 3)), isFalse);

    final third = await source.calendar(DateTime(2026, 10), employeeId: '3');
    expect(third.weeklyOffDays, [DateTime.saturday, DateTime.sunday]);
    expect(third.isWeekOff(DateTime(2026, 10, 3)), isTrue);

    final nobody = await source.calendar(DateTime(2026, 10));
    expect(nobody.weeklyOffDays, isEmpty);
    expect(nobody.holidays.single.name, 'Gandhi Jayanti');
  });

  test('only pending leave can be edited (LEAVE_NOT_EDITABLE)', () async {
    // Record 3: Priya Desai's approved leave.
    final approved = await source.getById('3');
    expect(approved.status, LeaveStatus.approved);
    expect(approved.canEdit, isFalse);
    expect(approved.canCancel, isTrue);

    await expectLater(
      source.update(
        '3',
        LeaveFormData(
          employeeId: approved.employee.id,
          leaveTypeId: approved.leaveType.id,
          startDate: approved.startDate,
          endDate: approved.startDate,
          isHalfDay: false,
          reason: approved.reason,
          status: LeaveStatus.approved,
        ),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.code,
          'code',
          'LEAVE_NOT_EDITABLE',
        ),
      ),
    );

    // Record 1: Dhruv Parmar's pending leave can be edited.
    final pending = await source.getById('1');
    expect(pending.canEdit, isTrue);
  });

  test('lists the design sample with tab counts', () async {
    final all = await source.list(const LeaveQuery());
    expect(all.counts.pending, 3);
    expect(all.counts.rejected, 1);
    expect(all.counts.cancelled, 1);
    expect(all.items.first.startDate, DateTime(2026, 10, 12)); // newest first

    final pending = await source.list(
      const LeaveQuery(status: LeaveStatus.pending),
    );
    expect(pending.items.every((l) => l.canDecide), isTrue);
  });

  test('previews days and the Casual available', () async {
    // Sanjay joined before the policy start (Jan 2026): by October he has
    // earned 10 Casual days.
    final preview = await source.preview(
      LeavePreviewRequest(
        employeeId: sanjay,
        leaveTypeId: 'casual',
        startDate: DateTime(2026, 10, 5),
        endDate: DateTime(2026, 10, 7),
        isHalfDay: false,
      ),
    );
    expect(preview.days, 3);
    expect(preview.paidDays, 3);
    expect(preview.unpaidDays, 0);
    expect(preview.availableCasual, 10);
    expect(preview.needsSplit, isFalse);

    final unpaid = await source.preview(
      LeavePreviewRequest(
        employeeId: sanjay,
        leaveTypeId: 'unpaid',
        startDate: DateTime(2026, 10, 5),
        endDate: DateTime(2026, 10, 7),
        isHalfDay: false,
      ),
    );
    expect(unpaid.unpaidDays, 3);
    expect(unpaid.availableCasual, isNull);
    expect(unpaid.needsSplit, isFalse);
  });

  test('creating leave updates the balance', () async {
    final before = source.balance(sanjay);
    expect(before.accrued, 9); // Jan–Sep
    expect(before.remaining, 9);

    await source.create(
      form(start: DateTime(2026, 9, 29), end: DateTime(2026, 9, 30)),
    );
    await source.create(
      form(
        start: DateTime(2026, 10, 5),
        end: DateTime(2026, 10, 5),
      ).copyWith(status: LeaveStatus.pending),
    );
    await source.create(
      form(
        type: 'unpaid',
        start: DateTime(2026, 10, 6),
        end: DateTime(2026, 10, 6),
      ),
    );
    final after = source.balance(sanjay);
    expect(after.used, 2);
    expect(after.pending, 1);
    expect(after.remaining, 6);
    expect(after.unpaidTaken, 1);
  });

  test(
    'refuses Casual beyond the balance (INSUFFICIENT_LEAVE_BALANCE)',
    () async {
      await source.create(form());
      // Overlapping leave is still refused.
      await expectLater(
        source.create(form(start: DateTime(2026, 10, 7))),
        throwsA(isA<ValidationException>()),
      );
      // 10 earned by October, 3 used: 8 more working days don't fit.
      await expectLater(
        source.create(
          form(start: DateTime(2026, 10, 12), end: DateTime(2026, 10, 20)),
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.code,
            'code',
            'INSUFFICIENT_LEAVE_BALANCE',
          ),
        ),
      );
    },
  );

  test('saves the extra days as Unpaid when asked', () async {
    // Mon 12 – Tue 20 Oct: 8 working days (Sun 18 off); 10 earned by Oct.
    final data = form(
      start: DateTime(2026, 10, 12),
      end: DateTime(2026, 10, 20),
    );
    final preview = await source.preview(
      LeavePreviewRequest(
        employeeId: sanjay,
        leaveTypeId: 'casual',
        startDate: data.startDate,
        endDate: data.endDate,
        isHalfDay: false,
      ),
    );
    await source.create(
      form(start: DateTime(2026, 10, 5), end: DateTime(2026, 10, 7)),
    );
    final split = await source.preview(
      LeavePreviewRequest(
        employeeId: sanjay,
        leaveTypeId: 'casual',
        startDate: data.startDate,
        endDate: data.endDate,
        isHalfDay: false,
      ),
    );
    expect(preview.needsSplit, isFalse);
    expect(split.days, 8);
    expect(split.paidDays, 7);
    expect(split.unpaidDays, 1);
    expect(split.needsSplit, isTrue);

    final casual = await source.create(
      data.copyWith(splitExcessAsUnpaid: true),
    );
    expect(casual.leaveType.id, 'casual');
    expect(casual.days, 7);
    expect(casual.endDate, DateTime(2026, 10, 19));
    expect(casual.balanceAfter, 0);
    expect(casual.unpaidPartId, isNotNull);

    final unpaid = (await source.list(
      const LeaveQuery(search: 'Sanjay'),
    )).items.firstWhere((l) => l.id == casual.unpaidPartId);
    expect(unpaid.leaveType.id, 'unpaid');
    expect(unpaid.isPaid, isFalse);
    expect(unpaid.startDate, DateTime(2026, 10, 20));
    expect(unpaid.days, 1);
  });

  group('balances list (GET /leave-balances)', () {
    test('every active employee, by name, with totals', () async {
      final list = await source.balances(const LeaveBalanceQuery());
      expect(list.total, 19);
      expect(list.items, hasLength(10));
      expect(list.items.first.employee.name, 'Aarav Shah');
      expect(list.items.first.balance.remaining, 0); // all 9 days used

      // Totals cover every matching employee, not just this page.
      expect(list.summary.employees, 19);
      expect(list.summary.accrued, 19 * 9);
      expect(list.summary.used, 13.5);
      expect(list.summary.pending, 9);
      expect(list.summary.remaining, 148.5);
      expect(list.summary.unpaidTaken, 2);
      expect(
        list.summary.remaining,
        list.summary.accrued - list.summary.used - list.summary.pending,
      );
    });

    test('search and department narrow rows and totals', () async {
      final priya = await source.balances(
        const LeaveBalanceQuery(search: 'priya'),
      );
      expect(priya.items.single.balance.used, 3);
      expect(priya.items.single.balance.unpaidTaken, 2);
      expect(priya.summary.employees, 1);

      final tailors = await source.balances(
        LeaveBalanceQuery(departmentId: dept('Tailor').id),
      );
      expect(tailors.items, isNotEmpty);
      expect(
        tailors.items.every((r) => r.employee.department == dept('Tailor')),
        isTrue,
      );
      expect(tailors.summary.employees, tailors.total);
    });

    test('changes as soon as leave is added', () async {
      await source.create(form());
      final sanjay = await source.balances(
        const LeaveBalanceQuery(search: 'Sanjay'),
      );
      expect(sanjay.items.single.balance.used, 3);
      expect(sanjay.items.single.balance.remaining, 6);
    });
  });

  test('dashboard figures keep Casual and Unpaid apart', () async {
    final usage = source.usage(testNow);
    expect(usage.casualRemaining, 148.5);
    expect(usage.casualTaken, 13.5);
    expect(usage.unpaidTaken, 2);
    // Requests overlapping September.
    expect(usage.approved, 4);
    expect(usage.pending, 1);
    expect(usage.rejected, 1);

    // Unpaid leave never changes the remaining Casual days.
    await source.create(form(type: 'unpaid'));
    final after = source.usage(testNow);
    expect(after.casualRemaining, 148.5);
    expect(after.unpaidTaken, 5);
  });

  test('only allows valid status changes', () async {
    final pending = (await source.list(
      const LeaveQuery(status: LeaveStatus.pending),
    )).items.first;
    final approved = await source.setStatus(pending.id, LeaveStatus.approved);
    expect(approved.status, LeaveStatus.approved);

    // Approved → rejected is not allowed; approved → cancelled is.
    await expectLater(
      source.setStatus(pending.id, LeaveStatus.rejected),
      throwsA(isA<ValidationException>()),
    );
    final cancelled = await source.setStatus(pending.id, LeaveStatus.cancelled);
    expect(cancelled.status, LeaveStatus.cancelled);
  });
}
