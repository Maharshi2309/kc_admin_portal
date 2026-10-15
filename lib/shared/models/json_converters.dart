import 'package:json_annotation/json_annotation.dart';

import 'package:kc_admin_portal/core/config/company_time.dart';

/// Accepts ids sent as either numbers or strings and always stores a String,
/// so models do not break if the backend picks the other type.
///
/// Use with `@JsonKey(fromJson: idFromJson)`.
String idFromJson(Object? value) {
  if (value == null) throw const FormatException('Missing id');
  return value.toString();
}

/// Sends calendar dates without time or timezone ("2026-09-28"), so a date
/// can never shift by a day between the app and the server.
///
/// Use with `@JsonKey(toJson: dateToJson)`.
String dateToJson(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Reads and writes instants as **company wall-clock time**
/// ([CompanyTime], approved 2026-09-30), whatever the device's time zone.
///
/// - Calendar dates ("2026-09-28") stay that date.
/// - Instants with an offset ("2026-09-28T09:12:00+05:30" or "...Z") become
///   the company's local date and time, so 09:12 IST shows as 09:12 on any
///   device.
///
/// Apply per field: `@CompanyDateTimeConverter() DateTime? punchIn`.
class CompanyDateTimeConverter implements JsonConverter<DateTime, String> {
  const CompanyDateTimeConverter();

  static const int _dateLength = 10; // "YYYY-MM-DD"

  @override
  DateTime fromJson(String json) {
    final parsed = DateTime.parse(json);
    // A plain date carries no zone: it is already a company date.
    return json.length <= _dateLength
        ? parsed
        : CompanyTime.fromInstant(parsed);
  }

  /// Sends the wall-clock time with the offset in force then, e.g.
  /// "2026-09-28T09:35:00+05:30", so the server knows the exact moment.
  @override
  String toJson(DateTime object) {
    final wall = object.isUtc ? CompanyTime.fromInstant(object) : object;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dateToJson(wall)}T${two(wall.hour)}:${two(wall.minute)}:'
        '${two(wall.second)}${CompanyTime.offsetTextAt(wall)}';
  }
}

/// Reads calendar dates ("2026-09-28") as that local date. If a full
/// timestamp is sent instead, only its date part is used, so the date never
/// shifts by a day because of time zones.
///
/// Apply per field: `@DateOnlyConverter() required DateTime date`.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  static const int _dateLength = 10; // "YYYY-MM-DD"

  @override
  DateTime fromJson(String json) {
    final date = DateTime.parse(
      json.length > _dateLength ? json.substring(0, _dateLength) : json,
    );
    return DateTime(date.year, date.month, date.day);
  }

  @override
  String toJson(DateTime object) => dateToJson(object);
}
