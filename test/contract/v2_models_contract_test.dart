// Contract tests for the V2 models (schedules, overtime, calendar, holidays,
// roles and permissions, users, audit). Each example in docs/api-examples/
// must parse into the app's model, and each example request must be exactly
// what the app's input model sends. Data-source tests are added as each
// feature gets its API data source.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_permission_catalogue.dart';
import 'package:kc_admin_portal/features/access_control/data/models/access_models.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/calendar/data/models/calendar_models.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/overtime/data/models/overtime_models.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/models/audit_entry_model.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

Object? _example(String name) =>
    jsonDecode(File('docs/api-examples/$name').readAsStringSync());

Map<String, dynamic> _object(String name) =>
    _example(name)! as Map<String, dynamic>;

List<Map<String, dynamic>> _list(String name) =>
    (_example(name)! as List).cast<Map<String, dynamic>>();

void main() {
  group('auth', () {
    test('me carries the user\'s own permissions', () {
      final user = UserModel.fromJson(_object('auth.me.response.json'));
      expect(user.grants, AppPermission.values.toSet());
      expect(user.hasFullAccess, isTrue);
    });

    test('unknown permission keys are ignored, not fatal', () {
      final user = UserModel.fromJson({
        ..._object('auth.me.response.json'),
        'permissions': ['employee.view', 'payroll.run'],
      });
      expect(user.grants, {AppPermission.employeeView});
      expect(user.can(AppPermission.employeeEdit), isFalse);
    });

    test('the example permissions are exactly the app catalogue', () {
      final keys = (_object('auth.me.response.json')['permissions'] as List)
          .cast<String>();
      expect(keys.toSet(), {for (final p in AppPermission.values) p.key});
    });
  });

  group('working schedules', () {
    test('an employee includes the current schedule', () {
      final employee = EmployeeModel.fromJson(
        _object('employees.get.response.json'),
      );
      final schedule = employee.schedule!;
      expect(schedule.startTime, const ClockTime.hm(9, 0));
      expect(schedule.endTime, const ClockTime.hm(17, 30));
      expect(schedule.breakMinutes, 60);
      expect(schedule.breakStart, const ClockTime.hm(13, 0));
      expect(schedule.weeklyOffDays, [DateTime.sunday]);
      expect(schedule.expectedMinutes, 450);
      expect(schedule.effectiveTo, isNull);
    });

    test('history lists versions, newest first', () {
      final versions = _list(
        'employees.schedules.response.json',
      ).map(WorkScheduleModel.fromJson).toList();
      expect(versions.first.effectiveTo, isNull);
      expect(versions.last.effectiveTo, DateTime(2026, 3, 31));
      expect(versions.last.breakStart, isNull);
    });

    test('creating an employee sends its first schedule', () {
      final schedule = WorkScheduleInput(
        effectiveFrom: _sep28,
        startTime: const ClockTime.hm(9, 0),
        endTime: const ClockTime.hm(17, 30),
        breakMinutes: 60,
        breakStart: const ClockTime.hm(13, 0),
        breakEnd: const ClockTime.hm(14, 0),
        weeklyOffDays: const [DateTime.sunday],
      );
      final body = EmployeeFormData(
        ecNumber: 'KC1129',
        name: 'Rahul Sharma',
        email: 'rahul.sharma@keshav.in',
        mobile: '9876543210',
        departmentId: '4',
        designationId: '21',
        joiningDate: _sep28,
        status: EmployeeStatus.active,
        schedule: schedule,
      ).toJson();
      expect(body, _object('employees.create.request.json'));
    });

    test('an update without a schedule does not send one', () {
      final body = EmployeeFormData(
        ecNumber: 'KC1129',
        name: 'Rahul Sharma',
        email: 'rahul.sharma@keshav.in',
        mobile: '9876543210',
        departmentId: '4',
        designationId: '21',
        joiningDate: _sep28,
        status: EmployeeStatus.active,
      ).toJson();
      expect(body.containsKey('schedule'), isFalse);
    });

    test('a new schedule version', () {
      final body = WorkScheduleInput(
        effectiveFrom: DateTime(2026, 10),
        startTime: const ClockTime.hm(10, 0),
        endTime: const ClockTime.hm(18, 30),
        breakMinutes: 60,
        breakStart: const ClockTime.hm(13, 0),
        breakEnd: const ClockTime.hm(14, 0),
        weeklyOffDays: const [DateTime.sunday],
      ).toJson();
      expect(body, _object('employees.schedules.create.request.json'));
    });
  });

  group('attendance', () {
    test('records carry their schedule, day kind and overtime', () {
      final record = AttendanceRecordModel.fromJson(
        _object('attendance.record.response.json'),
      );
      expect(record.dayKind, AttendanceDayKind.working);
      expect(record.schedule?.startTime, const ClockTime.hm(9, 30));
      expect(record.expectedMinutes, 480);
      expect(record.overtimeMinutes, 0);
    });

    test('older responses without the new fields still parse', () {
      final json = _object('attendance.record.response.json')
        ..remove('dayKind')
        ..remove('schedule')
        ..remove('expectedMinutes')
        ..remove('overtimeMinutes');
      final record = AttendanceRecordModel.fromJson(json);
      expect(record.dayKind, AttendanceDayKind.working);
      expect(record.schedule, isNull);
    });
  });

  group('overtime', () {
    test('report in minutes with the day basis', () {
      final report = OvertimeReportModel.fromJson(
        _object('employees.overtime.response.json'),
      );
      expect(report.totalMinutes, 600);
      expect(report.dayBasisMinutes, 450);
      expect(
        report.days.map((d) => d.overtimeMinutes).reduce((a, b) => a + b),
        report.totalMinutes,
      );
      expect(report.days[1].dayKind, AttendanceDayKind.weekOffWorked);
      expect(report.days[1].expectedMinutes, 0);
    });

    test('working hours of the range and of each month', () {
      final report = OvertimeReportModel.fromJson(
        _object('employees.overtime.response.json'),
      );
      expect(report.expectedMinutes, 9450);
      expect(report.workedMinutes, 9810);
      expect(report.months.single.workedMinutes, report.workedMinutes);
    });
  });

  group('employee calendar', () {
    final calendar = EmployeeCalendarModel.fromJson(
      _object('employees.calendar.response.json'),
    );
    CalendarDayModel day(int d) =>
        calendar.days.firstWhere((x) => x.date == DateTime(2026, 10, d));

    test('working day with overtime', () {
      expect(day(1).dayType, CalendarDayType.working);
      expect(day(1).schedule?.expectedMinutes, 450);
      expect(day(1).attendance?.workedMinutes, 542);
      expect(day(1).overtimeMinutes, 92);
    });

    test('work on a holiday counts fully as overtime', () {
      expect(day(2).dayType, CalendarDayType.holiday);
      expect(day(2).holidayName, 'Gandhi Jayanti');
      expect(day(2).schedule, isNull);
      expect(day(2).attendance?.dayKind, AttendanceDayKind.holidayWorked);
      expect(day(2).overtimeMinutes, 300);
    });

    test('corrections, weekly offs and leave', () {
      expect(day(3).attendance?.corrected, isTrue);
      expect(day(4).dayType, CalendarDayType.weekOff);
      expect(day(4).attendance, isNull);
      expect(day(5).leaves.single.status, LeaveStatus.approved);
      expect(day(6).attendance?.status, AttendanceDayStatus.absent);
      expect(day(6).leaves.single.status, LeaveStatus.pending);
    });

    test('month summary adds up', () {
      final summary = calendar.summary;
      expect(summary.overtimeMinutes, 92 + 300);
      expect(summary.workedMinutes, 542 + 300 + 415);
      expect(summary.holidayWorked, 1);
    });

    test('day detail includes its change history', () {
      final detail = CalendarDayDetailModel.fromJson(
        _object('employees.calendar-day.response.json'),
      );
      final entry = detail.history.single;
      expect(entry.action, 'attendance.correct');
      expect(entry.actor.name, 'Admin');
      expect(entry.changes.single.before, '10:05');
      expect(entry.changes.single.after, '09:40');
    });
  });

  group('holidays', () {
    test('list and single', () {
      final holidays = _list(
        'holidays.list.response.json',
      ).map(HolidayModel.fromJson).toList();
      expect(holidays, hasLength(3));
      expect(
        HolidayModel.fromJson(_object('holidays.get.response.json')).date,
        DateTime(2026, 10, 2),
      );
    });

    test('create request', () {
      final body = HolidayInput(
        date: DateTime(2026, 10, 2),
        name: 'Company Holiday',
      ).toJson();
      expect(body, _object('holidays.create.request.json'));
    });
  });

  group('permissions', () {
    test('the catalogue lists every permission the app knows, once', () {
      final modules = _list(
        'permissions.response.json',
      ).map(PermissionModuleModel.fromJson).toList();
      final keys = [
        for (final module in modules)
          for (final permission in module.permissions) permission.key,
      ];
      expect(keys.toSet(), hasLength(keys.length));
      expect(keys.toSet(), {for (final p in AppPermission.values) p.key});
    });

    test('the dev mock serves exactly this catalogue', () {
      final modules = _list(
        'permissions.response.json',
      ).map(PermissionModuleModel.fromJson).toList();
      expect(mockPermissionCatalogue, modules);
    });
  });

  group('users', () {
    test('list with each user\'s permissions and linked employee', () {
      final list = UserAccountListModel.fromJson(
        _object('users.list.response.json'),
      );
      expect(
        AppPermission.parseAll(list.items.first.permissions),
        AppPermission.values.toSet(),
      );
      expect(list.items.last.permissions, contains('leave.approve'));
      expect(list.items.last.employee?.ecNumber, 'KC1025');
      expect(list.items.last.lastSignInAt, isNull);
    });

    test('create request', () {
      expect(
        const UserAccountInput(
          name: 'Nisha Solanki',
          email: 'nisha.solanki@keshav.in',
          employeeId: '25',
        ).toJson(),
        _object('users.create.request.json'),
      );
    });
  });

  test('audit log page', () {
    final json = _object('audit-logs.response.json');
    final items = (json['items'] as List).cast<Map<String, dynamic>>().map(
      AuditEntryModel.fromJson,
    );
    expect(items.single.summary, 'Corrected punch in');
  });

  group('dashboard', () {
    test('a working day: scheduled, weekly off, off-day work, overtime', () {
      final summary = DashboardSummaryModel.fromJson(
        _object('dashboard.summary.response.json'),
      );
      expect(summary.scheduledToday, 124);
      expect(summary.holiday, isNull);
      expect(summary.overtimeMinutesThisMonth, 2550);
      expect(summary.overtimeEmployeesThisMonth, 8);
    });

    test('a company holiday: nobody scheduled, nobody absent', () {
      final summary = DashboardSummaryModel.fromJson(
        _object('dashboard.summary-holiday.response.json'),
      );
      expect(summary.holiday?.name, 'Gandhi Jayanti');
      expect(summary.scheduledToday, 0);
      expect(summary.absentToday, 0);
      expect(summary.presentPercent, isNull);
      expect(summary.holidayWorkedToday, 2);
    });

    test('older responses without the V2 fields still parse', () {
      final json = _object('dashboard.summary.response.json')
        ..remove('scheduledToday')
        ..remove('holiday')
        ..remove('weekOffToday')
        ..remove('holidayWorkedToday')
        ..remove('weekOffWorkedToday')
        ..remove('overtimeMinutesThisMonth')
        ..remove('overtimeEmployeesThisMonth');
      final summary = DashboardSummaryModel.fromJson(json);
      expect(summary.scheduledToday, isNull);
      expect(summary.weekOffToday, 0);
    });
  });

  group('error codes', () {
    test('editing non-pending leave is a 409 with a code', () {
      final error = ErrorHandler.fromResponse(
        409,
        _example('error.leave-not-editable.response.json'),
      );
      expect(error, isA<ValidationException>());
      expect((error as ValidationException).code, 'LEAVE_NOT_EDITABLE');
      expect(error.message, 'Only pending leave can be edited.');
    });

    test('a missing permission is a 403 with the server message', () {
      final error = ErrorHandler.fromResponse(
        403,
        _example('error.forbidden.response.json'),
      );
      expect(error, isA<ForbiddenException>());
      expect((error as ForbiddenException).code, 'PERMISSION_DENIED');
      expect(error.message, 'You do not have permission to edit employees.');
    });
  });
}

final DateTime _sep28 = DateTime(2026, 9, 28);
