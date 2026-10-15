// Contract tests: every real API data source is run against the example
// responses in docs/api-examples/ (the same files the API contract
// document refers to), and the requests it sends are compared with the
// example requests. If the backend and these examples agree, the app will
// read and write the real API correctly.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/constants/api_constants.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/errors/error_handler.dart';
import 'package:kc_admin_portal/core/network/api_client.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_remote_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_remote_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_remote_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_remote_data_source.dart';
import 'package:kc_admin_portal/features/leave/data/models/leave_models.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_remote_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_remote_data_source.dart';
import 'package:kc_admin_portal/features/users/data/models/user_account_models.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/holiday_model.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

import '../helpers/catalogs.dart';

const String _examples = 'docs/api-examples';

Object? _example(String name) =>
    jsonDecode(File('$_examples/$name').readAsStringSync());

/// Serves example files by "METHOD /path" and records what was sent.
class _FakeServer implements HttpClientAdapter {
  final Map<String, (int, String)> _routes = {};
  RequestOptions? last;

  void on(String method, String path, String example, {int status = 200}) =>
      _routes['$method $path'] = (status, example);

  Object? get lastBody => last?.data;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    final route = _routes['${options.method} ${options.path}'];
    if (route == null) {
      return ResponseBody.fromString(
        '{"message":"no route"}',
        404,
        headers: _json,
      );
    }
    final (status, example) = route;
    return ResponseBody.fromString(
      example.isEmpty ? '' : File('$_examples/$example').readAsStringSync(),
      status,
      headers: _json,
    );
  }

  static const Map<String, List<String>> _json = {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  };

  @override
  void close({bool force = false}) {}
}

void main() {
  late _FakeServer server;
  late ApiClient client;

  setUp(() {
    server = _FakeServer();
    client = ApiClient(
      Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = server,
    );
  });

  group('employee import', () {
    late EmployeeImportApiDataSource source;
    setUp(() => source = EmployeeImportApiDataSource(client));

    test('upload, check, rows, confirm, poll, cancel', () async {
      server
        ..on(
          'POST',
          '/employee-imports',
          'employee-imports.upload.response.json',
        )
        ..on(
          'PUT',
          '/employee-imports/imp-7c1e',
          'employee-imports.check.response.json',
        )
        ..on(
          'GET',
          '/employee-imports/imp-7c1e/rows',
          'employee-imports.rows.response.json',
        )
        ..on(
          'POST',
          '/employee-imports/imp-7c1e/confirm',
          'employee-imports.completed.response.json',
        )
        ..on(
          'GET',
          '/employee-imports/imp-7c1e',
          'employee-imports.completed.response.json',
        )
        ..on('DELETE', '/employee-imports/imp-7c1e', '', status: 204);

      final upload = await source.upload(
        Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]),
        'staff.xlsx',
      );
      expect(server.last!.data, isA<FormData>());
      expect(upload.status, ImportStatus.uploaded);
      expect(upload.suggestedMapping['Designation'], 'position');

      final checked = await source.check(
        upload.id,
        ImportOptionsModel(
          mapping: upload.suggestedMapping.map(MapEntry.new),
          duplicateStrategy: DuplicateStrategy.skip,
          assignEcNumbers: true,
        ),
      );
      expect(server.lastBody, _example('employee-imports.check.request.json'));
      expect(checked.importable, 147);
      expect(checked.counts!.skipped, 1);

      final rows = await source.rows(upload.id);
      expect(server.last!.queryParameters, {
        'status': 'problems',
        'page': 1,
        'pageSize': 20,
      });
      expect(rows.items.last.changes.single.after, 'Production');

      final done = await source.confirm(upload.id);
      expect(done.result!.imported, 143);
      expect((await source.get(upload.id)).status, ImportStatus.completed);
      await source.cancel(upload.id);
      expect(server.last!.method, 'DELETE');
    });

    test('template and report arrive as bytes', () async {
      server
        ..on(
          'GET',
          '/employee-imports/template',
          'employee-imports.upload.response.json',
        )
        ..on(
          'GET',
          '/employee-imports/imp-7c1e/report',
          'employee-imports.upload.response.json',
        );
      expect(await source.template(), isNotEmpty);
      expect(await source.report('imp-7c1e'), isNotEmpty);
    });
  });

  group('auth', () {
    test('login sends credentials and reads token and user', () async {
      server.on('POST', '/auth/login', 'auth.login.response.json');
      final result = await AuthApiDataSource(
        client,
      ).login(email: 'admin@keshav.in', password: '••••••••');

      expect(server.lastBody, _example('auth.login.request.json'));
      expect(result.accessToken, isNotEmpty);
      expect(result.user.can(AppPermission.permissionManage), isTrue);
    });

    test('me, with the active organization and memberships', () async {
      server.on('GET', '/auth/me', 'auth.me.response.json');
      final user = await AuthApiDataSource(client).me();
      expect(user.email, 'admin@keshav.in');
      expect(user.organization?.name, 'Keshav Clothing');
      expect(user.organization?.timezone, 'Asia/Kolkata');
      expect(user.memberships!.map((m) => m.name), [
        'Keshav Clothing',
        'Sunrise Garments',
      ]);
      expect(user.canSwitchOrganization, isTrue);
    });

    test(
      'switch organization: a new token and the permissions there',
      () async {
        server.on(
          'POST',
          '/auth/switch-organization',
          'auth.switch-organization.response.json',
        );
        final result = await AuthApiDataSource(
          client,
        ).switchOrganization('4e7a2b90-8c3d-4f1e-b6a5-0d9c8e7f6a02');
        expect(
          server.lastBody,
          _example('auth.switch-organization.request.json'),
        );
        expect(result.accessToken, isNotEmpty);
        expect(result.user.organization?.name, 'Sunrise Garments');
        expect(result.user.can(AppPermission.permissionManage), isFalse);
      },
    );

    test('sign-up: register, verify (signed in, no organization)', () async {
      final source = AuthApiDataSource(client);
      server
        ..on('POST', '/auth/register', '', status: 204)
        ..on('POST', '/auth/verify-email', 'auth.verify-email.response.json');
      await source.register(
        name: 'Asha Iyer',
        email: 'asha@bright.in',
        password: '••••••••',
      );
      expect(server.lastBody, _example('auth.register.request.json'));

      final verified = await source.verifyEmail(
        email: 'asha@bright.in',
        code: '482913',
      );
      expect(server.lastBody, _example('auth.verify-email.request.json'));
      expect(verified.user.organization, isNull);
      expect(verified.user.needsOrganization, isTrue);
    });

    test('password reset: request a code, then a new password', () async {
      final source = AuthApiDataSource(client);
      server
        ..on('POST', '/auth/forgot-password', '', status: 204)
        ..on('POST', '/auth/reset-password', '', status: 204);
      await source.forgotPassword('asha@bright.in');
      expect(server.lastBody, _example('auth.forgot-password.request.json'));
      await source.resetPassword(
        email: 'asha@bright.in',
        code: '482913',
        password: '••••••••',
      );
      expect(server.lastBody, _example('auth.reset-password.request.json'));
    });

    test('create an organization: the creator owns it', () async {
      server.on('POST', '/organizations', 'organizations.create.response.json');
      final created = await AuthApiDataSource(client).createOrganization(
        name: 'Bright Bakery',
        timezone: 'Asia/Dubai',
        defaultCountry: 'AE',
      );
      expect(server.lastBody, _example('organizations.create.request.json'));
      expect(created.user.organization?.timezone, 'Asia/Dubai');
      expect(created.user.hasFullAccess, isTrue);
    });

    test('invitations: list, accept, decline', () async {
      final source = AuthApiDataSource(client);
      server
        ..on('GET', '/invitations', 'invitations.response.json')
        ..on(
          'POST',
          '/invitations/inv-5b2d/accept',
          'auth.switch-organization.response.json',
        )
        ..on('POST', '/invitations/inv-5b2d/decline', '', status: 204);
      final invitation = (await source.invitations()).single;
      expect(invitation.organization.name, 'Sunrise Garments');
      expect(invitation.invitedBy, 'Ravi Mehta');
      final joined = await source.acceptInvitation(invitation.id);
      expect(joined.user.organization?.name, 'Sunrise Garments');
      await source.declineInvitation(invitation.id);
      expect(server.last!.path, '/invitations/inv-5b2d/decline');
    });

    test('an unverified email is a 403 with a code', () {
      final error = ErrorHandler.fromResponse(
        403,
        _example('error.email-not-verified.response.json'),
      );
      expect(error, isA<ForbiddenException>());
      expect(
        (error as ForbiddenException).code,
        ApiConstants.emailNotVerifiedCode,
      );
    });

    test('a server without organizations still works', () {
      final json = (_example('auth.me.response.json')! as Map<String, dynamic>)
        ..remove('organization')
        ..remove('memberships');
      final user = UserModel.fromJson(json);
      expect(user.organization, isNull);
      expect(user.canSwitchOrganization, isFalse);
    });
  });

  group('department and position', () {
    test("employees carry the organization's own items", () {
      final employee = EmployeeModel.fromJson(
        _example('employees.get.response.json')! as Map<String, dynamic>,
      );
      expect(employee.department, dept('Graphic Designer'));
      expect(employee.position.name, isNotEmpty);
    });

    test('lists: read, add, rename and deactivate', () async {
      final source = OrganizationApiDataSource(client);
      server.on('GET', '/departments', 'departments.response.json');

      final list = await source.catalog(CatalogKind.departments);
      expect(list.map((d) => d.name), [
        'Accountant',
        'Graphic Designer',
        'Pressing',
      ]);
      expect(list.last.isActive, isFalse);
      expect(list.first.employeeCount, 6);

      server
        ..on('POST', '/departments', 'departments.item.response.json')
        ..on(
          'PATCH',
          '/departments/keshav-dep-production',
          'departments.item.response.json',
        );
      final added = await source.addCatalogItem(
        CatalogKind.departments,
        'Production',
      );
      expect(server.lastBody, _example('departments.create.request.json'));
      expect(added.name, 'Production');

      await source.updateCatalogItem(
        CatalogKind.departments,
        added.id,
        isActive: false,
      );
      expect(server.lastBody, _example('departments.update.request.json'));
    });

    test('organization: profile and settings', () async {
      final source = OrganizationApiDataSource(client);
      server
        ..on('GET', '/organization', 'organization.get.response.json')
        ..on('PATCH', '/organization', 'organization.get.response.json')
        ..on(
          'GET',
          '/organization/settings',
          'organization.settings.response.json',
        );
      expect((await source.profile()).timezone, 'Asia/Kolkata');
      await source.updateProfile(
        name: 'Keshav Clothing',
        timezone: 'Asia/Kolkata',
      );
      expect(server.lastBody, _example('organization.update.request.json'));

      final settings = await source.settings();
      expect(settings.ecNumberPrefix, 'KC');
      expect(settings.lateGraceMinutes, 15);
      expect(settings.defaultSchedule.weeklyOffDays, [DateTime.sunday]);
      expect(
        settings.toJson(),
        _example('organization.settings.response.json'),
      );
    });

    test('leave policy: read and save', () async {
      final source = OrganizationApiDataSource(client);
      server
        ..on(
          'GET',
          '/organization/leave-policy',
          'organization.leave-policy.response.json',
        )
        ..on(
          'PATCH',
          '/organization/leave-policy',
          'organization.leave-policy.response.json',
        );
      final policy = await source.leavePolicy();
      expect(policy.paidLeaveName, 'Casual');
      expect(policy.carryForwardCap, isNull);
      expect(policy.accrualStartMonth, DateTime(2026));

      await source.updateLeavePolicy(
        LeavePolicyModel(
          paidLeaveEnabled: true,
          paidLeaveName: 'Paid leave',
          unpaidLeaveName: 'Unpaid leave',
          daysPerMonth: 1.5,
          carryForwardCap: 12,
          accrualStartMonth: DateTime(2026),
        ),
      );
      expect(
        server.lastBody,
        _example('organization.leave-policy.request.json'),
      );
    });
  });

  group('dashboard', () {
    test('summary and chart', () async {
      server
        ..on('GET', '/dashboard/summary', 'dashboard.summary.response.json')
        ..on(
          'GET',
          '/dashboard/attendance-chart',
          'dashboard.attendance-chart.response.json',
        );
      final source = DashboardApiDataSource(client);

      final summary = await source.summary(DateTime(2026, 9, 28));
      expect(server.last!.queryParameters, {'date': '2026-09-28'});
      expect(summary.attention.first.kind, AttentionKind.notPunchedIn);
      expect(summary.onLeave.single.endDate, DateTime(2026, 9, 30));
      final usage = summary.leaveUsage!;
      expect(usage.casualRemainingDays, 412);
      expect(usage.casualTakenDays, 286);
      expect(usage.unpaidTakenDays, 26);
      expect(usage.pendingThisMonth, 3);

      final chart = await source.monthlyAttendance(DateTime(2026, 9));
      expect(server.last!.queryParameters, {'month': '2026-09'});
      expect(chart.days.last.percent, 84);
    });
  });

  group('employees', () {
    late EmployeeApiDataSource source;
    setUp(() => source = EmployeeApiDataSource(client));

    test('list sends the query and reads a page', () async {
      server.on('GET', '/employees', 'employees.list.response.json');
      final page = await source.list(
        EmployeeQuery(
          search: 'aarav',
          departmentId: dept('Tailor').id,
          joinedFrom: DateTime(2021),
          joinedTo: DateTime(2021, 12, 31),
        ),
      );

      expect(server.last!.queryParameters, {
        'search': 'aarav',
        'departmentId': 'keshav-dep-tailor',
        'joinedFrom': '2021-01-01',
        'joinedTo': '2021-12-31',
        'status': 'active',
        'page': 1,
        'pageSize': 10,
      });
      expect(page.counts, const EmployeeStatusCounts(active: 124, inactive: 4));
      expect(page.items.single.overtimeMinutesThisYear, 765);
      final employee = page.items.single;
      expect(employee.ecNumber, 'KC1001');
      expect(employee.joiningDate, DateTime(2021, 1, 12));
      expect(employee.status, EmployeeStatus.active);
      expect(employee.todayStatus, AttendanceDayStatus.present);
      // 11:05 in +05:30 is 05:35 UTC, shown in local time.
      expect(employee.updatedAt, DateTime(2026, 9, 12, 11, 5)); // company time
      expect(employee.updatedAt!.isUtc, isFalse);
    });

    test('create sends the example body', () async {
      server.on('POST', '/employees', 'employees.get.response.json');
      await source.create(
        EmployeeFormData(
          ecNumber: 'KC1129',
          name: 'Rahul Sharma',
          mobile: '+919876543210',
          departmentId: dept('Graphic Designer').id,
          positionId: post('Graphic Designer').id,
          joiningDate: DateTime(2026, 9, 28),
          status: EmployeeStatus.active,
          schedule: WorkScheduleInput(
            effectiveFrom: DateTime(2026, 9, 28),
            startTime: const ClockTime.hm(9, 0),
            endTime: const ClockTime.hm(17, 30),
            breakMinutes: 60,
            breakStart: const ClockTime.hm(13, 0),
            breakEnd: const ClockTime.hm(14, 0),
            weeklyOffDays: const [DateTime.sunday],
          ),
        ),
      );
      expect(server.lastBody, _example('employees.create.request.json'));
    });

    test('next EC number, get, update and status', () async {
      server
        ..on(
          'GET',
          '/employees/next-ec-number',
          'employees.next-ec-number.response.json',
        )
        ..on('GET', '/employees/1', 'employees.get.response.json')
        ..on('PATCH', '/employees/1', 'employees.get.response.json')
        ..on('PATCH', '/employees/1/status', 'employees.get.response.json');

      expect(await source.nextEcNumber(), 'KC1129');
      expect((await source.getById('1')).name, 'Aarav Shah');
      await source.setStatus('1', EmployeeStatus.inactive);
      expect(server.lastBody, _example('employees.status.request.json'));
    });

    test('profile data', () async {
      server
        ..on(
          'GET',
          '/employees/1/leave-balance',
          'employees.leave-balance.response.json',
        )
        ..on('GET', '/employees/1/leaves', 'employees.leaves.response.json');

      final balance = await source.leaveBalance('1');
      expect(balance.asOf, DateTime(2026, 9, 28));
      expect(balance.accrued, 9);
      expect(balance.pending, 1);
      expect(balance.remaining, 6);
      expect(balance.unpaidTaken, 1);

      final leaves = await source.leaveHistory('1');
      expect(leaves.first.isPaid, isFalse);
      expect(leaves.first.balanceAfter, isNull);
      expect(leaves.last.status, LeaveStatus.approved);
      expect(leaves.last.balanceAfter, 7);
    });
  });

  group('attendance', () {
    late AttendanceApiDataSource source;
    setUp(() => source = AttendanceApiDataSource(client));

    test('day list reads summary, rows and times', () async {
      server.on('GET', '/attendance', 'attendance.day.response.json');
      final day = await source.day(
        AttendanceQuery(
          date: DateTime(2026, 9, 28),
          filter: AttendanceFilter.late,
        ),
        1,
      );

      expect(server.last!.queryParameters, {
        'date': '2026-09-28',
        'status': 'late',
        'page': 1,
        'pageSize': 20,
      });
      // No company-wide shift: each row has its own schedule.
      expect(day.summary.shiftStart, isNull);
      expect(day.items.last.schedule?.startTime.toApi(), '09:30');
      expect(day.items.first.id, isNull); // not punched in yet
      final late = day.items.last;
      // Shown as company wall-clock time on any device.
      expect(late.punchIn, DateTime(2026, 9, 28, 10, 8));
      expect(late.lateMinutes, 38);
      expect(late.displayNote, 'Late by 38 Minutes');
    });

    test('punch in / out and bulk', () async {
      server
        ..on('POST', '/attendance/punch-in', 'attendance.record.response.json')
        ..on('POST', '/attendance/punch-out', 'attendance.record.response.json')
        ..on(
          'POST',
          '/attendance/punch-in/bulk',
          'attendance.punch-in-bulk.response.json',
        );

      await source.punchIn('7');
      expect(server.lastBody, _example('attendance.punch.request.json'));
      await source.punchOut('7');
      expect(server.lastBody, _example('attendance.punch.request.json'));
      expect(await source.punchInAll(DateTime(2026, 9, 28)), 11);
      expect(
        server.lastBody,
        _example('attendance.punch-in-bulk.request.json'),
      );
    });

    test('correction sends times with an offset', () async {
      server.on(
        'PATCH',
        '/attendance/a-7-20260928',
        'attendance.record.response.json',
      );
      final example =
          _example('attendance.correct.request.json')! as Map<String, dynamic>;

      await source.correct(
        'a-7-20260928',
        AttendanceCorrectionData(
          date: DateTime(2026, 9, 28),
          punchIn: DateTime(2026, 9, 28, 9, 35), // company wall clock
          reason: CorrectionReason.deviceIssue,
          remarks: example['remarks'] as String,
        ),
      );

      final sent = server.lastBody! as Map<String, dynamic>;
      expect(sent.keys.toSet(), example.keys.toSet());
      expect(sent['reason'], 'device_issue');
      // Sent with the company offset, whatever this machine's zone.
      expect(sent['punchIn'], example['punchIn']);
    });

    test('add missing record and employee log', () async {
      server
        ..on('POST', '/attendance', 'attendance.record.response.json')
        ..on(
          'GET',
          '/employees/7/attendance-log',
          'employees.attendance-log.response.json',
        );

      await source.create(
        AttendanceCorrectionData(
          employeeId: '7',
          date: DateTime(2026, 9, 28),
          punchIn: DateTime(2026, 9, 28, 9, 30),
          reason: CorrectionReason.forgotToPunch,
        ),
      );
      expect((server.lastBody! as Map)['employeeId'], '7');

      final log = await source.employeeLog('7', DateTime(2026, 9));
      expect(log.single.status, AttendanceDayStatus.late);
    });
  });

  group('leave', () {
    late LeaveApiDataSource source;
    setUp(() => source = LeaveApiDataSource(client));

    test('list with tab counts', () async {
      server.on('GET', '/leaves', 'leaves.list.response.json');
      final list = await source.list(
        LeaveQuery(
          status: LeaveStatus.pending,
          from: DateTime(2026, 9, 1),
          to: DateTime(2026, 10, 31),
        ),
      );

      expect(server.last!.queryParameters, {
        'status': 'pending',
        'from': '2026-09-01',
        'to': '2026-10-31',
        'page': 1,
        'pageSize': 10,
      });
      expect(list.counts.pending, 3);
      final leave = list.items.single;
      expect(leave.reason, LeaveReason.familyFunction);
      expect(leave.canDecide, isTrue);
      expect(leave.startDate, DateTime(2026, 10, 5));
    });

    test('create, update and status', () async {
      server
        ..on('POST', '/leaves', 'leaves.get.response.json')
        ..on('PATCH', '/leaves/41', 'leaves.get.response.json')
        ..on('PATCH', '/leaves/41/status', 'leaves.get.response.json');
      final data = LeaveFormData(
        employeeId: '10',
        leaveTypeId: 'casual',
        startDate: DateTime(2026, 10, 5),
        endDate: DateTime(2026, 10, 7),
        isHalfDay: false,
        reason: LeaveReason.travel,
        status: LeaveStatus.approved,
      );

      final created = await source.create(data);
      expect(server.lastBody, _example('leaves.create.request.json'));
      expect(created.isPaid, isTrue);
      expect(created.balanceAfter, 4);
      expect(created.unpaidPartId, isNull);

      // Extra days saved as Unpaid: the flag is sent only when asked.
      await source.create(
        data.copyWith(
          startDate: DateTime(2026, 10, 12),
          endDate: DateTime(2026, 10, 20),
          splitExcessAsUnpaid: true,
        ),
      );
      expect(server.lastBody, _example('leaves.create-split.request.json'));
      await source.update('41', data);
      expect(server.last!.method, 'PATCH');
      await source.setStatus('41', LeaveStatus.approved);
      expect(server.lastBody, _example('leaves.status.request.json'));
    });

    test('balances list (GET /leave-balances)', () async {
      server.on('GET', '/leave-balances', 'leave-balances.response.json');
      final list = await source.balances(
        LeaveBalanceQuery(search: 'D', departmentId: dept('Tailor').id),
      );
      expect(server.last!.queryParameters, {
        'search': 'D',
        'departmentId': 'keshav-dep-tailor',
        'page': 1,
        'pageSize': 10,
      });
      expect(list.items.first.employee.department, dept('Graphic Designer'));
      expect(list.items.first.balance.pending, 3);
      expect(list.items.last.balance.unpaidTaken, 2);
      expect(list.summary.employees, 19);
      expect(list.summary.remaining, 148.5);
    });

    test('types, preview and calendar', () async {
      server
        ..on('GET', '/leave-types', 'leave-types.response.json')
        ..on('POST', '/leaves/preview', 'leaves.preview.response.json')
        ..on('GET', '/leave-calendar', 'leave-calendar.response.json');

      final types = await source.types();
      expect(types.last.hasBalance, isFalse);
      expect(types.last.isPaid, isFalse);

      final preview = await source.preview(
        LeavePreviewRequest(
          employeeId: '10',
          leaveTypeId: 'casual',
          startDate: DateTime(2026, 10, 5),
          endDate: DateTime(2026, 10, 7),
          isHalfDay: false,
        ),
      );
      expect(server.lastBody, _example('leaves.preview.request.json'));
      expect(preview.paidDays, 7);
      expect(preview.unpaidDays, 1);
      expect(preview.availableCasual, 7);
      expect(preview.needsSplit, isTrue);

      final calendar = await source.calendar(
        DateTime(2026, 10),
        employeeId: '10',
      );
      expect(server.last!.queryParameters, {
        'month': '2026-10',
        'employeeId': '10',
      });
      expect(calendar.holidays.single.date, DateTime(2026, 10, 2));
      expect(calendar.weeklyOffDays, [DateTime.sunday]);
      expect(calendar.weekOffDates.first, DateTime(2026, 10, 4));
      expect(calendar.isWeekOff(DateTime(2026, 10, 11)), isTrue);
      expect(calendar.isWeekOff(DateTime(2026, 10, 10)), isFalse);
    });
  });

  test('validation errors reach the right form field', () async {
    server.on(
      'POST',
      '/employees',
      'error.validation.response.json',
      status: 422,
    );
    await expectLater(
      EmployeeApiDataSource(client).create(
        EmployeeFormData(
          ecNumber: 'KC1001',
          name: 'X',
          mobile: '9876543210',
          departmentId: dept('Graphic Designer').id,
          positionId: post('Graphic Designer').id,
          joiningDate: DateTime(2026, 9, 28),
          status: EmployeeStatus.active,
        ),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors['ecNumber'],
          'ecNumber error',
          'This EC number is already in use',
        ),
      ),
    );
  });

  group('holidays', () {
    late HolidayApiDataSource source;
    setUp(() => source = HolidayApiDataSource(client));

    test('list by year and search', () async {
      server.on('GET', '/holidays', 'holidays.list.response.json');
      final list = await source.list(year: 2026, search: ' diwali ');
      expect(server.last!.queryParameters, {'year': 2026, 'search': 'diwali'});
      expect(list.last.description, 'Office closed');
    });

    test('create, update and delete', () async {
      server
        ..on('POST', '/holidays', 'holidays.get.response.json')
        ..on('PATCH', '/holidays/12', 'holidays.get.response.json')
        ..on('DELETE', '/holidays/12', '', status: 204);

      final input = HolidayInput(
        date: DateTime(2026, 10, 2),
        name: 'Company Holiday',
      );
      await source.create(input);
      expect(server.lastBody, _example('holidays.create.request.json'));

      final updated = await source.update('12', input);
      expect(updated.name, 'Gandhi Jayanti');
      expect(server.last!.method, 'PATCH');

      await source.delete('12');
      expect(server.last!.method, 'DELETE');
    });
  });

  group('permissions', () {
    test('the catalogue', () async {
      server.on('GET', '/permissions', 'permissions.response.json');
      final modules = await AccessApiDataSource(client).permissions();
      expect(modules.first.permissions.single.key, 'dashboard.view');
    });
  });

  group('users', () {
    late UserApiDataSource source;
    setUp(() => source = UserApiDataSource(client));

    test('list with search, role and page', () async {
      server.on('GET', '/users', 'users.list.response.json');
      final page = await source.list(const UserQuery(search: 'nisha', page: 2));
      expect(server.last!.queryParameters, {
        'search': 'nisha',
        'page': 2,
        'pageSize': 10,
      });
      expect(page.items.last.employee?.ecNumber, 'KC1025');
    });

    test('create, edit (unlinking the employee), set permissions', () async {
      server
        ..on('POST', '/users', 'users.get.response.json')
        ..on('GET', '/users/7', 'users.get.response.json')
        ..on('PATCH', '/users/7', 'users.get.response.json')
        ..on('PUT', '/users/7/permissions', 'users.get.response.json');

      await source.create(
        const UserAccountInput(
          name: 'Nisha Solanki',
          email: 'nisha.solanki@keshav.in',
          employeeId: '25',
        ),
      );
      expect(server.lastBody, _example('users.create.request.json'));

      final user = await source.getById('7');
      expect(user.permissions, contains('leave.approve'));

      await source.update(
        '7',
        const UserAccountUpdate(
          name: 'Nisha Solanki',
          email: 'nisha.solanki@keshav.in',
        ),
      );
      expect(server.lastBody, {
        'name': 'Nisha Solanki',
        'email': 'nisha.solanki@keshav.in',
        'employeeId': null,
      });

      await source.setPermissions('7', const [
        'dashboard.view',
        'employee.view',
        'leave.approve',
        'leave.view',
      ]);
      expect(server.last!.method, 'PUT');
      expect(server.last!.path, '/users/7/permissions');
      expect(server.lastBody, _example('users.permissions.request.json'));
    });
  });

  test('overtime report for a date range', () async {
    server.on(
      'GET',
      '/employees/1/overtime',
      'employees.overtime.response.json',
    );
    final report = await OvertimeApiDataSource(
      client,
    ).report('1', from: DateTime(2026, 9), to: DateTime(2026, 9, 30));
    expect(server.last!.queryParameters, {
      'from': '2026-09-01',
      'to': '2026-09-30',
    });
    expect(report.totalMinutes, 600);
    expect(report.dayBasisMinutes, 450);
  });

  group('employee calendar', () {
    test('a month', () async {
      server.on(
        'GET',
        '/employees/1/calendar',
        'employees.calendar.response.json',
      );
      final month = await CalendarApiDataSource(
        client,
      ).month('1', DateTime(2026, 10));
      expect(server.last!.queryParameters, {'month': '2026-10'});
      expect(month.days.first.overtimeMinutes, 92);
      expect(month.summary.holidayWorked, 1);
    });

    test('a day with its history', () async {
      server.on(
        'GET',
        '/employees/1/calendar/2026-10-03',
        'employees.calendar-day.response.json',
      );
      final day = await CalendarApiDataSource(
        client,
      ).day('1', DateTime(2026, 10, 3));
      expect(day.day.attendance?.corrected, isTrue);
      expect(day.history.single.summary, 'Corrected punch in');
    });
  });
}
