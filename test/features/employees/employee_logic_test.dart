import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/core/utils/date_utils.dart';
import 'package:kc_admin_portal/core/utils/format_utils.dart';
import 'package:kc_admin_portal/core/utils/validation_utils.dart';
import 'package:kc_admin_portal/features/employees/data/datasources/employee_mock_data_source.dart';
import 'package:kc_admin_portal/features/employees/data/models/employee_models.dart';
import 'package:kc_admin_portal/features/employees/domain/utils/schedule_rules.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';
import 'package:kc_admin_portal/shared/models/work_schedule_model.dart';
import '../../helpers/catalogs.dart';

EmployeeFormData _form({String ec = 'KC2001'}) => EmployeeFormData(
  ecNumber: ec,
  name: 'New Person',
  mobile: '9876543210',
  departmentId: dept('Graphic Designer').id,
  positionId: post('Graphic Designer').id,
  joiningDate: DateTime(2026, 10, 1),
  status: EmployeeStatus.active,
  schedule: ScheduleDraft.standard.toInput(DateTime(2026, 10, 1)),
);

void main() {
  group('Validators', () {
    test("EC number: the organization's prefix, then digits", () {
      expect(Validators.ecNumber('KC1001', prefix: 'KC'), isNull);
      expect(Validators.ecNumber('KC7', prefix: 'KC'), isNull);
      expect(Validators.ecNumber('', prefix: 'KC'), 'EC number is required');
      for (final bad in ['KC-1001', 'EC1001', 'kc1001', 'KC', 'KC10A1']) {
        expect(Validators.ecNumber(bad, prefix: 'KC'), isNotNull, reason: bad);
      }
      expect(
        Validators.ecNumber('EC1001', prefix: 'KC'),
        'Use KC followed by numbers, e.g. KC1001',
      );
      // Another organization's prefix.
      expect(Validators.ecNumber('SG101', prefix: 'SG'), isNull);
      expect(Validators.ecNumber('KC1001', prefix: 'SG'), isNotNull);
      // No prefix: numbers only.
      expect(Validators.ecNumber('1001', prefix: ''), isNull);
      expect(Validators.ecNumber('A1001', prefix: ''), isNotNull);
    });

    test('mobile must be 10 digits', () {
      expect(Validators.mobile('9825011234'), isNull);
      expect(Validators.mobile('982501123'), 'Enter a 10-digit mobile number');
      expect(Validators.mobile('98250 11234'), isNotNull);
    });
  });

  group('formatting', () {
    test('mobile, tenure, duration and date ranges', () {
      expect(FormatUtils.mobile('9825011234'), '+91 98250 11234');
      expect(
        FormatUtils.tenure(DateTime(2021, 1, 12), DateTime(2026, 9, 28)),
        '5 yrs 8 mos',
      );
      expect(
        FormatUtils.tenure(DateTime(2026, 10, 5), DateTime(2026, 9, 28)),
        'Joins soon',
      );
      expect(
        AppDateFormat.range(DateTime(2026, 9, 21), DateTime(2026, 9, 22)),
        '21 – 22 Sep 2026',
      );
      expect(
        AppDateFormat.range(DateTime(2026, 9, 30), DateTime(2026, 10, 2)),
        '30 Sep – 2 Oct 2026',
      );
    });
  });

  group('EmployeeMockDataSource', () {
    test('filters by department and position independently', () async {
      final source = EmployeeMockDataSource(now: () => DateTime(2026, 9, 28));
      final tailors = await source.list(
        EmployeeQuery(departmentId: dept('Tailor').id, status: null),
      );
      expect(tailors.items, isNotEmpty);
      expect(
        tailors.items.every((e) => e.department == dept('Tailor')),
        isTrue,
      );
      final mixed = await source.list(
        EmployeeQuery(
          departmentId: dept('Graphic Designer').id,
          positionId: post('Tailor').id,
          status: null,
        ),
      );
      expect(mixed.items, isNotEmpty);
      expect(
        mixed.items.every(
          (e) =>
              e.department == dept('Graphic Designer') &&
              e.position == post('Tailor'),
        ),
        isTrue,
      );
    });

    late EmployeeMockDataSource source;

    setUp(
      () => source = EmployeeMockDataSource(now: () => DateTime(2026, 9, 28)),
    );

    test('uses KC EC numbers and suggests the next one', () async {
      final page = await source.list(const EmployeeQuery(status: null));
      expect(page.items.every((e) => e.ecNumber.startsWith('KC')), isTrue);
      expect(await source.nextEcNumber(), 'KC1065');
    });

    test('searches by name or EC number and filters', () async {
      final byName = await source.list(const EmployeeQuery(search: 'aarav'));
      expect(byName.items.single.name, 'Aarav Shah');

      final byEc = await source.list(const EmployeeQuery(search: 'KC1004'));
      expect(byEc.items.single.name, 'Priya Desai');

      final inactive = await source.list(
        const EmployeeQuery(status: EmployeeStatus.inactive),
      );
      expect(
        inactive.items.every((e) => e.status == EmployeeStatus.inactive),
        isTrue,
      );
    });

    test('pages results', () async {
      final page2 = await source.list(
        const EmployeeQuery(status: null, page: 2, pageSize: 10),
      );
      expect(page2.items, hasLength(10));
      expect(page2.total, 22);
      expect(page2.counts, const EmployeeStatusCounts(active: 19, inactive: 3));
    });

    test('rejects a duplicate EC number on its field', () async {
      await expectLater(
        source.create(_form(ec: 'KC1001')),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors.keys,
            'fields',
            contains('ecNumber'),
          ),
        ),
      );
    });

    test('a new employee needs a valid first schedule', () async {
      await expectLater(
        source.create(_form().copyWith(schedule: null)),
        throwsA(isA<ValidationException>()),
      );
      await expectLater(
        source.create(
          _form().copyWith(
            schedule: ScheduleDraft.standard
                .copyWith(endTime: const ClockTime.hm(9, 0))
                .toInput(DateTime(2026, 10)),
          ),
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.fieldErrors.keys,
            'fields',
            contains('schedule.endTime'),
          ),
        ),
      );
    });

    test('schedules are versioned by date', () async {
      final created = await source.create(_form());
      // Joins on 1 Oct, after today (28 Sep): no schedule in effect yet.
      expect(created.schedule, isNull);
      final first = (await source.schedules(created.id)).single;
      expect(first.effectiveFrom, DateTime(2026, 10));
      expect(first.expectedMinutes, 480);

      final change = WorkScheduleInput(
        effectiveFrom: DateTime(2026, 11),
        startTime: const ClockTime.hm(9, 0),
        endTime: const ClockTime.hm(17, 30),
        breakMinutes: 60,
        weeklyOffDays: const [6, 7],
      );
      final added = await source.addSchedule(created.id, change);
      expect(added.expectedMinutes, 450);
      expect(added.effectiveTo, isNull);

      final versions = await source.schedules(created.id);
      expect(versions, hasLength(2));
      expect(versions.first.id, added.id, reason: 'newest first');
      expect(versions.last.effectiveTo, DateTime(2026, 10, 31));

      // Today (28 Sep) is before both versions start.
      expect((await source.getById(created.id)).schedule, isNull);

      await expectLater(
        source.addSchedule(created.id, change),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.code,
            'code',
            'SCHEDULE_OVERLAP',
          ),
        ),
      );
    });

    test('sample employees have their own schedules and history', () async {
      final aarav = await source.getById('1');
      expect(aarav.schedule?.startTime, const ClockTime.hm(9, 0));
      expect(aarav.schedule?.effectiveFrom, DateTime(2026, 4));
      expect(await source.schedules('1'), hasLength(2));
      final third = await source.getById('3');
      expect(third.schedule?.weeklyOffDays, [6, 7]);
    });

    test('creates, updates and deactivates without deleting', () async {
      final created = await source.create(_form());
      expect(created.department, dept('Graphic Designer'));

      final renamed = await source.update(
        created.id,
        _form().copyWith(name: 'Renamed Person'),
      );
      expect(renamed.name, 'Renamed Person');

      final inactive = await source.setStatus(
        created.id,
        EmployeeStatus.inactive,
      );
      expect(inactive.status, EmployeeStatus.inactive);
      expect((await source.getById(created.id)).name, 'Renamed Person');
    });
  });
}
