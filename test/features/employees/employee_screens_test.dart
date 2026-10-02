import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/widgets/app_status_badge.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/providers/employee_providers.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/profile_header_card.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/work_schedule_card.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

/// Mock store whose list call can be made to fail.
class _FlakyEmployees extends EmployeeMockDataSource {
  _FlakyEmployees() : super(now: () => testNow);

  bool fail = true;

  @override
  Future<EmployeeListModel> list(EmployeeQuery query) {
    if (fail) throw const NetworkException();
    return super.list(query);
  }
}

Future<GoRouter> _open(
  WidgetTester tester,
  String location, {
  Size size = const Size(1440, 1000),
}) async {
  final router = await pumpFullApp(
    tester,
    repository: FakeAuthRepository(sessionUser: testUser),
    size: size,
  );
  router.go(location);
  await tester.pumpAndSettle();
  return router;
}

/// The text input of the form field labelled [label].
Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

Future<void> _enter(WidgetTester tester, String label, String text) =>
    tester.enterText(_input(label), text);

TextField _textField(WidgetTester tester, String label) =>
    tester.widget<TextField>(_input(label));

void main() {
  group('employee list', () {
    testWidgets('shows active employees with pagination', (tester) async {
      await _open(tester, '/employees');

      expect(find.text('Aarav Shah'), findsOneWidget);
      expect(find.text('KC1001'), findsOneWidget);
      expect(find.text('Showing 1–10 of 19'), findsOneWidget);
      expect(find.text('19 active · 3 inactive'), findsOneWidget);
      // Inactive employees are hidden by the default "Active" filter.
      expect(find.text('Tanvi Oza'), findsNothing);
    });

    testWidgets('search filters after a short pause', (tester) async {
      await _open(tester, '/employees');
      await tester.enterText(
        find.widgetWithText(TextField, 'Name or EC number'),
        'kavya',
      );
      await tester.pump(EmployeeQueryNotifier.searchDebounce);
      await tester.pumpAndSettle();

      expect(find.text('Kavya Mehta'), findsOneWidget);
      expect(find.text('Aarav Shah'), findsNothing);
    });

    testWidgets('empty results offer to clear filters', (tester) async {
      await _open(tester, '/employees?search=nobody-matches');

      expect(find.text('No employees match these filters'), findsOneWidget);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Clear filters'));
      await tester.pumpAndSettle();
      expect(find.text('Aarav Shah'), findsOneWidget);
    });

    testWidgets('next page shows the following employees', (tester) async {
      await _open(tester, '/employees');
      await tester.ensureVisible(find.byTooltip('Next page'));
      await tester.tap(find.byTooltip('Next page'));
      await tester.pumpAndSettle();
      expect(find.text('Showing 11–19 of 19'), findsOneWidget);
    });

    testWidgets('deactivating asks for confirmation first', (tester) async {
      await _open(tester, '/employees');
      await tester.tap(find.byTooltip('More actions for Aarav Shah'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Deactivate Aarav Shah?'), findsOneWidget);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Deactivate'));
      await tester.pumpAndSettle();

      expect(find.text('Aarav Shah deactivated'), findsOneWidget);
      // No longer listed under "Active".
      expect(find.text('KC1001'), findsNothing);
    });

    testWidgets('a failed load offers a retry', (tester) async {
      final flaky = _FlakyEmployees();
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: testUser),
        overrides: [employeeRemoteDataSourceProvider.overrideWithValue(flaky)],
      );
      router.go('/employees');
      await tester.pumpAndSettle();
      expect(find.text(const NetworkException().message), findsOneWidget);

      flaky.fail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('Aarav Shah'), findsOneWidget);
    });
  });

  group('add / edit employee', () {
    testWidgets('suggests the next EC number', (tester) async {
      await _open(tester, '/employees/add');
      expect(_textField(tester, 'EC number').controller!.text, 'KC1065');
    });

    testWidgets('suggests the email from the name until it is edited', (
      tester,
    ) async {
      await _open(tester, '/employees/add');
      String email() => _textField(tester, 'Email address').controller!.text;

      await _enter(tester, 'Full name', 'Ravi Patel');
      await tester.pump();
      expect(email(), 'ravi.patel@example.com');
      expect(find.text('Suggested'), findsOneWidget);

      await _enter(tester, 'Email address', 'ravi@example.com');
      await _enter(tester, 'Full name', 'Ravi Kumar');
      await tester.pump();
      expect(email(), 'ravi@example.com');
      expect(find.text('Suggested'), findsNothing);
    });

    testWidgets('adding an employee saves and opens the new profile', (
      tester,
    ) async {
      final router = await _open(tester, '/employees/add');

      await _enter(tester, 'Full name', 'Ravi Patel');
      await _enter(tester, 'Mobile number', '9876543210');
      await tester.pump();

      Future<void> choose(String field, String option) async {
        final dropdown = find.byWidgetPredicate(
          (w) => w is DropdownMenu<String> && w.hintText == field,
        );
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text(option).last);
        await tester.pumpAndSettle();
      }

      await choose('Select department', 'IT');
      await choose('Select designation', 'QA engineer');

      final date = find.text('Select date');
      await tester.ensureVisible(date);
      await tester.pumpAndSettle();
      await tester.tap(date);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Save employee'));
      await tester.pumpAndSettle();

      expect(currentLocation(router), matches(RegExp(r'^/employees/[^/]+$')));
      expect(currentLocation(router), isNot('/employees/add'));
      expect(
        find.widgetWithText(ProfileHeaderCard, 'Ravi Patel'),
        findsOneWidget,
      );
      expect(find.text('KC1065'), findsWidgets);
      expect(find.text('ravi.patel@example.com'), findsWidgets);
      expect(find.text('Ravi Patel added'), findsOneWidget);
      // The standard schedule, from the joining date (today).
      expect(find.text('09:30 – 18:30'), findsOneWidget);
      expect(find.text('Since 28 Sep 2026'), findsOneWidget);
    });

    testWidgets('validates the EC format and required fields', (tester) async {
      await _open(tester, '/employees/add');
      await _enter(tester, 'EC number', 'EC1001');
      await tester.tap(find.widgetWithText(FilledButton, 'Save employee'));
      await tester.pumpAndSettle();

      expect(
        find.text('Use KC followed by numbers, e.g. KC1001'),
        findsOneWidget,
      );
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Department is required'), findsOneWidget);
    });

    testWidgets('a duplicate EC number is shown on its field', (tester) async {
      final router = await _open(tester, '/employees/1/edit');
      await _enter(tester, 'EC number', 'KC1004'); // Priya Desai's number
      await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
      await tester.pumpAndSettle();

      expect(find.text('This EC number is already in use'), findsOneWidget);
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        '/employees/1/edit',
      );
    });

    testWidgets('editing shows the saved department and designation', (
      tester,
    ) async {
      await _open(tester, '/employees/1/edit');
      String shown(String hint) => tester
          .widget<TextField>(
            find.descendant(
              of: find.byWidgetPredicate(
                (w) => w is DropdownMenu<String> && w.hintText == hint,
              ),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text;
      expect(shown('Select department'), 'IT');
      expect(shown('Select designation'), 'Senior developer');
    });

    testWidgets('saving an edit returns to the updated profile', (
      tester,
    ) async {
      final router = await _open(tester, '/employees/1/edit');
      await _enter(tester, 'Full name', 'Aarav K Shah');
      await tester.tap(find.widgetWithText(FilledButton, 'Save changes'));
      await tester.pumpAndSettle();

      expect(currentLocation(router), '/employees/1');
      expect(
        find.widgetWithText(ProfileHeaderCard, 'Aarav K Shah'),
        findsOneWidget,
      );
    });
  });

  group('profile', () {
    testWidgets('shows details, balances, calendar and history', (
      tester,
    ) async {
      await _open(tester, '/employees/1');

      expect(find.text('Aarav Shah'), findsWidgets);
      expect(find.text('+91 98250 11234'), findsOneWidget);
      expect(find.text('12 Jan 2021 · 5 yrs 8 mos'), findsOneWidget);
      expect(find.text('Casual leave'), findsOneWidget);
      expect(find.text('September 2026'), findsOneWidget);
      expect(find.text('Weekly off'), findsWidgets); // schedule + legend
      expect(find.text('21 – 22 Sep 2026'), findsOneWidget);

      // Working schedule: today's version and the earlier one.
      expect(find.text('Working schedule'), findsOneWidget);
      expect(find.text('Since 1 Apr 2026'), findsOneWidget);
      expect(find.text('09:00 – 17:30'), findsOneWidget);
      expect(find.text('1 h (13:00–14:00)'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(WorkScheduleCard),
          matching: find.text('7h 30m'),
        ),
        findsOneWidget,
      );
      expect(find.text('EARLIER SCHEDULES'), findsOneWidget);
    });

    testWidgets('changing the schedule adds a version from a date', (
      tester,
    ) async {
      final router = await _open(tester, '/employees/1');
      await tester.tap(find.widgetWithText(TextButton, 'Change'));
      await tester.pumpAndSettle();
      expect(currentLocation(router), '/employees/1/schedule');
      expect(find.text('Change schedule'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Save schedule'));
      await tester.pumpAndSettle();

      expect(currentLocation(router), '/employees/1');
      expect(
        find.text('New schedule for Aarav Shah from 28 Sep 2026'),
        findsOneWidget,
      );
      expect(find.text('Since 28 Sep 2026'), findsOneWidget);
    });

    testWidgets('the calendar looks back and ahead, and returns', (
      tester,
    ) async {
      await _open(tester, '/employees/1');
      await tester.ensureVisible(find.byTooltip('Previous month'));
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('August 2026'), findsOneWidget);
      // The attendance log follows the calendar's month.
      expect(
        find.textContaining('Attendance log · August 2026'),
        findsOneWidget,
      );

      await tester.tap(find.text('Back to this month'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
      // Ahead: Gandhi Jayanti is shown as a holiday.
      expect(
        find.bySemanticsLabel(RegExp(r'^Fri, 2 Oct 2026 · Gandhi Jayanti')),
        findsOneWidget,
      );
    });

    testWidgets('deactivate, then reactivate', (tester) async {
      await _open(tester, '/employees/1');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Deactivate'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.widgetWithText(OutlinedButton, 'Deactivate'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppStatusBadge, 'Inactive'), findsOneWidget);
      await tester.tap(find.widgetWithText(OutlinedButton, 'Reactivate'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppStatusBadge, 'Active'), findsOneWidget);
    });
  });

  group('no overflow', () {
    const sizes = {
      'smallest phone': Size(320, 640),
      'tablet': Size(820, 1180),
      'large desktop': Size(1920, 1080),
    };
    for (final size in sizes.entries) {
      for (final location in ['/employees', '/employees/add', '/employees/1']) {
        testWidgets('$location on ${size.key}', (tester) async {
          await _open(tester, location, size: size.value);
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -3000),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
