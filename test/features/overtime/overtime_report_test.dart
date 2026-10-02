import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/attendance/data/datasources/attendance_mock_data_source.dart';
import 'package:kc_admin_portal/features/attendance/data/models/attendance_models.dart';
import 'package:kc_admin_portal/features/overtime/data/datasources/overtime_mock_data_source.dart';
import 'package:kc_admin_portal/features/overtime/presentation/providers/overtime_providers.dart';
import 'package:kc_admin_portal/shared/models/record_status.dart';

import '../../helpers/fake_auth.dart';
import '../../helpers/fake_dashboard.dart';

void main() {
  late AttendanceMockDataSource attendance;
  late OvertimeMockDataSource source;

  setUp(() {
    attendance = AttendanceMockDataSource(now: () => testNow);
    source = OvertimeMockDataSource(attendance: attendance);
  });

  group('overtime report (mock of DATABASE_V2 §3.6)', () {
    test('working hours: every month of the range, adding up', () async {
      final report = await source.report(
        '1',
        from: DateTime(2026, 7),
        to: DateTime(2026, 9, 30),
      );
      expect(report.months.map((m) => m.month), [
        DateTime(2026, 7),
        DateTime(2026, 8),
        DateTime(2026, 9),
      ]);
      int sum(int? Function(dynamic m) of) =>
          report.months.fold(0, (total, m) => total + (of(m) ?? 0));
      expect(sum((m) => m.minutes as int), report.totalMinutes);
      expect(sum((m) => m.expectedMinutes as int?), report.expectedMinutes);
      expect(sum((m) => m.workedMinutes as int?), report.workedMinutes);
      expect(report.workedMinutes, greaterThan(0));
      expect(report.expectedMinutes, greaterThan(0));
    });

    test('only days with overtime, adding up to the total', () async {
      final report = await source.report(
        '1',
        from: DateTime(2026, 9),
        to: DateTime(2026, 9, 30),
      );
      expect(report.days, isNotEmpty);
      expect(report.days.every((d) => d.overtimeMinutes > 0), isTrue);
      expect(
        report.days.fold(0, (sum, d) => sum + d.overtimeMinutes),
        report.totalMinutes,
      );
      expect(report.months.single.minutes, report.totalMinutes);
      // Newest first; nothing after today (28 Sep).
      expect(report.days.first.date.isAfter(report.days.last.date), isTrue);
      expect(
        report.days.every((d) => !d.date.isAfter(DateTime(2026, 9, 28))),
        isTrue,
      );
    });

    test('each day matches its attendance record', () async {
      final report = await source.report(
        '5',
        from: DateTime(2026, 9),
        to: DateTime(2026, 9, 28),
      );
      final records = {
        for (final r in attendance.recordsBetween(
          '5',
          DateTime(2026, 9),
          DateTime(2026, 9, 28),
        ))
          r.date: r,
      };
      for (final day in report.days) {
        final r = records[day.date]!;
        expect(day.overtimeMinutes, r.overtimeMinutes, reason: '${day.date}');
        expect(day.workedMinutes, r.workedMinutes);
        expect(day.dayKind, r.dayKind);
      }
    });

    test('week-off work is overtime, with the working-day basis', () async {
      // Find someone who worked a weekly off in September.
      for (final id in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']) {
        final report = await source.report(
          id,
          from: DateTime(2026, 9),
          to: DateTime(2026, 9, 28),
        );
        final offDays = report.days.where(
          (d) => d.dayKind == AttendanceDayKind.weekOffWorked,
        );
        if (offDays.isEmpty) continue;
        for (final d in offDays) {
          expect(d.expectedMinutes, 0);
          expect(d.overtimeMinutes, d.workedMinutes);
          expect(d.dayBasisMinutes, greaterThan(0));
        }
        return;
      }
      fail('no week-off work in the sample month');
    });

    test('months are totalled separately', () async {
      final report = await source.report(
        '1',
        from: DateTime(2026, 7),
        to: DateTime(2026, 9, 28),
      );
      expect(report.months.map((m) => m.month), [
        DateTime(2026, 7),
        DateTime(2026, 8),
        DateTime(2026, 9),
      ]);
      expect(
        report.months.fold(0, (sum, m) => sum + m.minutes),
        report.totalMinutes,
      );
    });

    test(
      'the day basis is the current schedule; changes are flagged',
      () async {
        // Employee 1: 09:30–18:30 (8 h) until March, 09:00–17:30 (7.5 h) since.
        final spanning = await source.report(
          '1',
          from: DateTime(2026, 3),
          to: DateTime(2026, 4, 30),
        );
        expect(spanning.scheduleChanged, isTrue);
        expect(spanning.dayBasisMinutes, 450);
        final march = spanning.days.where((d) => d.date.month == 3);
        expect(march.every((d) => d.dayBasisMinutes == 480), isTrue);

        final september = await source.report(
          '1',
          from: DateTime(2026, 9),
          to: DateTime(2026, 9, 28),
        );
        expect(september.scheduleChanged, isFalse);
      },
    );

    test('a range ending before it starts is rejected', () async {
      await expectLater(
        source.report('1', from: DateTime(2026, 9, 10), to: DateTime(2026, 9)),
        throwsA(isA<ValidationException>()),
      );
    });

    test('corrections change the report', () async {
      final before = await source.report(
        '1',
        from: DateTime(2026, 9, 25),
        to: DateTime(2026, 9, 25),
      );
      final record = attendance
          .recordsBetween('1', DateTime(2026, 9, 25), DateTime(2026, 9, 25))
          .single;
      await attendance.correct(
        record.id!,
        AttendanceCorrectionData(
          date: DateTime(2026, 9, 25),
          punchIn: DateTime(2026, 9, 25, 9),
          punchOut: DateTime(2026, 9, 25, 19, 30),
          reason: CorrectionReason.wrongTimeRecorded,
        ),
      );
      final after = await source.report(
        '1',
        from: DateTime(2026, 9, 25),
        to: DateTime(2026, 9, 25),
      );
      // 09:00–19:30 = 630 − 60 break = 570 worked; 570 − 450 = 120.
      expect(after.totalMinutes, 120);
      expect(after.totalMinutes, isNot(before.totalMinutes));
    });
  });

  group('periods and selection', () {
    final today = DateTime(2026, 9, 28);

    test('ready-made ranges', () {
      expect(OvertimePeriod.thisMonth.rangeFor(today), (
        from: DateTime(2026, 9),
        to: today,
      ));
      expect(OvertimePeriod.lastMonth.rangeFor(today), (
        from: DateTime(2026, 8),
        to: DateTime(2026, 8, 31),
      ));
      expect(
        OvertimePeriod.last3Months.rangeFor(today)!.from,
        DateTime(2026, 7),
      );
      expect(OvertimePeriod.thisYear.rangeFor(today)!.from, DateTime(2026));
      expect(OvertimePeriod.custom.rangeFor(today), isNull);
      // January: last month is December of last year.
      expect(OvertimePeriod.lastMonth.rangeFor(DateTime(2026, 1, 15)), (
        from: DateTime(2025, 12),
        to: DateTime(2025, 12, 31),
      ));
    });

    test('the selected range drives the report', () async {
      final container = createTestContainer();
      final selection = overtimeSelectionProvider('1');
      container.listen(selection, (_, _) {});
      expect(container.read(selection).period, OvertimePeriod.thisMonth);

      container.read(selection.notifier).setPeriod(OvertimePeriod.lastMonth);
      final august = await container.read(employeeOvertimeProvider('1').future);
      expect(august.from, DateTime(2026, 8));
      expect(august.to, DateTime(2026, 8, 31));

      container
          .read(selection.notifier)
          .setRange(DateTime(2026, 9, 1), DateTime(2026, 9, 15));
      expect(container.read(selection).period, OvertimePeriod.custom);
      final custom = await container.read(employeeOvertimeProvider('1').future);
      expect(custom.to, DateTime(2026, 9, 15));
    });
  });
}
