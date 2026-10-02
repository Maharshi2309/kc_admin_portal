import 'package:flutter_test/flutter_test.dart';
import 'package:kc_admin_portal/shared/models/clock_time.dart';

void main() {
  test('parses and prints the API format', () {
    final time = ClockTime.parse('09:05');
    expect(time.minutes, 9 * 60 + 5);
    expect(time.hour, 9);
    expect(time.minute, 5);
    expect(time.toApi(), '09:05');
    expect(ClockTime.parse('7:30').toApi(), '07:30');
    expect(ClockTime.parse('23:59').minutes, 1439);
  });

  test('rejects anything that is not a 24-hour HH:mm', () {
    for (final text in ['24:00', '12:60', '9', '09:5', '9am', '', '-1:00']) {
      expect(() => ClockTime.parse(text), throwsFormatException, reason: text);
    }
  });

  test('compares and equals by minutes', () {
    const start = ClockTime.hm(9, 0);
    const end = ClockTime.hm(17, 30);
    expect(start < end, isTrue);
    expect(end > start, isTrue);
    expect(end.minutes - start.minutes, 510);
    expect(ClockTime.parse('09:00'), start);
    expect({start, ClockTime.parse('09:00')}, hasLength(1));
  });

  test('JSON converter round-trips', () {
    const converter = ClockTimeConverter();
    expect(converter.toJson(converter.fromJson('13:00')), '13:00');
  });
}
