import 'package:kc_admin_portal/core/utils/duration_format.dart';

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

  /// "2 Days", "1 Day 2 Hours 30 Minutes", "0 Days 1 Hour 30 Minutes";
  /// without a day length, just the time ("25 Hours").
  String get full {
    final time = [
      if (hours > 0) DurationFormat.unit(hours, 'Hour'),
      if (minutes > 0) DurationFormat.unit(minutes, 'Minute'),
    ];
    if (!hasDayLength) {
      return time.isEmpty ? DurationFormat.full(0) : time.join(' ');
    }
    return [DurationFormat.unit(days, 'Day'), ...time].join(' ');
  }

  /// Where space is tight: "1d 2h 30m", "2d", "0d 1h 30m"; "25h" without a
  /// day length.
  String get compact {
    final time = [if (hours > 0) '${hours}h', if (minutes > 0) '${minutes}m'];
    if (!hasDayLength) return time.isEmpty ? '0m' : time.join(' ');
    return ['${days}d', ...time].join(' ');
  }

  @override
  String toString() => full;
}
