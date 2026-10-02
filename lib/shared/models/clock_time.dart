import 'package:json_annotation/json_annotation.dart';

/// A wall-clock time of day in the company time zone, e.g. a shift start.
///
/// Stored as minutes since midnight so schedule arithmetic never uses
/// floating-point hours. The API sends and receives `"HH:mm"` (24-hour).
class ClockTime implements Comparable<ClockTime> {
  const ClockTime(this.minutes)
    : assert(minutes >= 0 && minutes < Duration.minutesPerDay);

  const ClockTime.hm(int hour, int minute)
    : this(hour * Duration.minutesPerHour + minute);

  /// Parses `"HH:mm"`; throws a [FormatException] otherwise.
  factory ClockTime.parse(String text) {
    final match = _pattern.firstMatch(text.trim());
    if (match == null) throw FormatException('Expected HH:mm', text);
    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) throw FormatException('Invalid time', text);
    return ClockTime.hm(hour, minute);
  }

  static final RegExp _pattern = RegExp(r'^(\d{1,2}):(\d{2})$');

  /// Minutes since midnight, 0–1439.
  final int minutes;

  int get hour => minutes ~/ Duration.minutesPerHour;
  int get minute => minutes % Duration.minutesPerHour;

  /// `"09:30"`, as the API expects.
  String toApi() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(ClockTime other) => minutes.compareTo(other.minutes);

  bool operator <(ClockTime other) => minutes < other.minutes;
  bool operator >(ClockTime other) => minutes > other.minutes;

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.minutes == minutes;

  @override
  int get hashCode => minutes.hashCode;

  @override
  String toString() => toApi();
}

/// JSON `"HH:mm"` ↔ [ClockTime]. Apply per field:
/// `@ClockTimeConverter() required ClockTime startTime`.
class ClockTimeConverter implements JsonConverter<ClockTime, String> {
  const ClockTimeConverter();

  @override
  ClockTime fromJson(String json) => ClockTime.parse(json);

  @override
  String toJson(ClockTime object) => object.toApi();
}
