// The organization's time zone (2026-10-13): "today" and every time shown
// follow the active organization's zone, with daylight saving.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:kc_admin_portal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/auth_controller.dart';
import 'package:kc_admin_portal/features/auth/presentation/providers/organization_providers.dart';
import 'package:kc_admin_portal/features/users/presentation/providers/user_providers.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';
import 'package:kc_admin_portal/shared/models/organization_model.dart';
import 'package:kc_admin_portal/shared/models/time_zones.dart';

import '../../helpers/fake_auth.dart';

const _newYork = 'America/New_York';
final _summer = DateTime.utc(2026, 7);
final _winter = DateTime.utc(2026, 1, 15);

OrganizationModel _organization(String? zone) => OrganizationModel(
  id: MockSession.keshavId,
  name: 'Keshav Clothing',
  timezone: zone,
);

void main() {
  setUp(() => CompanyTime.use(null));
  tearDown(() => CompanyTime.use(null));

  group('organization wall-clock time', () {
    test('India by default, and for an unknown zone', () {
      expect(CompanyTime.zoneName, 'Asia/Kolkata');
      CompanyTime.use('Mars/Olympus');
      expect(CompanyTime.zoneName, 'Asia/Kolkata');
      expect(
        CompanyTime.fromInstant(DateTime.utc(2026, 9, 30, 20)),
        DateTime(2026, 10, 1, 1, 30),
      );
    });

    test('follows daylight saving', () {
      CompanyTime.use(_newYork);
      // 12:00 UTC is 08:00 in summer (UTC−4) and 07:00 in winter (UTC−5).
      expect(
        CompanyTime.fromInstant(DateTime.utc(2026, 7, 1, 12)),
        DateTime(2026, 7, 1, 8),
      );
      expect(
        CompanyTime.fromInstant(DateTime.utc(2026, 1, 15, 12)),
        DateTime(2026, 1, 15, 7),
      );
      expect(CompanyTime.offsetTextAt(DateTime(2026, 7, 1, 9)), '-04:00');
      expect(CompanyTime.offsetTextAt(DateTime(2026, 1, 15, 9)), '-05:00');
    });

    test('times sent to the API carry the offset of their own date', () {
      CompanyTime.use(_newYork);
      const converter = CompanyDateTimeConverter();
      expect(
        converter.toJson(DateTime(2026, 7, 1, 9, 30)),
        '2026-07-01T09:30:00-04:00',
      );
      expect(
        converter.toJson(DateTime(2026, 1, 15, 9, 30)),
        '2026-01-15T09:30:00-05:00',
      );
      const text = '2026-11-02T08:15:00-05:00';
      expect(converter.toJson(converter.fromJson(text)), text);
    });

    test('a half-hour zone without daylight saving', () {
      CompanyTime.use('Asia/Kathmandu');
      expect(CompanyTime.offsetTextAt(DateTime(2026, 7)), '+05:45');
    });
  });

  group('choosing a zone', () {
    test('the whole world, without old duplicate names', () {
      final ids = timeZoneOptions(at: _summer).map((z) => z.id).toSet();
      expect(ids.length, greaterThan(350));
      expect(ids, containsAll(['Asia/Kolkata', 'Europe/Berlin', _newYork]));
      expect(ids, isNot(contains('Asia/Calcutta')));
      expect(ids, isNot(contains('Etc/GMT+5')));
      // A zone saved elsewhere under an old name still shows.
      expect(
        timeZoneOptions(include: 'Asia/Calcutta').map((z) => z.id),
        contains('Asia/Calcutta'),
      );
    });

    test('west to east', () {
      final offsets = [for (final z in timeZoneOptions(at: _summer)) z.offset];
      final sorted = [...offsets]..sort();
      expect(offsets, sorted);
    });

    test('labels name the place and the offset in force', () {
      expect(
        timeZoneLabel('Asia/Kolkata', at: _summer),
        'India · Kolkata, Asia · UTC+5:30',
      );
      expect(
        timeZoneLabel(_newYork, at: _summer),
        'Eastern Time (US) · New York, America · UTC−4',
      );
      expect(timeZoneLabel(_newYork, at: _winter), endsWith('UTC−5'));
      expect(
        timeZoneLabel('America/Argentina/Buenos_Aires', at: _summer),
        'Buenos Aires, Argentina · UTC−3',
      );
      expect(timeZoneLabel('Europe/London', at: _winter), endsWith('· UTC'));
      expect(timeZoneShortName('Asia/Kolkata'), 'India');
      expect(timeZoneShortName('Europe/Berlin'), 'Berlin');
    });

    test("suggested from the device's offset", () {
      expect(
        suggestedTimeZone(const Duration(hours: 5, minutes: 30)),
        'Asia/Kolkata',
      );
      expect(
        suggestedTimeZone(const Duration(hours: -4), at: _summer),
        _newYork,
      );
      expect(
        suggestedTimeZone(const Duration(hours: -5), at: _winter),
        _newYork,
      );
      // Only rare zones have it: one of them.
      expect(
        suggestedTimeZone(const Duration(hours: 8, minutes: 45), at: _summer),
        'Australia/Eucla',
      );
    });
  });

  group('the active organization', () {
    late ProviderContainer container;
    late FakeAuthRepository auth;

    Future<void> start(String? zone) async {
      auth = FakeAuthRepository(
        sessionUser: testUser.copyWith(organization: _organization(zone)),
      );
      container = createTestContainer(
        overrides: [authRepositoryProvider.overrideWithValue(auth)],
      );
      await container.read(authControllerProvider.future);
    }

    test('its zone is applied', () async {
      await start(_newYork);
      expect(container.read(activeTimeZoneProvider), _newYork);
      expect(container.read(activeOrganizationIdProvider), isNotNull);
      expect(CompanyTime.zoneName, _newYork);
    });

    test('no zone (an older server): India', () async {
      await start(null);
      expect(container.read(activeTimeZoneProvider), 'Asia/Kolkata');
    });

    test('a new zone reloads its data, as loaded times are stale', () async {
      await start('Asia/Kolkata');
      container.listen(userQueryProvider, (_, _) {});
      final scope = container.read(activeOrganizationScopeProvider);
      container.read(userQueryProvider.notifier).applySearch('nisha');
      expect(container.read(userQueryProvider).search, 'nisha');

      auth.sessionUser = auth.sessionUser!.copyWith(
        organization: _organization(_newYork),
      );
      await container.read(authControllerProvider.notifier).refresh();

      // Reading data reads the scope first, which applies the zone.
      expect(container.read(activeOrganizationScopeProvider), isNot(scope));
      expect(CompanyTime.zoneName, _newYork);
      expect(
        container.read(activeOrganizationScopeProvider).organizationId,
        scope.organizationId,
      );
      // Everything starts afresh (filters too).
      expect(container.read(userQueryProvider).search, isEmpty);
    });
  });

  group('the note when the device is elsewhere', () {
    final user = testUser.copyWith(organization: _organization(_newYork));

    testWidgets('in the header', (tester) async {
      await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: user),
        deviceUtcOffset: () => const Duration(hours: 5, minutes: 30),
      );
      expect(
        find.textContaining('Times in Eastern Time (US) (UTC−'),
        findsOneWidget,
      );
      expect(
        find.byTooltip(
          "Dates and times follow the organization's time zone. "
          'Your device is on UTC+5:30.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('on a phone', (tester) async {
      await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: user),
        size: const Size(390, 844),
        deviceUtcOffset: () => const Duration(hours: 5, minutes: 30),
      );
      expect(find.textContaining('Times in Eastern Time (US)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('not when the device is on the same clock', (tester) async {
      await pumpFullApp(
        tester,
        repository: FakeAuthRepository(sessionUser: user),
      );
      expect(find.textContaining('Times in'), findsNothing);
    });
  });
}
