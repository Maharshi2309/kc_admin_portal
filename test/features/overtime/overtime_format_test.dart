import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/features/overtime/domain/utils/overtime_format.dart';

/// 7.5 hours, the requirement's example working day.
const int _day = 450;

void main() {
  group("days of the employee's own length (the requirement examples)", () {
    test('15 h at 7.5 h a day → 2 days 0 hours', () {
      final ot = OvertimeDays.of(15 * 60, dayMinutes: _day);
      expect((ot.days, ot.hours, ot.minutes), (2, 0, 0));
      expect(ot.short, '2 days');
      expect(ot.long, '2 days');
    });

    test('10 h at 7.5 h a day → 1 day 2 hours 30 minutes', () {
      final ot = OvertimeDays.of(10 * 60, dayMinutes: _day);
      expect((ot.days, ot.hours, ot.minutes), (1, 2, 30));
      expect(ot.short, '1 day 2h 30m');
      expect(ot.long, '1 day, 2 hours and 30 minutes');
    });

    test('90 min → 0 days 1 hour 30 minutes', () {
      final ot = OvertimeDays.of(90, dayMinutes: _day);
      expect(ot.short, '0 days 1h 30m');
      expect(ot.long, '0 days, 1 hour and 30 minutes');
    });

    test('8 hours is not always a day', () {
      expect(OvertimeDays.of(480, dayMinutes: 480).short, '1 day');
      expect(OvertimeDays.of(480, dayMinutes: _day).short, '1 day 30m');
    });
  });

  test('without a schedule, hours and minutes only', () {
    final ot = OvertimeDays.of(25 * 60 + 5, dayMinutes: 0);
    expect(ot.short, '25h 5m');
    expect(ot.long, '25 hours and 5 minutes');
    expect(OvertimeDays.of(0, dayMinutes: 0).short, '0m');
  });

  test('nothing negative', () {
    expect(OvertimeDays.of(-30, dayMinutes: _day).short, '0 days');
  });
}
