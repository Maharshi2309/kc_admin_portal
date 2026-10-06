/// Time zones offered when creating an organization: "today", lateness and
/// month boundaries follow the organization's zone
/// (docs/ARCHITECTURE_MULTI_ORG.md §B). IANA ids, sent to the API as is.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: a short list of common zones;
/// a full list can replace it when organizations outside them sign up.
typedef TimeZoneChoice = ({String id, String label, int standardOffsetMinutes});

const List<TimeZoneChoice> timeZoneChoices = [
  (id: 'Pacific/Honolulu', label: 'Hawaii', standardOffsetMinutes: -600),
  (id: 'America/Anchorage', label: 'Alaska', standardOffsetMinutes: -540),
  (
    id: 'America/Los_Angeles',
    label: 'Pacific Time (US)',
    standardOffsetMinutes: -480,
  ),
  (
    id: 'America/Denver',
    label: 'Mountain Time (US)',
    standardOffsetMinutes: -420,
  ),
  (
    id: 'America/Chicago',
    label: 'Central Time (US)',
    standardOffsetMinutes: -360,
  ),
  (
    id: 'America/New_York',
    label: 'Eastern Time (US)',
    standardOffsetMinutes: -300,
  ),
  (
    id: 'America/Sao_Paulo',
    label: 'Brazil (São Paulo)',
    standardOffsetMinutes: -180,
  ),
  (id: 'Europe/London', label: 'United Kingdom', standardOffsetMinutes: 0),
  (id: 'Europe/Paris', label: 'Central Europe', standardOffsetMinutes: 60),
  (
    id: 'Africa/Johannesburg',
    label: 'South Africa',
    standardOffsetMinutes: 120,
  ),
  (id: 'Africa/Cairo', label: 'Egypt', standardOffsetMinutes: 120),
  (
    id: 'Africa/Nairobi',
    label: 'East Africa (Nairobi)',
    standardOffsetMinutes: 180,
  ),
  (id: 'Asia/Riyadh', label: 'Saudi Arabia', standardOffsetMinutes: 180),
  (id: 'Asia/Dubai', label: 'United Arab Emirates', standardOffsetMinutes: 240),
  (id: 'Asia/Karachi', label: 'Pakistan', standardOffsetMinutes: 300),
  (id: 'Asia/Kolkata', label: 'India', standardOffsetMinutes: 330),
  (id: 'Asia/Kathmandu', label: 'Nepal', standardOffsetMinutes: 345),
  (id: 'Asia/Dhaka', label: 'Bangladesh', standardOffsetMinutes: 360),
  (id: 'Asia/Bangkok', label: 'Thailand', standardOffsetMinutes: 420),
  (
    id: 'Asia/Jakarta',
    label: 'Indonesia (Jakarta)',
    standardOffsetMinutes: 420,
  ),
  (id: 'Asia/Singapore', label: 'Singapore', standardOffsetMinutes: 480),
  (id: 'Asia/Shanghai', label: 'China', standardOffsetMinutes: 480),
  (id: 'Asia/Tokyo', label: 'Japan', standardOffsetMinutes: 540),
  (
    id: 'Australia/Sydney',
    label: 'Australia (Sydney)',
    standardOffsetMinutes: 600,
  ),
  (id: 'Pacific/Auckland', label: 'New Zealand', standardOffsetMinutes: 720),
];

/// "India · UTC+5:30".
String timeZoneLabel(TimeZoneChoice zone) {
  final minutes = zone.standardOffsetMinutes;
  final sign = minutes < 0 ? '−' : '+';
  final hours = minutes.abs() ~/ 60;
  final rest = minutes.abs() % 60;
  final offset = rest == 0
      ? '$hours'
      : '$hours:${rest.toString().padLeft(2, '0')}';
  return '${zone.label} · UTC$sign$offset';
}

/// A sensible first choice: the zone whose standard offset matches the
/// device's current offset (summer time may pick a neighbour; the person
/// can change it).
String suggestedTimeZone(Duration deviceOffset) {
  final minutes = deviceOffset.inMinutes;
  return timeZoneChoices
          .where((z) => z.standardOffsetMinutes == minutes)
          .firstOrNull
          ?.id ??
      'Asia/Kolkata';
}
