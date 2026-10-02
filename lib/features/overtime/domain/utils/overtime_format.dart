/// Overtime shown as working days of the employee's own length
/// (approved 2026-09-30): never "8 hours = 1 day".
///
/// Everything is whole minutes, so there is no rounding: 600 minutes against
/// a 450-minute day is exactly 1 day and 150 minutes.
class OvertimeDays {
  const OvertimeDays._(this.days, this.hours, this.minutes, this.hasDayLength);

  /// Splits [totalMinutes] into days of [dayMinutes], then hours and minutes.
  /// Without a day length (no schedule), everything stays hours and minutes.
  factory OvertimeDays.of(int totalMinutes, {required int dayMinutes}) {
    final total = totalMinutes < 0 ? 0 : totalMinutes;
    final days = dayMinutes > 0 ? total ~/ dayMinutes : 0;
    final rest = dayMinutes > 0 ? total % dayMinutes : total;
    return OvertimeDays._(
      days,
      rest ~/ Duration.minutesPerHour,
      rest % Duration.minutesPerHour,
      dayMinutes > 0,
    );
  }

  final int days;
  final int hours;
  final int minutes;

  /// False without a schedule: then only hours and minutes are shown.
  final bool hasDayLength;

  /// "2 days", "1 day 2h 30m", "0 days 1h 30m"; "25h" without a day
  /// length.
  String get short {
    final time = [if (hours > 0) '${hours}h', if (minutes > 0) '${minutes}m'];
    if (!hasDayLength) return time.isEmpty ? '0m' : time.join(' ');
    return [days == 1 ? '1 day' : '$days days', ...time].join(' ');
  }

  /// For screen readers: "1 day, 2 hours and 30 minutes".
  String get long {
    String unit(int n, String one) => n == 1 ? '1 $one' : '$n ${one}s';
    final time = [
      if (hours > 0) unit(hours, 'hour'),
      if (minutes > 0) unit(minutes, 'minute'),
    ];
    if (!hasDayLength) {
      return time.isEmpty ? '0 minutes' : time.join(' and ');
    }
    final dayText = unit(days, 'day');
    return time.isEmpty ? dayText : '$dayText, ${time.join(' and ')}';
  }

  @override
  String toString() => short;
}
