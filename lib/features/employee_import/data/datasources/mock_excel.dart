import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'package:kc_admin_portal/core/errors/app_exception.dart';
import 'package:kc_admin_portal/features/employee_import/data/datasources/employee_import_remote_data_source.dart';
import 'package:kc_admin_portal/features/employee_import/data/models/employee_import_models.dart';

/// A spreadsheet read as text: the header row and the data rows, each cell
/// as the text a person would see (dates as `yyyy-mm-dd`, times as `HH:mm`).
typedef SheetText = ({List<String> headers, List<List<String>> rows});

/// DEV ONLY (`USE_MOCK_API=true`): reading and writing Excel files, as the
/// backend does (docs/ARCHITECTURE_MULTI_ORG.md §D). Files are recognised by
/// their content, never their name; formulas are not run.
abstract final class MockExcel {
  static const List<int> _zip = [0x50, 0x4B, 0x03, 0x04];
  static const List<int> _ole = [0xD0, 0xCF, 0x11, 0xE0];

  static bool _startsWith(List<int> bytes, List<int> magic) =>
      bytes.length >= magic.length &&
      [
        for (var i = 0; i < magic.length; i++) bytes[i] == magic[i],
      ].every((same) => same);

  static Never _refuse(String message) =>
      throw ValidationException(message, fieldErrors: {'file': message});

  /// The first sheet of an `.xlsx` file. The real server also reads the
  /// older `.xls`; this mock asks for `.xlsx` instead.
  static SheetText read(Uint8List bytes) {
    if (bytes.length > maxImportBytes) {
      _refuse('The file is larger than 5 MB. Split it into smaller files.');
    }
    if (_startsWith(bytes, _ole)) {
      _refuse(
        'This is an older .xls file. The development mock reads .xlsx only: '
        'save it as .xlsx and try again (the server reads both).',
      );
    }
    if (!_startsWith(bytes, _zip)) {
      _refuse('This is not an Excel file. Choose an .xlsx or .xls file.');
    }
    final Excel book;
    try {
      book = Excel.decodeBytes(bytes);
    } on Object {
      _refuse(
        "This Excel file can't be read. Open it in Excel and save it again.",
      );
    }
    final sheet = book.tables.values.firstOrNull;
    final rows = [
      for (final row in sheet?.rows ?? const <List<Data?>>[])
        [for (final cell in row) _text(cell?.value)],
    ];
    // Leading empty rows (titles above the table) are skipped.
    final start = rows.indexWhere((r) => r.any((c) => c.isNotEmpty));
    if (start < 0) _refuse('The file is empty.');
    final headers = [
      for (final (i, h) in rows[start].indexed)
        h.isEmpty ? 'Column ${i + 1}' : h,
    ];
    while (headers.isNotEmpty && headers.last.startsWith('Column ')) {
      headers.removeLast();
    }
    final data = [
      for (final row in rows.skip(start + 1))
        if (row.any((c) => c.isNotEmpty))
          [
            for (var i = 0; i < headers.length; i++)
              i < row.length ? row[i] : '',
          ],
    ];
    if (data.isEmpty) _refuse('The file has headers but no rows.');
    if (data.length > maxImportRows) {
      _refuse(
        'The file has ${data.length} rows; at most $maxImportRows can be '
        'imported at once. Split it into smaller files.',
      );
    }
    return (headers: headers, rows: data);
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _text(CellValue? value) => switch (value) {
    null => '',
    TextCellValue() => value.value.toString().trim(),
    IntCellValue(:final value) => '$value',
    DoubleCellValue(:final value) =>
      value == value.roundToDouble() ? '${value.round()}' : '$value',
    DateCellValue(:final year, :final month, :final day) =>
      '$year-${_two(month)}-${_two(day)}',
    DateTimeCellValue(
      :final year,
      :final month,
      :final day,
      :final hour,
      :final minute,
    ) =>
      hour == 0 && minute == 0
          ? '$year-${_two(month)}-${_two(day)}'
          : '$year-${_two(month)}-${_two(day)} ${_two(hour)}:${_two(minute)}',
    TimeCellValue(:final hour, :final minute) =>
      '${_two(hour)}:${_two(minute)}',
    BoolCellValue(:final value) => value ? 'Yes' : 'No',
    // Formulas aren't run (a file could hide anything in them).
    FormulaCellValue() => '',
  };

  /// The headers of the official template, in order.
  static const Map<ImportField, String> templateHeaders = {
    ImportField.name: 'Employee name',
    ImportField.ecNumber: 'EC number',
    ImportField.mobile: 'Mobile number',
    ImportField.department: 'Department',
    ImportField.position: 'Position',
    ImportField.joiningDate: 'Joining date',
    ImportField.status: 'Status',
    ImportField.shiftStart: 'Shift start',
    ImportField.shiftEnd: 'Shift end',
    ImportField.breakMinutes: 'Break (minutes)',
    ImportField.weeklyOffs: 'Weekly off',
  };

  /// The template: headers, one example row, and an instructions sheet
  /// with the organization's departments and positions.
  static Uint8List template({
    required String ecNumberPrefix,
    required List<String> departments,
    required List<String> positions,
  }) {
    final book = Excel.createExcel();
    const employees = 'Employees';
    book.rename(book.getDefaultSheet()!, employees);
    book.appendRow(employees, [
      for (final header in templateHeaders.values) TextCellValue(header),
    ]);
    book.appendRow(employees, [
      TextCellValue('Rahul Sharma'),
      TextCellValue('${ecNumberPrefix}9001'),
      TextCellValue('9876543210'),
      TextCellValue(departments.firstOrNull ?? 'Accounts'),
      TextCellValue(positions.firstOrNull ?? 'Accountant'),
      TextCellValue('01/10/2026'),
      TextCellValue('Active'),
      TextCellValue('09:30'),
      TextCellValue('18:30'),
      const IntCellValue(60),
      TextCellValue('Sun'),
    ]);
    const help = 'Instructions';
    for (final line in [
      'Fill one row per employee. Delete the example row.',
      'Required: employee name, EC number, mobile number, department, '
          'position, joining date.',
      'EC number: $ecNumberPrefix followed by numbers, e.g. '
          '${ecNumberPrefix}1001.',
      'Joining date: dd/mm/yyyy, e.g. 01/10/2026 (or an Excel date).',
      'Status: Active or Inactive (empty means Active).',
      'Shift start and end: e.g. 09:30 and 18:30. Empty uses the default '
          'working schedule from Settings.',
      'Weekly off: day names separated by commas, e.g. Sat, Sun.',
      'Your own column names and order also work: you match the columns '
          'when you import.',
      '',
      'Departments: ${departments.isEmpty ? '(none yet)' : departments.join(', ')}',
      'Positions: ${positions.isEmpty ? '(none yet)' : positions.join(', ')}',
    ]) {
      book.appendRow(help, [TextCellValue(line)]);
    }
    return Uint8List.fromList(book.save()!);
  }

  /// The failed rows: their original cells and the reason in an extra
  /// column.
  static Uint8List report({
    required List<String> headers,
    required List<(int rowNumber, List<String> cells, String reason)> rows,
  }) {
    final book = Excel.createExcel();
    const name = 'Not imported';
    book.rename(book.getDefaultSheet()!, name);
    book.appendRow(name, [
      TextCellValue('Row'),
      for (final header in headers) TextCellValue(header),
      TextCellValue('Reason'),
    ]);
    for (final (rowNumber, cells, reason) in rows) {
      book.appendRow(name, [
        IntCellValue(rowNumber),
        for (final cell in cells) TextCellValue(cell),
        TextCellValue(reason),
      ]);
    }
    return Uint8List.fromList(book.save()!);
  }
}
