/// The one place durations become text. Durations are kept in whole minutes
/// everywhere (as the API sends them); only display goes through here.
///
/// - [full] for normal text: 233 → "3 Hours 53 Minutes", 60 → "1 Hour",
///   61 → "1 Hour 1 Minute", 45 → "45 Minutes".
/// - [short] only where space is tight (calendar cells, chart labels, small
///   cards and badges): 233 → "3h 53m", 60 → "1h", 45 → "45m".
abstract final class DurationFormat {
  static const int _minutesPerHour = 60;

  static String full(int minutes) {
    final (sign, hours, rest) = _split(minutes);
    final parts = [
      if (hours > 0) _unit(hours, 'Hour'),
      if (rest > 0 || hours == 0) _unit(rest, 'Minute'),
    ];
    return '$sign${parts.join(' ')}';
  }

  static String short(int minutes) {
    final (sign, hours, rest) = _split(minutes);
    final parts = [
      if (hours > 0) '${hours}h',
      if (rest > 0 || hours == 0) '${rest}m',
    ];
    return '$sign${parts.join(' ')}';
  }

  /// "1 Hour", "2 Hours"; "1 Day", "3 Days" — never "1 Hours".
  static String unit(int count, String singular) => _unit(count, singular);

  static String _unit(int count, String singular) =>
      '$count ${count == 1 ? singular : '${singular}s'}';

  static (String sign, int hours, int minutes) _split(int minutes) {
    final magnitude = minutes.abs();
    return (
      minutes < 0 ? '−' : '',
      magnitude ~/ _minutesPerHour,
      magnitude % _minutesPerHour,
    );
  }
}
