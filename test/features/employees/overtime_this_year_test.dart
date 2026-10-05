import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_mock_data_source.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

void main() {
  group('current-year overtime (mock of the backend)', () {
    Future<(EmployeeModel, OvertimeMockDataSource)> load(DateTime today) async {
      final store = EmployeeMockDataSource.seed(today);
      final attendance = AttendanceMockDataSource(
        now: () => today,
        store: store,
      );
      final employees = EmployeeMockDataSource(
        now: () => today,
        store: store,
        attendance: attendance,
      );
      final page = await employees.list(const EmployeeQuery());
      return (page.items.first, OvertimeMockDataSource(attendance: attendance));
    }

    test('1 January to today, from the attendance records', () async {
      final (employee, overtime) = await load(testNow);
      final report = await overtime.report(
        employee.id,
        from: DateTime(2026),
        to: testNow,
      );
      expect(employee.overtimeMinutesThisYear, report.totalMinutes);
      expect(employee.overtimeMinutesThisYear, greaterThan(0));
    });

    test('rolls over with the year', () async {
      final newYear = DateTime(2027, 1, 2, 18);
      final (employee, overtime) = await load(newYear);
      final report = await overtime.report(
        employee.id,
        from: DateTime(2027),
        to: newYear,
      );
      expect(employee.overtimeMinutesThisYear, report.totalMinutes);
      // Last year's overtime is not carried in.
      final (sameEmployeeLastYear, _) = await load(DateTime(2026, 12, 31, 18));
      expect(
        employee.overtimeMinutesThisYear,
        lessThan(sameEmployeeLastYear.overtimeMinutesThisYear!),
      );
    });

    test('left out for people who may not see overtime', () async {
      final access = MockAccessStore()
        ..setPermissions('u4', const ['employee.view'])
        ..resume('u4');
      final store = EmployeeMockDataSource.seed(testNow);
      final employees = EmployeeMockDataSource(
        now: () => testNow,
        store: store,
        guard: MockGuard(store: access),
        attendance: AttendanceMockDataSource(now: () => testNow, store: store),
      );
      final page = await employees.list(const EmployeeQuery());
      expect(page.items.first.overtimeMinutesThisYear, isNull);
    });
  });

  group('employee list', () {
    Future<void> open(WidgetTester tester, {required bool seeOvertime}) async {
      final user = seeOvertime
          ? testUser
          : testUser.copyWith(
              permissions: [
                for (final p in testUser.permissions)
                  if (p != AppPermission.overtimeView.key) p,
              ],
            );
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: user),
        size: const Size(1920, 1000),
      );
      router.go('/employees');
      await tester.pumpAndSettle();
    }

    testWidgets('shows overtime this year instead of the joining date', (
      tester,
    ) async {
      await open(tester, seeOvertime: true);
      expect(find.text('OVERTIME THIS YEAR'), findsOneWidget);
      expect(find.text('JOINED'), findsNothing);
      expect(find.text('12 Jan 2021'), findsNothing); // Aarav's joining date
      // Durations in hours and minutes, never "N Minutes" over an hour.
      expect(
        find.textContaining(RegExp(r'^\d+ Hours?( \d+ Minutes?)?$')),
        findsWidgets,
      );
      // The Joined filter stays.
      expect(find.textContaining('Joined'), findsOneWidget);
    });

    testWidgets('no overtime column without overtime.view', (tester) async {
      await open(tester, seeOvertime: false);
      expect(find.text('OVERTIME THIS YEAR'), findsNothing);
    });
  });

  test('the formatter is what the list uses', () {
    expect(DurationFormat.full(765), '12 Hours 45 Minutes');
  });
}
