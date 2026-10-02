/// The work email suggested for a new employee, as in the design:
/// `firstname.lastname@<domain>`, where the domain is taken from the signed-in
/// admin's own email.
///
/// Only the first and last words of [fullName] are used, reduced to
/// lowercase letters (so "Ravi K. Patel" becomes `ravi.patel`). Returns
/// `null` when there is nothing usable to suggest.
///
/// TODO — REQUIREMENT CONFIRMATION REQUIRED: the company email format is
/// taken from the design; the backend stays the authority on uniqueness.
String? suggestWorkEmail({
  required String fullName,
  required String? adminEmail,
}) {
  final at = adminEmail?.lastIndexOf('@') ?? -1;
  if (adminEmail == null || at < 0 || at == adminEmail.length - 1) return null;
  final domain = adminEmail.substring(at + 1).toLowerCase();

  final words = fullName
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .map((word) => word.replaceAll(RegExp('[^a-z]'), ''))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return null;

  final local = words.length == 1
      ? words.first
      : '${words.first}.${words.last}';
  return '$local@$domain';
}
