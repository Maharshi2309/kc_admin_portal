import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_mock_data_source.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/calendar/presentation/calendar_cell_state.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/shared/models/named_ref.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

CalendarDayModel _day(
  DateTime date, {
  CalendarDayType type = CalendarDayType.working,
  CalendarAttendanceModel? attendance,
  List<CalendarLeaveModel> leaves = const [],
  int overtime = 0,
}) => CalendarDayModel(
  date: date,
  dayType: type,
  attendance: attendance,
  leaves: leaves,
  overtimeMinutes: overtime,
);

CalendarLeaveModel _leave(LeaveStatus status, {bool half = false}) =>
    CalendarLeaveModel(
      id: 'l',
      leaveType: const NamedRef(id: 'casual', name: 'Casual'),
      status: status,
      isHalfDay: half,
    );

void main() {
  final today = DateTime(2026, 9, 28);
  final past = DateTime(2026, 9, 24);
  final future = DateTime(2026, 10, 6);

  group('cell states (one colour per day)', () {
    test('attendance on working days', () {
      for (final (status, state) in [
        (AttendanceDayStatus.present, CalendarCellState.present),
        (AttendanceDayStatus.late, CalendarCellState.late),
        (AttendanceDayStatus.halfDay, CalendarCellState.halfDay),
        (AttendanceDayStatus.onLeave, CalendarCellState.onLeave),
        (AttendanceDayStatus.absent, CalendarCellState.absent),
      ]) {
        final day = _day(
          past,
          attendance: CalendarAttendanceModel(status: status),
        );
        expect(cellStateOf(day, today), state, reason: '$status');
      }
    });

    test('holidays and weekly offs, worked or not', () {
      final worked = CalendarAttendanceModel(
        status: AttendanceDayStatus.present,
        punchIn: DateTime(2026, 9, 24, 10),
      );
      expect(
        cellStateOf(_day(past, type: CalendarDayType.holiday), today),
        CalendarCellState.holiday,
      );
      expect(
        cellStateOf(
          _day(past, type: CalendarDayType.holiday, attendance: worked),
          today,
        ),
        CalendarCellState.holidayWorked,
      );
      expect(
        cellStateOf(_day(past, type: CalendarDayType.weekOff), today),
        CalendarCellState.weekOff,
      );
      expect(
        cellStateOf(
          _day(past, type: CalendarDayType.weekOff, attendance: worked),
          today,
        ),
        CalendarCellState.weekOffWorked,
      );
    });

    test('days to come: planned leave shows, otherwise a working day', () {
      expect(cellStateOf(_day(future), today), CalendarCellState.upcoming);
      expect(
        cellStateOf(
          _day(future, leaves: [_leave(LeaveStatus.approved)]),
          today,
        ),
        CalendarCellState.onLeave,
      );
      expect(
        cellStateOf(
          _day(future, leaves: [_leave(LeaveStatus.approved, half: true)]),
          today,
        ),
        CalendarCellState.halfDay,
      );
      // Pending leave doesn't change the colour; it is a marker.
      final pending = _day(future, leaves: [_leave(LeaveStatus.pending)]);
      expect(cellStateOf(pending, today), CalendarCellState.upcoming);
      expect(markersOf(pending), [CalendarMarker.pendingLeave]);
    });

    test('markers: pending leave, corrected, overtime', () {
      final day = _day(
        past,
        attendance: const CalendarAttendanceModel(
          status: AttendanceDayStatus.present,
          corrected: true,
        ),
        leaves: [_leave(LeaveStatus.pending), _leave(LeaveStatus.rejected)],
        overtime: 45,
      );
      expect(markersOf(day), [
        CalendarMarker.pendingLeave,
        CalendarMarker.corrected,
        CalendarMarker.overtime,
      ]);
      expect(
        leaveShortOf(_day(past, leaves: [_leave(LeaveStatus.approved)])),
        'CL',
      );
    });
  });

  group('calendar month (mock, from the shared records)', () {
    late CalendarMockDataSource source;
    late AttendanceMockDataSource attendance;
    late LeaveMockDataSource leaves;
    late MockHolidayStore holidays;

    setUp(() {
      final employees = EmployeeMockDataSource.seed(testNow);
      final schedules = MockScheduleBook(now: () => testNow)
        ..seed([for (final e in employees) (id: e.id, joined: e.joiningDate)]);
      holidays = MockHolidayStore(now: () => testNow);
      leaves = LeaveMockDataSource(
        now: () => testNow,
        employees: employees,
        holidays: holidays,
        schedules: schedules,
      );
      attendance = AttendanceMockDataSource(
        now: () => testNow,
        store: employees,
        schedules: schedules,
        holidayOn: holidays.on,
        leaveOn: leaves.leaveOn,
      );
      source = CalendarMockDataSource(
        now: () => testNow,
        attendance: attendance,
        leaves: leaves,
        holidays: holidays,
      );
    });

    test(
      'every day of the month, with approved leave and weekly offs',
      () async {
        final september = await source.month('1', DateTime(2026, 9));
        expect(september.days, hasLength(30));
        CalendarDayModel on(int d) =>
            september.days.firstWhere((x) => x.date.day == d);

        // Aarav: approved casual leave 21–22 Sep; Sundays off.
        expect(cellStateOf(on(21), today), CalendarCellState.onLeave);
        expect(on(21).leaves.single.status, LeaveStatus.approved);
        expect(on(27).dayType, CalendarDayType.weekOff);
        // After today: nothing recorded yet.
        expect(on(29).attendance, isNull);
        expect(cellStateOf(on(29), today), CalendarCellState.upcoming);
        // Today has its own schedule.
        expect(on(28).schedule?.expectedMinutes, 450);
      },
    );

    test('pending and rejected leave are listed; cancelled is not', () async {
      final dhruv = await source.month('8', DateTime(2026, 10));
      final fifth = dhruv.days.firstWhere((d) => d.date.day == 5);
      expect(fifth.leaves.single.status, LeaveStatus.pending);
      expect(markersOf(fifth), contains(CalendarMarker.pendingLeave));

      final rohan = await source.month('3', DateTime(2026, 9));
      expect(
        rohan.days.firstWhere((d) => d.date.day == 8).leaves.single.status,
        LeaveStatus.rejected,
      );
      // Arjun's 3–4 Sep leave was cancelled: not on the calendar.
      final arjun = await source.month('7', DateTime(2026, 9));
      expect(arjun.days.firstWhere((d) => d.date.day == 3).leaves, isEmpty);
    });

    test('company holidays, and work done on one', () async {
      final october = await source.month('1', DateTime(2026, 10));
      final gandhiJayanti = october.days.firstWhere((d) => d.date.day == 2);
      expect(gandhiJayanti.dayType, CalendarDayType.holiday);
      expect(gandhiJayanti.holidayName, 'Gandhi Jayanti');

      // Republic Day 2026 (Mon 26 Jan): record Priya's work, see it on the
      // calendar.
      final republicDay = DateTime(2026, 1, 26);
      await attendance.create(
        AttendanceCorrectionData(
          employeeId: '2',
          date: republicDay,
          punchIn: DateTime(2026, 1, 26, 10),
          punchOut: DateTime(2026, 1, 26, 15),
          reason: CorrectionReason.onFieldDuty,
        ),
      );
      final january = await source.month('2', DateTime(2026));
      final day = january.days.firstWhere((d) => d.date.day == 26);
      expect(cellStateOf(day, today), CalendarCellState.holidayWorked);
      expect(day.overtimeMinutes, 300);
      expect(markersOf(day), [
        CalendarMarker.corrected,
        CalendarMarker.overtime,
      ]);
      expect(january.summary.holidayWorked, 1);
    });

    test('the month totals add up', () async {
      final september = await source.month('1', DateTime(2026, 9));
      final summary = september.summary;
      final pastWorking = september.days.where(
        (d) => d.dayType == CalendarDayType.working && !d.date.isAfter(today),
      );
      expect(summary.workingDays, pastWorking.length);
      expect(
        summary.overtimeMinutes,
        september.days.fold(0, (sum, d) => sum + d.overtimeMinutes),
      );
      expect(summary.leaveDays, 2); // 21–22 Sep
      expect(summary.weekOffs, 4); // Sundays 6, 13, 20, 27
    });

    test('a single day', () async {
      final detail = await source.day('1', DateTime(2026, 9, 21));
      expect(detail.day.leaves.single.status, LeaveStatus.approved);
    });
  });

  testWidgets('the profile calendar: colours, markers and legend', (
    tester,
  ) async {
    final router = await pumpFullApp(
      tester,
      repository: FakeAuthRepository(sessionUser: testUser),
      size: const Size(1440, 1200),
    );
    router.go('/employees/1');
    await tester.pumpAndSettle();

    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('This month so far'), findsOneWidget);
    expect(find.text('September 2026'), findsOneWidget);
    // Each day describes itself for screen readers and the tooltip.
    expect(
      find.bySemanticsLabel(RegExp(r'^Mon, 21 Sep 2026 · On leave')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'^Sun, 27 Sep 2026 · Week off')),
      findsOneWidget,
    );
    // Legend: only what appears this month.
    expect(find.text('On leave'), findsWidgets);
    expect(find.text('Week off'), findsWidgets);
    expect(find.text('Company holiday'), findsNothing);
  });
}
