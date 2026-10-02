/// The company time zone, used for every date and time in the portal
/// (approved 2026-09-30): "today", punch times, schedules and the times shown
/// on screen are all company wall-clock time, whatever the device's zone.
///
/// Wall-clock values are plain (non-UTC) `DateTime`s whose fields are the
/// company's local date and time. Instants from the API are converted with
/// [fromInstant]; values sent back get [utcOffsetText].
///
/// India Standard Time has a fixed offset and no daylight saving. A company
/// in a zone with daylight saving would need a time-zone database here.
abstract final class CompanyTime {
  static const String zoneName = 'Asia/Kolkata';
  static const Duration utcOffset = Duration(hours: 5, minutes: 30);

  /// `+05:30`, as sent with times to the API.
  static String get utcOffsetText {
    final sign = utcOffset.isNegative ? '-' : '+';
    final hours = utcOffset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (utcOffset.inMinutes.abs() % Duration.minutesPerHour)
        .toString()
        .padLeft(2, '0');
    return '$sign$hours:$minutes';
  }

  /// The current company wall-clock time.
  static DateTime now() => fromInstant(DateTime.now());

  /// The company wall-clock time at [instant] (any zone, or UTC).
  static DateTime fromInstant(DateTime instant) {
    final wall = instant.toUtc().add(utcOffset);
    return DateTime(
      wall.year,
      wall.month,
      wall.day,
      wall.hour,
      wall.minute,
      wall.second,
      wall.millisecond,
    );
  }
}
