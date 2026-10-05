import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_dashboard.dart';

void main() {
  late AttendanceMockDataSource source;
  final today = DateTime(2026, 9, 28);

  setUp(() => source = AttendanceMockDataSource(now: () => testNow));

  Future<AttendanceDayModel> day([
    AttendanceFilter filter = AttendanceFilter.all,
  ]) => source.day(AttendanceQuery(date: today, filter: filter), 1);

  test('summarises the day and lists absentees first', () async {
    final all = await day();
    expect(all.summary.totalEmployees, 19);
    expect(all.summary.absent, 3);
    expect(all.summary.late, 2);
    expect(all.summary.onLeave, 2);
    expect(all.summary.present, 12); // includes half days
    expect(all.items.first.status, AttendanceDayStatus.absent);
    expect(all.items.first.id, isNull); // nothing recorded yet
  });

  test('filters by status', () async {
    final late = await day(AttendanceFilter.late);
    expect(
      late.items.every((r) => r.status == AttendanceDayStatus.late),
      isTrue,
    );
    // Minutes late count from the employee's own start time.
    expect(late.items.first.lateMinutes, 38);
  });

  group("each employee's own schedule", () {
    test('rows carry the schedule, expected and overtime minutes', () async {
      final rows = (await day()).items;
      // Employee 1 works 09:00–17:30 with an hour's break (7h 30m).
      final aarav = rows.firstWhere((r) => r.employee.id == '1');
      expect(aarav.schedule?.startTime.toApi(), '09:00');
      expect(aarav.expectedMinutes, 450);
      expect(aarav.dayKind, AttendanceDayKind.working);
      // Employee 3 works 10:00–18:30 with 30 minutes' break (8h).
      final rohan = rows.firstWhere((r) => r.employee.id == '3');
      expect(rohan.schedule?.startTime.toApi(), '10:00');
      expect(rohan.expectedMinutes, 480);
    });

    test(
      'a finished day: worked less the break, overtime above expected',
      () async {
        final friday = await source.day(
          AttendanceQuery(date: DateTime(2026, 9, 25)),
          1,
        );
        for (final r in friday.items.where((r) => r.punchOut != null)) {
          final worked = r.workedMinutes!;
          expect(
            r.overtimeMinutes,
            worked > r.expectedMinutes! ? worked - r.expectedMinutes! : 0,
            reason: r.employee.name,
          );
        }
      },
    );

    test('weekly offs follow the schedule: some have Saturday off', () async {
      final saturday = await source.day(
        AttendanceQuery(date: DateTime(2026, 9, 26)),
        1,
      );
      final byId = {for (final r in saturday.items) r.employee.id: r};
      // Employee 3 has Saturday and Sunday off; employee 1 only Sunday.
      expect(byId['3']!.status, isNot(AttendanceDayStatus.absent));
      expect(byId['3']!.expectedMinutes, 0);
      expect(byId['1']!.expectedMinutes, 450);
    });

    test('work on a weekly off counts fully as overtime', () async {
      final sunday = DateTime(2026, 9, 27);
      final rows = (await source.day(AttendanceQuery(date: sunday), 1)).items;
      final worked = rows.where(
        (r) => r.dayKind == AttendanceDayKind.weekOffWorked,
      );
      expect(worked, isNotEmpty);
      for (final r in worked) {
        expect(r.expectedMinutes, 0);
        expect(r.overtimeMinutes, r.workedMinutes);
        expect(r.status, AttendanceDayStatus.present);
      }
      final off = rows.where((r) => r.punchIn == null);
      expect(
        off.every((r) => r.status == AttendanceDayStatus.weeklyOff),
        isTrue,
      );
    });
  });

  test(
    'punch in after the grace time is late, decided by the "server"',
    () async {
      final rohan = (await day(AttendanceFilter.absent)).items.first.employee;
      final record = await source.punchIn(rohan.id);

      expect(record.punchIn, testNow);
      expect(record.status, AttendanceDayStatus.late); // 14:30
      await expectLater(
        source.punchIn(rohan.id),
        throwsA(isA<ValidationException>()),
      );

      final out = await source.punchOut(rohan.id);
      expect(out.punchOut, testNow);
    },
  );

  test('punch in all clears the not-punched-in list', () async {
    expect(await source.punchInAll(today), 3);
    expect((await day()).summary.notPunchedIn, 0);
  });

  test('corrections recompute status and reject impossible times', () async {
    final record = (await day(AttendanceFilter.late)).items.first;

    await expectLater(
      source.correct(
        record.id!,
        AttendanceCorrectionData(
          date: today,
          punchIn: DateTime(2026, 9, 28, 10),
          punchOut: DateTime(2026, 9, 28, 9),
          reason: CorrectionReason.deviceIssue,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );

    final corrected = await source.correct(
      record.id!,
      AttendanceCorrectionData(
        date: today,
        punchIn: DateTime(2026, 9, 28, 9, 35),
        reason: CorrectionReason.deviceIssue,
      ),
    );
    expect(corrected.status, AttendanceDayStatus.present);
    expect(corrected.correctedBy, 'Admin');
  });

  test('adds a missing record once, then asks to correct instead', () async {
    final absent = (await day(AttendanceFilter.absent)).items.first;
    final data = AttendanceCorrectionData(
      employeeId: absent.employee.id,
      date: today,
      punchIn: DateTime(2026, 9, 28, 9, 20),
      reason: CorrectionReason.forgotToPunch,
    );

    final created = await source.create(data);
    expect(created.id, isNotNull);
    expect(created.status, AttendanceDayStatus.present);
    await expectLater(source.create(data), throwsA(isA<ValidationException>()));
  });

  test('rejects future dates', () async {
    await expectLater(
      source.day(AttendanceQuery(date: DateTime(2026, 9, 29)), 1),
      throwsA(isA<ValidationException>()),
    );
  });
}
