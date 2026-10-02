import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_mock_data_source.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_dashboard.dart';

void main() {
  late MockHolidayStore store;
  late HolidayMockDataSource source;

  setUp(() {
    store = MockHolidayStore(now: () => testNow);
    source = HolidayMockDataSource(store: store);
  });

  group('holiday endpoints (mock)', () {
    test('lists a year by date, and searches by name', () async {
      final year = await source.list(year: 2026);
      expect(year.map((h) => h.name), [
        'Republic Day',
        'Independence Day',
        'Gandhi Jayanti',
      ]);
      expect(await source.list(year: 2026, search: 'gandhi'), hasLength(1));
      expect(await source.list(year: 2030), isEmpty);
    });

    test('adds, edits and deletes', () async {
      final added = await source.create(
        HolidayInput(date: DateTime(2026, 11, 9), name: '  Diwali '),
      );
      expect(added.name, 'Diwali');
      expect(store.on(DateTime(2026, 11, 9))?.id, added.id);

      final moved = await source.update(
        added.id,
        HolidayInput(date: DateTime(2026, 11, 10), name: 'Diwali'),
      );
      expect(store.on(DateTime(2026, 11, 9)), isNull);
      expect(moved.date, DateTime(2026, 11, 10));

      await source.delete(added.id);
      expect(store.on(DateTime(2026, 11, 10)), isNull);
      await expectLater(
        source.getById(added.id),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('one holiday per date; the name is required', () async {
      await expectLater(
        source.create(
          HolidayInput(date: DateTime(2026, 10, 2), name: 'Second'),
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors['date'],
            'date error',
            'Gandhi Jayanti is already on this date',
          ),
        ),
      );
      await expectLater(
        source.create(HolidayInput(date: DateTime(2026, 12, 1), name: ' ')),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors.keys,
            'fields',
            ['name'],
          ),
        ),
      );
    });
  });

  group('a holiday recalculates leave (DATABASE_V2 §3.5)', () {
    test(
      'added inside approved leave: that day goes back to the balance',
      () async {
        final leave = LeaveMockDataSource(
          now: () => testNow,
          employees: EmployeeMockDataSource.seed(testNow),
          holidays: store,
        );
        // Priya Desai (2): approved casual leave Mon 28 – Wed 30 Sep.
        final before = (await leave.list(
          const LeaveQuery(search: 'Priya'),
        )).items.firstWhere((l) => l.startDate == DateTime(2026, 9, 28));
        expect(before.days, 3);
        final remainingBefore = leave
            .balances('2')
            .firstWhere((b) => b.leaveTypeId == 'casual')
            .remaining!;

        final holiday = await source.create(
          HolidayInput(date: DateTime(2026, 9, 29), name: 'Company Holiday'),
        );
        final after = (await leave.list(
          const LeaveQuery(search: 'Priya'),
        )).items.firstWhere((l) => l.startDate == DateTime(2026, 9, 28));
        expect(after.days, 2);
        expect(
          leave
              .balances('2')
              .firstWhere((b) => b.leaveTypeId == 'casual')
              .remaining,
          remainingBefore + 1,
        );

        // Deleting it takes the day again.
        await source.delete(holiday.id);
        final restored = (await leave.list(
          const LeaveQuery(search: 'Priya'),
        )).items.firstWhere((l) => l.startDate == DateTime(2026, 9, 28));
        expect(restored.days, 3);
      },
    );

    test('the leave calendar shows the holidays of the month', () async {
      final leave = LeaveMockDataSource(
        now: () => testNow,
        employees: EmployeeMockDataSource.seed(testNow),
        holidays: store,
      );
      await source.create(
        HolidayInput(date: DateTime(2026, 10, 20), name: 'Dussehra'),
      );
      final october = await leave.calendar(DateTime(2026, 10));
      expect(october.holidays.map((h) => h.name), [
        'Gandhi Jayanti',
        'Dussehra',
      ]);
    });
  });

  group('attendance on a holiday', () {
    late AttendanceMockDataSource attendance;
    // Republic Day 2026 is a Monday.
    final republicDay = DateTime(2026, 1, 26);

    setUp(
      () => attendance = AttendanceMockDataSource(
        now: () => testNow,
        holidayOn: store.on,
      ),
    );

    test('nobody is absent; the day expects nothing', () async {
      final day = await attendance.day(AttendanceQuery(date: republicDay), 1);
      expect(day.summary.absent, 0);
      for (final r in day.items.where((r) => r.punchIn == null)) {
        expect(r.status, AttendanceDayStatus.holiday);
        expect(r.expectedMinutes, 0);
      }
    });

    test('recorded work is "Holiday worked" and all overtime', () async {
      final day = await attendance.day(AttendanceQuery(date: republicDay), 1);
      final off = day.items.firstWhere((r) => r.punchIn == null);
      final record = await attendance.create(
        AttendanceCorrectionData(
          employeeId: off.employee.id,
          date: republicDay,
          punchIn: DateTime(2026, 1, 26, 10),
          punchOut: DateTime(2026, 1, 26, 15),
          reason: CorrectionReason.onFieldDuty,
        ),
      );
      expect(record.dayKind, AttendanceDayKind.holidayWorked);
      expect(record.workedMinutes, 300);
      expect(record.overtimeMinutes, 300);
      expect(record.status, AttendanceDayStatus.present);
    });

    test('a deleted holiday becomes a normal working day', () async {
      store.delete(store.on(republicDay)!.id);
      final day = await attendance.day(AttendanceQuery(date: republicDay), 1);
      expect(
        day.items.any((r) => r.status == AttendanceDayStatus.holiday),
        isFalse,
      );
    });
  });
}
