import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/core/config/company_time.dart';
import 'package:kc_admin_portal/shared/models/json_converters.dart';

void main() {
  const converter = CompanyDateTimeConverter();

  group('instants are company wall-clock time (Asia/Kolkata)', () {
    test('whatever offset the API uses', () {
      final expected = DateTime(2026, 9, 28, 9, 35);
      expect(converter.fromJson('2026-09-28T09:35:00+05:30'), expected);
      expect(converter.fromJson('2026-09-28T04:05:00Z'), expected);
      expect(converter.fromJson('2026-09-28T00:05:00-04:00'), expected);
      expect(converter.fromJson('2026-09-28T09:35:00+05:30').isUtc, isFalse);
    });

    test('crossing midnight moves the date', () {
      expect(
        converter.fromJson('2026-09-28T20:00:00Z'),
        DateTime(2026, 9, 29, 1, 30),
      );
    });

    test('plain dates stay that date', () {
      expect(converter.fromJson('2026-09-28'), DateTime(2026, 9, 28));
    });

    test('sent with the company offset', () {
      expect(
        converter.toJson(DateTime(2026, 9, 28, 9, 35)),
        '2026-09-28T09:35:00+05:30',
      );
      // A UTC instant is converted to company time first.
      expect(
        converter.toJson(DateTime.utc(2026, 9, 28, 4, 5)),
        '2026-09-28T09:35:00+05:30',
      );
    });

    test('round trip', () {
      const text = '2026-10-02T15:00:00+05:30';
      expect(converter.toJson(converter.fromJson(text)), text);
    });
  });

  test('company "now" follows the company offset', () {
    final instant = DateTime.utc(2026, 9, 30, 20, 0);
    expect(CompanyTime.fromInstant(instant), DateTime(2026, 10, 1, 1, 30));
    expect(CompanyTime.utcOffsetText, '+05:30');
  });
}
