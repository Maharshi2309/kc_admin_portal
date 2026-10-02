import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/app/shell/app_sidebar.dart';
import 'package:kc_admin_portal/core/network/session_events.dart';
import 'package:kc_admin_portal/core/permissions/app_permission.dart';
import 'package:kc_admin_portal/features/auth/data/models/user_model.dart';

import '../helpers/fake_auth.dart';

typedef _P = AppPermission;

UserModel _as(Set<AppPermission> permissions) =>
    testUser.copyWith(permissions: [for (final p in permissions) p.key]);

final _supervisor = _as(const {
  _P.dashboardView,
  _P.employeeView,
  _P.attendanceView,
  _P.attendancePunch,
  _P.attendanceCorrect,
  _P.leaveView,
  _P.calendarView,
  _P.holidayView,
});

Future<(GoRouter, FakeAuthRepository)> _open(
  WidgetTester tester,
  UserModel user,
  String location, {
  Size size = const Size(1440, 1000),
}) async {
  final repository = FakeAuthRepository(sessionUser: user);
  final router = await pumpFullApp(tester, repository: repository, size: size);
  router.go(location);
  await tester.pumpAndSettle();
  return (router, repository);
}

Finder _nav(String label) =>
    find.descendant(of: find.byType(AppSidebar), matching: find.text(label));

void main() {
  testWidgets('navigation shows only the sections the role may open', (
    tester,
  ) async {
    await _open(tester, _supervisor, '/dashboard');
    for (final label in ['Dashboard', 'Employees', 'Attendance', 'Leaves']) {
      expect(_nav(label), findsOneWidget, reason: label);
    }
    expect(_nav('Holidays'), findsOneWidget);
    expect(_nav('Access control'), findsNothing);
  });

  testWidgets('holiday actions the role cannot use are hidden', (tester) async {
    await _open(tester, _supervisor, '/holidays');
    expect(find.text('Republic Day'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Add holiday'), findsNothing);
    expect(find.byTooltip('Edit Republic Day'), findsNothing);
    expect(find.byTooltip('Delete Republic Day'), findsNothing);
  });

  testWidgets('leave actions the role cannot use are hidden', (tester) async {
    await _open(tester, _supervisor, '/leave');
    expect(find.text('Add leave'), findsNothing);
    expect(find.text('Approve'), findsNothing);
  });

  testWidgets('dashboard shortcuts follow the role', (tester) async {
    await _open(tester, _supervisor, '/dashboard');
    expect(find.text('Add employee'), findsNothing);
    expect(find.text('Add leave'), findsNothing);
    expect(find.text('Mark attendance'), findsOneWidget);
  });

  testWidgets('a profile shows only what the role may see', (tester) async {
    await _open(tester, _as(const {_P.employeeView}), '/employees/1');
    expect(find.text('Leave history'), findsOneWidget);
    expect(find.textContaining('Attendance log'), findsNothing);
    expect(find.text('Edit'), findsNothing);
    expect(find.text('Deactivate'), findsNothing);
    expect(find.text('Change'), findsNothing); // schedule
    // Leaving the page must not touch the unused tabs (regression).
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a link to a page the role may not open shows "No access"', (
    tester,
  ) async {
    final (router, repository) = await _open(
      tester,
      _supervisor,
      '/holidays/add',
    );
    expect(currentLocation(router), '/no-access?from=%2Fholidays%2Fadd');
    expect(find.text('You don’t have access to this page'), findsOneWidget);
    expect(
      find.textContaining('Your permissions don’t include it'),
      findsOneWidget,
    );

    await tester.tap(find.text('Go to Dashboard'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), '/dashboard');
    expect(repository.signOutCalls, 0);
  });

  testWidgets('without the dashboard, people land on their first section', (
    tester,
  ) async {
    final (router, _) = await _open(
      tester,
      _as(const {_P.holidayView, _P.holidayCreate}),
      '/dashboard',
    );
    expect(currentLocation(router), '/holidays');
    // No employee search without `employee.view`.
    expect(
      find.widgetWithText(TextField, 'Search employee by name or EC number'),
      findsNothing,
    );
  });

  testWidgets('a user with no permissions can only sign out', (tester) async {
    final (router, repository) = await _open(
      tester,
      _as(const {}),
      '/employees',
    );
    expect(currentLocation(router), startsWith('/no-access'));
    expect(find.text('You have no access yet'), findsOneWidget);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(currentLocation(router), startsWith('/login'));
    expect(repository.signOutCalls, 1);
  });

  testWidgets('Access control needs Manage users and permissions', (
    tester,
  ) async {
    final (router, _) = await _open(
      tester,
      _as(const {_P.permissionManage}),
      '/access-control/u4',
    );
    expect(currentLocation(router), '/access-control/u4');
    expect(find.text('Kunal Desai'), findsWidgets);
  });

  testWidgets('without it, Access control is "No access"', (tester) async {
    final (router, _) = await _open(tester, _supervisor, '/access-control');
    expect(currentLocation(router), startsWith('/no-access'));
  });

  testWidgets('permissions are reloaded after a 403', (tester) async {
    final (router, repository) = await _open(tester, testUser, '/holidays');
    expect(_nav('Access control'), findsOneWidget);

    // An admin takes Holidays and Access control away meanwhile.
    repository.sessionUser = _supervisor.copyWith(
      permissions: [
        for (final p in _supervisor.permissions)
          if (p != _P.holidayView.key) p,
      ],
    );
    ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    ).read(sessionEventsProvider).notifyForbidden();
    await tester.pumpAndSettle();

    expect(currentLocation(router), startsWith('/no-access'));
    await tester.tap(find.text('Go to Dashboard'));
    await tester.pumpAndSettle();
    expect(_nav('Holidays'), findsNothing);
    expect(_nav('Access control'), findsNothing);
  });
}
