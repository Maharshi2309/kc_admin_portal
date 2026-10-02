import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

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

  test('previews days and balance', () async {
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
    expect(preview.balanceBefore, 12);
    expect(preview.balanceAfter, 9);
  });

  test('creating leave updates the balance', () async {
    await source.create(form());
    final casual = source
        .balances(sanjay)
        .firstWhere((b) => b.leaveTypeId == 'casual');
    expect(casual.used, 3);
    expect(casual.remaining, 9);
  });

  test('rejects overlapping leave and insufficient balance', () async {
    await source.create(form());
    await expectLater(
      source.create(form(start: DateTime(2026, 10, 7))),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(
      source.create(
        form(
          type: 'sick',
          start: DateTime(2026, 11, 2),
          end: DateTime(2026, 11, 14),
        ),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors.keys,
          'field',
          contains('leaveTypeId'),
        ),
      ),
    );
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
