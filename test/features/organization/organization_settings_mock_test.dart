// Each organization's own settings, departments and positions
// (2026-10-06), with the dev mock playing the backend.

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/organization/data/models/organization_models.dart';
import 'package:kc_admin_portal/shared/mock/mock_session.dart';
import 'package:kc_admin_portal/shared/mock/mock_tenant.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';

import '../../helpers/fake_auth.dart';

void main() {
  late ProviderContainer container;
  MockTenant tenant(String id) => container.read(mockTenantProvider(id));

  setUp(() => container = createTestContainer());

  EmployeeFormData form(String departmentId, String positionId) =>
      EmployeeFormData(
        ecNumber: 'KC2001',
        name: 'New Person',
        mobile: '9876543210',
        departmentId: departmentId,
        positionId: positionId,
        joiningDate: DateTime(2026, 10, 1),
        status: EmployeeStatus.active,
        schedule: WorkScheduleInput(
          effectiveFrom: DateTime(2026, 10, 1),
          startTime: const ClockTime.hm(9, 0),
          endTime: const ClockTime.hm(18, 0),
          breakMinutes: 60,
          weeklyOffDays: const [DateTime.sunday],
        ),
      );

  test('each organization has its own departments and positions', () async {
    final keshav = await tenant(
      MockSession.keshavId,
    ).organization.catalog(CatalogKind.departments);
    expect(keshav.map((d) => d.name), [
      'Accountant',
      'Graphic Designer',
      'Tailor',
    ]);
    expect(keshav.first.employeeCount, greaterThan(0));

    container.read(mockSessionProvider).start('u1', MockSession.sunriseId);
    final sunrise = await tenant(
      MockSession.sunriseId,
    ).organization.catalog(CatalogKind.departments);
    expect(sunrise.map((d) => d.name), ['Accounts', 'Design', 'Stitching']);
    expect(
      sunrise
          .map((d) => d.id)
          .toSet()
          .intersection(keshav.map((d) => d.id).toSet()),
      isEmpty,
    );
  });

  test('add, rename (shown on employees) and refuse duplicates', () async {
    final organization = tenant(MockSession.keshavId).organization;
    final added = await organization.addCatalogItem(
      CatalogKind.departments,
      ' Production ',
    );
    expect(added.name, 'Production');
    await expectLater(
      organization.addCatalogItem(CatalogKind.departments, 'production'),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors['name'],
          'name',
          contains('already exists'),
        ),
      ),
    );

    final tailor = (await organization.catalog(
      CatalogKind.departments,
    )).firstWhere((d) => d.name == 'Tailor');
    await organization.updateCatalogItem(
      CatalogKind.departments,
      tailor.id,
      name: 'Stitching',
    );
    final employees = await tenant(
      MockSession.keshavId,
    ).employeeSource.list(EmployeeQuery(departmentId: tailor.id, status: null));
    expect(employees.items, isNotEmpty);
    expect(
      employees.items.every((e) => e.department.name == 'Stitching'),
      isTrue,
    );
  });

  test('deactivated: kept by employees, not given to anyone new', () async {
    final source = tenant(MockSession.keshavId);
    final departments = await source.organization.catalog(
      CatalogKind.departments,
    );
    final positions = await source.organization.catalog(CatalogKind.positions);
    final tailor = departments.firstWhere((d) => d.name == 'Tailor');
    await source.organization.updateCatalogItem(
      CatalogKind.departments,
      tailor.id,
      isActive: false,
    );

    await expectLater(
      source.employeeSource.create(form(tailor.id, positions.first.id)),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors.keys,
          'field',
          contains('departmentId'),
        ),
      ),
    );
    // A tailor can still be edited without choosing again.
    final aTailor = (await source.employeeSource.list(
      EmployeeQuery(departmentId: tailor.id, status: null),
    )).items.first;
    final edited = await source.employeeSource.update(
      aTailor.id,
      form(
        tailor.id,
        aTailor.position.id,
      ).copyWith(ecNumber: aTailor.ecNumber, schedule: null),
    );
    expect(edited.department.id, tailor.id);
  });

  test("another organization's department is refused", () async {
    final keshav = tenant(MockSession.keshavId);
    container.read(mockSessionProvider).start('u1', MockSession.sunriseId);
    final sunriseDesign = (await tenant(
      MockSession.sunriseId,
    ).organization.catalog(CatalogKind.departments)).first;
    container.read(mockSessionProvider).start('u1', MockSession.keshavId);
    final keshavPosition = (await keshav.organization.catalog(
      CatalogKind.positions,
    )).first;
    await expectLater(
      keshav.employeeSource.create(form(sunriseDesign.id, keshavPosition.id)),
      throwsA(isA<ValidationException>()),
    );
  });

  test('the EC prefix drives suggestions and validation', () async {
    final source = tenant(MockSession.keshavId);
    expect(await source.employeeSource.nextEcNumber(), startsWith('KC'));
    final settings = await source.organization.settings();
    await source.organization.updateSettings(
      settings.copyWith(ecNumberPrefix: 'kce'),
    );
    expect((await source.organization.settings()).ecNumberPrefix, 'KCE');
    expect(await source.employeeSource.nextEcNumber(), startsWith('KCE'));
    final positions = await source.organization.catalog(CatalogKind.positions);
    final departments = await source.organization.catalog(
      CatalogKind.departments,
    );
    await expectLater(
      source.employeeSource.create(
        form(departments.first.id, positions.first.id),
      ),
      throwsA(
        isA<ValidationException>().having(
          (e) => e.fieldErrors['ecNumber'],
          'ecNumber',
          contains('KCE'),
        ),
      ),
    );
  });

  test('the late rule follows the setting', () async {
    final source = tenant(MockSession.keshavId);
    final today = DateTime(2026, 9, 28);
    int lateCount() => source.attendance
        .recordsOn(today)
        .where((r) => r.status == AttendanceDayStatus.late)
        .length;
    final before = lateCount();
    expect(before, greaterThan(0));
    final settings = await source.organization.settings();
    await source.organization.updateSettings(
      settings.copyWith(lateGraceMinutes: 120),
    );
    expect(lateCount(), lessThan(before));
  });

  test('settings: checked like the server', () async {
    final organization = tenant(MockSession.keshavId).organization;
    final settings = await organization.settings();
    await expectLater(
      organization.updateSettings(settings.copyWith(lateGraceMinutes: 500)),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(
      organization.updateSettings(settings.copyWith(ecNumberPrefix: 'K1')),
      throwsA(isA<ValidationException>()),
    );
  });

  test('a logo: PNG or JPEG by content, at most 1 MB', () async {
    final organization = tenant(MockSession.keshavId).organization;
    final png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 1, 2, 3]);
    final updated = await organization.uploadLogo(png, 'logo.png');
    expect(updated.logoUrl, startsWith('data:image/png;base64,'));
    await expectLater(
      organization.uploadLogo(Uint8List.fromList([1, 2, 3, 4]), 'fake.png'),
      throwsA(isA<ValidationException>()),
    );
    await expectLater(
      organization.uploadLogo(
        Uint8List(1024 * 1024 + 1)..setAll(0, [0xFF, 0xD8, 0xFF]),
        'big.jpg',
      ),
      throwsA(isA<ValidationException>()),
    );
    expect((await organization.removeLogo()).logoUrl, isNull);
  });

  test('anyone can read; only settings.manage can change', () async {
    // Farah Khan takes attendance at Sunrise.
    container.read(mockSessionProvider).start('u21', MockSession.sunriseId);
    final organization = tenant(MockSession.sunriseId).organization;
    expect(await organization.catalog(CatalogKind.positions), isNotEmpty);
    expect((await organization.settings()).ecNumberPrefix, 'SG');
    await expectLater(
      organization.addCatalogItem(CatalogKind.positions, 'Cutter'),
      throwsA(isA<ForbiddenException>()),
    );
    await expectLater(
      organization.updateProfile(name: 'X', timezone: 'Asia/Kolkata'),
      throwsA(isA<ForbiddenException>()),
    );
  });
}
