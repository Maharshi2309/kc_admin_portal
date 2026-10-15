// International mobile numbers (2026-10-13): stored as "+919825011234",
// typed with a country-code picker, and older 10-digit numbers read in the
// organization's default country.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/app/app.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/utils/phone_utils.dart';
import 'package:kc_admin_portal/core/widgets/app_search_field.dart';
import 'package:kc_admin_portal/core/widgets/app_text_field.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/presentation/widgets/profile_header_card.dart';
import 'package:kc_admin_portal/features/organization/data/datasources/organization_mock_data_source.dart';
import 'package:kc_admin_portal/features/organization/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';

import '../../helpers/fake_auth.dart';

Finder _input(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is AppTextField && w.label == label),
  matching: find.byType(TextField),
);

MockTenant _tenant(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.byType(KeshavAdminApp)),
).read(mockActiveTenantProvider);

Future<void> _tap(WidgetTester tester, Finder target) async {
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

/// Fills the add form for Ravi Patel with [mobile]; [country] picks the
/// country code first.
Future<void> _fillNewEmployee(
  WidgetTester tester, {
  required String mobile,
  String? country,
}) async {
  await tester.enterText(_input('Full name'), 'Ravi Patel');
  if (country != null) {
    await _tap(tester, find.bySemanticsLabel(RegExp('^Country code: ')));
    await tester.enterText(
      find.descendant(
        of: find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(AppSearchField),
        ),
        matching: find.byType(TextField),
      ),
      country,
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.widgetWithText(ListTile, country).first);
  }
  await tester.enterText(_input('Mobile number'), mobile);
  await tester.pump();

  Future<void> choose(String field, String option) async {
    await _tap(
      tester,
      find.byWidgetPredicate((w) => w is DropdownMenu && w.hintText == field),
    );
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  await choose('Select department', 'Tailor');
  await choose('Select position', 'Accountant');
  await _tap(tester, find.text('Select date'));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

/// The stored employee (the mock waits on a real timer, so outside the
/// test's fake time).
Future<EmployeeModel> _saved(WidgetTester tester, String name) async =>
    (await tester.runAsync(
      () => _tenant(tester).employeeSource.list(EmployeeQuery(search: name)),
    ))!.items.single;

void main() {
  group('reading numbers', () {
    test('international form, from any way of writing it', () {
      for (final raw in [
        '9825011234',
        '98250 11234',
        '098250-11234',
        '+91 98250 11234',
        '0091 9825011234',
      ]) {
        expect(PhoneUtils.toStored(raw, country: 'IN'), '+919825011234');
      }
      expect(
        PhoneUtils.toStored('(415) 555-0132', country: 'US'),
        '+14155550132',
      );
      // A "+" number keeps its own country, whatever the default.
      expect(
        PhoneUtils.toStored('+44 7400 123456', country: 'IN'),
        '+447400123456',
      );
      expect(
        PhoneUtils.toStored('07400 123456', country: 'GB'),
        '+447400123456',
      );
    });

    test('only valid mobile numbers', () {
      expect(PhoneUtils.toStored('12345', country: 'IN'), isNull);
      expect(PhoneUtils.toStored('abc', country: 'IN'), isNull);
      // A UK landline isn't a mobile.
      expect(PhoneUtils.toStored('020 7946 0958', country: 'GB'), isNull);
      expect(
        PhoneUtils.validate('12345', country: 'IN'),
        'Enter a valid mobile number for India',
      );
      expect(
        PhoneUtils.validate('+44 12', country: 'IN'),
        'Enter a valid mobile number for United Kingdom',
      );
      expect(
        PhoneUtils.validate('', country: 'IN'),
        'Mobile number is required',
      );
      expect(PhoneUtils.validate('', country: 'IN', required: false), isNull);
      expect(PhoneUtils.validate('98250 11234', country: 'IN'), isNull);
    });

    test('shown in each country\'s style; old numbers too', () {
      expect(
        PhoneUtils.format('+919825011234', country: 'US'),
        '+91 98250 11234',
      );
      // Saved before 2026-10-13, without the country code.
      expect(PhoneUtils.format('9825011234', country: 'IN'), '+91 98250 11234');
      expect(
        PhoneUtils.format('+14155550132', country: 'IN'),
        '+1 415-555-0132',
      );
      expect(PhoneUtils.format('not a number', country: 'IN'), 'not a number');
    });

    test('country and digits for editing', () {
      expect(PhoneUtils.countryOf('+14155550132', fallback: 'IN'), 'US');
      expect(PhoneUtils.countryOf('9825011234', fallback: 'IN'), 'IN');
      expect(PhoneUtils.countryOf(null, fallback: 'AE'), 'AE');
      expect(
        PhoneUtils.nationalDigits('+919825011234', country: 'IN'),
        '9825011234',
      );
      expect(
        PhoneUtils.nationalDigits('9825011234', country: 'IN'),
        '9825011234',
      );
    });

    test('every country, by name, with its code', () {
      expect(PhoneUtils.countries.length, greaterThan(200));
      final names = [for (final c in PhoneUtils.countries) c.name];
      expect(names, [...names]..sort());
      expect(PhoneUtils.countryLabel('IN'), 'India (+91)');
      expect(PhoneUtils.countryLabel('AE'), 'United Arab Emirates (+971)');
      expect(PhoneUtils.isCountry('in'), isTrue);
      expect(PhoneUtils.isCountry('ZZ'), isFalse);
    });
  });

  group('the mock server', () {
    late OrganizationMockDataSource organization;

    setUp(() {
      final container = createTestContainer();
      organization = container.read(mockActiveTenantProvider).organization;
    });

    test('keeps the default country, and refuses unknown ones', () async {
      final settings = await organization.settings();
      expect(settings.defaultCountry, 'IN');
      final saved = await organization.updateSettings(
        settings.copyWith(defaultCountry: 'ae'),
      );
      expect(saved.defaultCountry, 'AE');
      await expectLater(
        organization.updateSettings(settings.copyWith(defaultCountry: 'ZZ')),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors['defaultCountry'],
            'defaultCountry',
            'Choose a country',
          ),
        ),
      );
    });
  });

  group('the employee form', () {
    Future<void> open(WidgetTester tester, String location) async {
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: testUser),
        size: const Size(1440, 1200),
      );
      router.go(location);
      await tester.pumpAndSettle();
    }

    testWidgets("starts on the organization's country", (tester) async {
      await open(tester, '/employees/add');
      expect(find.text('+91'), findsOneWidget);
      await _fillNewEmployee(tester, mobile: '98250 99887');
      await _tap(tester, find.widgetWithText(FilledButton, 'Save employee'));

      expect((await _saved(tester, 'Ravi Patel')).mobile, '+919825099887');
      expect(
        find.descendant(
          of: find.byType(ProfileHeaderCard),
          matching: find.text('+91 98250 99887'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('another country from the picker', (tester) async {
      await open(tester, '/employees/add');
      await _fillNewEmployee(
        tester,
        country: 'United States',
        mobile: '415 555 0132',
      );
      expect(find.text('+1'), findsOneWidget);
      await _tap(tester, find.widgetWithText(FilledButton, 'Save employee'));

      expect((await _saved(tester, 'Ravi Patel')).mobile, '+14155550132');
      expect(find.text('+1 415-555-0132'), findsOneWidget);
    });

    testWidgets('an invalid number names the country', (tester) async {
      await open(tester, '/employees/add');
      await _fillNewEmployee(tester, mobile: '12345');
      await _tap(tester, find.widgetWithText(FilledButton, 'Save employee'));
      expect(
        find.text('Enter a valid mobile number for India'),
        findsOneWidget,
      );
    });

    testWidgets('editing an older number shows its code and digits', (
      tester,
    ) async {
      await open(tester, '/employees/1/edit');
      expect(find.text('+91'), findsOneWidget);
      expect(
        tester.widget<TextField>(_input('Mobile number')).controller!.text,
        '9825011234',
      );
    });

    testWidgets("a new employee starts on the setting's country", (
      tester,
    ) async {
      final router = await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: testUser),
        size: const Size(1440, 1200),
      );
      final organization = _tenant(tester).organization;
      await tester.runAsync(
        () async => organization.updateSettings(
          (await organization.settings()).copyWith(defaultCountry: 'AE'),
        ),
      );
      ProviderScope.containerOf(
        tester.element(find.byType(KeshavAdminApp)),
      ).invalidate(organizationSettingsProvider);
      router.go('/employees/add');
      await tester.pumpAndSettle();
      expect(find.text('+971'), findsOneWidget);
    });
  });
}
