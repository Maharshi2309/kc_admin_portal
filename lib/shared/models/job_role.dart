import 'package:freezed_annotation/freezed_annotation.dart';

/// The fixed list used for both an employee's **Department** and their
/// **Position** (requirement 2026-10-05: exactly these three, the same for
/// both, independent of each other). The API sends the codes
/// `accountant`, `graphic_designer`, `tailor` and validates them.
///
/// Add values only when the client asks for them.
@JsonEnum(fieldRename: FieldRename.snake)
enum JobRole {
  accountant('Accountant'),
  graphicDesigner('Graphic Designer'),
  tailor('Tailor'),

  /// A value from a newer backend this app version doesn't know.
  unknown('Other');

  const JobRole(this.label);

  final String label;

  /// The values to offer in forms and filters.
  static const List<JobRole> choices = [accountant, graphicDesigner, tailor];

  /// The API code, e.g. `graphic_designer`.
  String get code => switch (this) {
    accountant => 'accountant',
    graphicDesigner => 'graphic_designer',
    tailor => 'tailor',
    unknown => 'unknown',
  };
}
