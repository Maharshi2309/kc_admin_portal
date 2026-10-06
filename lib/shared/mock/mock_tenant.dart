import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kc_admin_portal/core/config/mock_latency.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/utils/clock.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/access_mock_data_source.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_access_store.dart';
import 'package:kc_admin_portal/features/access_control/data/datasources/mock_guard.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/calendar/data/datasources/calendar_mock_data_source.dart';
import 'package:kc_admin_portal/features/dashboard/data/datasources/dashboard_mock_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/mock_schedule_book.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/holiday_mock_data_source.dart';
import 'package:kc_admin_portal/features/holidays/data/datasources/mock_holiday_store.dart';
import 'package:kc_admin_portal/features/leave/data/datasources/leave_mock_data_source.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_mock_data_source.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_mock_data_source.dart';
import 'package:kc_admin_portal/features/users/data/datasources/user_mock_data_source.dart';
import 'package:kc_admin_portal/shared/mock/mock_audit_log.dart';
import 'package:kc_admin_portal/shared/mock/mock_directory.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';

/// DEV ONLY (`USE_MOCK_API=true`): everything the dev mock stores for one
/// organization, playing the backend's per-organization data
/// (docs/ARCHITECTURE_MULTI_ORG.md §B). Each organization has its own
/// employees, schedules, holidays, attendance, leave, members and history;
/// nothing is shared between organizations except the [MockSession].
///
/// Every endpoint goes through this organization's [guard], which refuses a
/// session working in another organization (404).
class MockTenant {
  MockTenant({
    required this.organizationId,
    required MockSession session,
    required DateTime Function() now,
    MockDirectory? directory,
    Duration latency = Duration.zero,
    SessionEvents? sessionEvents,
  }) {
    employees = switch (organizationId) {
      MockSession.keshavId => EmployeeMockDataSource.seed(now()),
      MockSession.sunriseId => EmployeeMockDataSource.seedSunrise(now()),
      _ => <EmployeeModel>[],
    };
    schedules = MockScheduleBook(now: now)
      ..seed([for (final e in employees) (id: e.id, joined: e.joiningDate)]);
    audit = MockAuditLog(now: now);
    holidays = MockHolidayStore(
      now: now,
      audit: audit,
      extra: organizationId == MockSession.sunriseId
          ? const [(4, 14, 'Foundation Day')]
          : const [],
    );
    access = MockAccessStore(
      employees: employees,
      now: now,
      organizationId: organizationId,
      session: session,
    );
    guard = MockGuard(store: access, sessionEvents: sessionEvents);
    organization = OrganizationMockDataSource(
      organizationId: organizationId,
      directory: directory ?? MockDirectory(),
      employees: employees,
      now: now,
      guard: guard,
      latency: latency,
    );
    leaves = LeaveMockDataSource(
      guard: guard,
      now: now,
      employees: employees,
      latency: latency,
      holidays: holidays,
      schedules: schedules,
      audit: audit,
      policy: () => organization.currentLeavePolicy,
    );
    attendance = AttendanceMockDataSource(
      guard: guard,
      now: now,
      latency: latency,
      store: employees,
      schedules: schedules,
      holidayOn: holidays.on,
      leaveOn: leaves.leaveOn,
      audit: audit,
      lateGraceMinutes: () => organization.currentSettings.lateGraceMinutes,
    );
    employeeSource = EmployeeMockDataSource(
      attendance: attendance,
      guard: guard,
      now: now,
      latency: latency,
      store: employees,
      leaves: leaves,
      schedules: schedules,
      holidays: holidays,
      organization: organization,
    );
    employeeImport = EmployeeImportMockDataSource(
      organization: organization,
      employeeSource: employeeSource,
      employees: employees,
      guard: guard,
      latency: latency,
    );
    calendar = CalendarMockDataSource(
      guard: guard,
      now: now,
      attendance: attendance,
      leaves: leaves,
      holidays: holidays,
      audit: audit,
      latency: latency,
    );
    overtime = OvertimeMockDataSource(
      guard: guard,
      attendance: attendance,
      latency: latency,
    );
    dashboard = DashboardMockDataSource(
      guard: guard,
      now: now,
      latency: latency,
      attendance: attendance,
      leaves: leaves,
      holidayOn: holidays.on,
    );
    holidaySource = HolidayMockDataSource(
      guard: guard,
      store: holidays,
      latency: latency,
    );
    users = UserMockDataSource(guard: guard, store: access, latency: latency);
    accessSource = AccessMockDataSource(
      guard: guard,
      store: access,
      latency: latency,
    );
  }

  final String organizationId;

  late final List<EmployeeModel> employees;
  late final MockScheduleBook schedules;
  late final MockAuditLog audit;
  late final MockHolidayStore holidays;
  late final MockAccessStore access;
  late final MockGuard guard;
  late final OrganizationMockDataSource organization;
  late final LeaveMockDataSource leaves;
  late final AttendanceMockDataSource attendance;
  late final EmployeeMockDataSource employeeSource;
  late final EmployeeImportMockDataSource employeeImport;
  late final CalendarMockDataSource calendar;
  late final OvertimeMockDataSource overtime;
  late final DashboardMockDataSource dashboard;
  late final HolidayMockDataSource holidaySource;
  late final UserMockDataSource users;
  late final AccessMockDataSource accessSource;
}

/// DEV ONLY: the mock server's accounts and organizations.
final mockDirectoryProvider = Provider<MockDirectory>((ref) => MockDirectory());

/// DEV ONLY: the mock server's session, shared by every organization.
final mockSessionProvider = Provider<MockSession>((ref) => MockSession());

/// DEV ONLY: one organization's data, created on first use and kept for the
/// app's lifetime, so switching away and back keeps every change.
final mockTenantProvider = Provider.family<MockTenant, String>(
  (ref, organizationId) => MockTenant(
    organizationId: organizationId,
    session: ref.watch(mockSessionProvider),
    directory: ref.watch(mockDirectoryProvider),
    now: ref.watch(clockProvider),
    latency: ref.watch(mockLatencyProvider),
    sessionEvents: ref.watch(sessionEventsProvider),
  ),
);

/// DEV ONLY: the organization the app is working in. Before sign-in (and in
/// tests that skip it) that's the default sample organization.
final mockActiveTenantProvider = Provider<MockTenant>(
  (ref) => ref.watch(
    mockTenantProvider(
      ref.watch(activeOrganizationIdProvider) ??
          MockSession.defaultOrganizationId,
    ),
  ),
);
