import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:kc_admin_portal/core/utils/date_utils.dart';

abstract final class FormatUtils {
  static final NumberFormat _count = NumberFormat.decimalPattern('en');
  static final NumberFormat _oneDecimal = NumberFormat('0.#', 'en');

  static const int _monthsPerYear = 12;
  static const int _minutesPerHour = 60;
  static const int _mobileGroup = 5;
  static const String _mobileCountryCode = '+91';

  /// Up to two initials from a person's name: "Aarav Shah" → "AS", "Priya" → "P".
  static String initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    final first = parts.first.characters.first;
    final last = parts.length > 1 ? parts.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  /// 1176 → "1,176".
  static String count(num value) => _count.format(value);

  /// 84 → "84%", 86.44 → "86.4%". The value is already a percentage (0–100).
  static String percent(num value) => '${_oneDecimal.format(value)}%';

  /// 1 → "1 day", 3 → "3 days", 0.5 → "0.5 days", 1176 → "1,176 days".
  static String days(num value) {
    final text = value == value.roundToDouble()
        ? count(value)
        : _oneDecimal.format(value);
    return value == 1 ? '$text day' : '$text days';
  }

  /// "9825011234" → "+91 98250 11234". Other shapes are shown unchanged.
  static String mobile(String digits) {
    if (digits.length != _mobileGroup * 2) return digits;
    return '$_mobileCountryCode ${digits.substring(0, _mobileGroup)} '
        '${digits.substring(_mobileGroup)}';
  }

  /// Time since [start] as of [today]: "5 yrs 8 mos", "3 mos", "Joins soon".
  static String tenure(DateTime start, DateTime today) {
    var months =
        (today.year - start.year) * _monthsPerYear + today.month - start.month;
    if (today.day < start.day) months--;
    if (months < 0) return 'Joins soon';
    if (months == 0) return 'Less than a month';

    final years = months ~/ _monthsPerYear;
    final rest = months % _monthsPerYear;
    return [
      if (years > 0) '$years ${years == 1 ? 'yr' : 'yrs'}',
      if (rest > 0) '$rest ${rest == 1 ? 'mo' : 'mos'}',
    ].join(' ');
  }

  /// 521 → "8h 41m", 309 → "5h 09m" (minutes always two digits).
  /// Short durations such as a break: 30 → "30 min", 60 → "1 h",
  /// 90 → "1 h 30 min", 0 → "No break" is up to the caller.
  static String minutes(int minutes) {
    final hours = minutes ~/ _minutesPerHour;
    final rest = minutes % _minutesPerHour;
    if (hours == 0) return '$rest min';
    return rest == 0 ? '$hours h' : '$hours h $rest min';
  }

  /// ISO weekdays as short names in week order: {6, 7} → "Sat, Sun".
  static String weekdays(Iterable<int> isoWeekdays) =>
      (isoWeekdays.toSet().toList()..sort())
          .map(AppDateFormat.weekdayShort)
          .join(', ');

  /// Overtime and other extra time: 45 → "45m", 90 → "1h 30m", 120 → "2h".
  static String compactDuration(int minutes) {
    final hours = minutes ~/ _minutesPerHour;
    final rest = minutes % _minutesPerHour;
    if (hours == 0) return '${rest}m';
    return rest == 0 ? '${hours}h' : '${hours}h ${rest}m';
  }

  static String duration(int minutes) =>
      '${minutes ~/ _minutesPerHour}h '
      '${(minutes % _minutesPerHour).toString().padLeft(2, '0')}m';
}
