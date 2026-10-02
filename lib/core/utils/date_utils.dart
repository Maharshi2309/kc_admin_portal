import 'package:intl/intl.dart';

/// Display formats used across the app, matching the design
/// (e.g. "Mon, 28 Sep 2026", "28 Sep 2026", "09:12").
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: locale and timezone.
/// English (en) formatting in the device's local time is assumed.
abstract final class AppDateFormat {
  static const List<String> _weekdaysShort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// ISO weekday (1 = Monday … 7 = Sunday) → "Mon" … "Sun".
  static String weekdayShort(int isoWeekday) =>
      _weekdaysShort[isoWeekday - DateTime.monday];

  static final DateFormat _long = DateFormat('EEE, d MMM yyyy');
  static final DateFormat _medium = DateFormat('d MMM yyyy');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _time = DateFormat('HH:mm');

  /// "Mon, 28 Sep 2026"
  static String long(DateTime date) => _long.format(date);

  /// "28 Sep 2026"
  static String medium(DateTime date) => _medium.format(date);

  /// "September 2026"
  static String monthYear(DateTime date) => _monthYear.format(date);

  /// "09:12"
  static String time(DateTime date) => _time.format(date);

  static final DateFormat _dayMonth = DateFormat('d MMM');

  /// "28 Sep"
  static String dayMonth(DateTime date) => _dayMonth.format(date);

  /// "21 Sep 2026", "21 – 22 Sep 2026", "30 Sep – 2 Oct 2026",
  /// "30 Dec 2025 – 2 Jan 2026".
  static String range(DateTime start, DateTime end) {
    if (isSameDay(start, end)) return medium(start);
    if (start.year != end.year) return '${medium(start)} – ${medium(end)}';
    if (start.month != end.month) {
      return '${dayMonth(start)} – ${medium(end)}';
    }
    return '${start.day} – ${medium(end)}';
  }

  static final DateFormat _weekdayDay = DateFormat('EEE d');
  static final DateFormat _weekdayDayMonth = DateFormat('EEE d MMM');

  /// "Mon 5 Oct", "Mon 5 – Wed 7 Oct", "Wed 30 Sep – Fri 2 Oct".
  static String shortRange(DateTime start, DateTime end) {
    if (isSameDay(start, end)) return _weekdayDayMonth.format(start);
    if (start.month == end.month && start.year == end.year) {
      return '${_weekdayDay.format(start)} – ${_weekdayDayMonth.format(end)}';
    }
    return '${_weekdayDayMonth.format(start)} – ${_weekdayDayMonth.format(end)}';
  }

  static final DateFormat _iso = DateFormat('yyyy-MM-dd');

  /// "2026-09-28", for URLs.
  static String iso(DateTime date) => _iso.format(date);

  /// Parses [iso] output; null when [text] is missing or invalid.
  static DateTime? tryParseIso(String? text) {
    if (text == null) return null;
    try {
      return _iso.parseStrict(text);
    } on FormatException {
      return null;
    }
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Date formats used in API query parameters.
abstract final class ApiDateFormat {
  static final DateFormat _date = DateFormat('yyyy-MM-dd');
  static final DateFormat _month = DateFormat('yyyy-MM');

  /// "2026-09-28"
  static String date(DateTime date) => _date.format(date);

  /// "2026-09"
  static String month(DateTime date) => _month.format(date);
}
