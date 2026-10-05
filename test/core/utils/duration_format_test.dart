import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/utils/duration_format.dart';

void main() {
  group('DurationFormat.full (the requirement examples)', () {
    const cases = {
      0: '0 Minutes',
      1: '1 Minute',
      45: '45 Minutes',
      60: '1 Hour',
      61: '1 Hour 1 Minute',
      90: '1 Hour 30 Minutes',
      120: '2 Hours',
      121: '2 Hours 1 Minute',
      143: '2 Hours 23 Minutes',
      150: '2 Hours 30 Minutes',
      233: '3 Hours 53 Minutes',
      2550: '42 Hours 30 Minutes',
    };
    for (final MapEntry(key: minutes, value: text) in cases.entries) {
      test('$minutes → $text', () {
        expect(DurationFormat.full(minutes), text);
      });
    }

    test('never "1 Hours" or "1 Minutes"', () {
      for (var m = 0; m < 24 * 60; m++) {
        final text = DurationFormat.full(m);
        expect(text, isNot(contains(RegExp(r'(^| )1 Hours'))));
        expect(text, isNot(contains(RegExp(r'(^| )1 Minutes'))));
        expect(text, isNot(matches(RegExp(r'^\d{3,} Minutes$'))));
      }
    });

    test('negative values keep their sign', () {
      expect(DurationFormat.full(-90), '−1 Hour 30 Minutes');
    });
  });

  group('DurationFormat.short (tight spaces only)', () {
    test('hours and minutes, no long minute counts', () {
      expect(DurationFormat.short(0), '0m');
      expect(DurationFormat.short(45), '45m');
      expect(DurationFormat.short(60), '1h');
      expect(DurationFormat.short(233), '3h 53m');
    });
  });
}
