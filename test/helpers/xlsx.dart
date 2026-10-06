import 'dart:typed_data';

import 'package:excel/excel.dart';

/// An `.xlsx` file with [rows] (the first is usually the header): numbers
/// and dates become real Excel numbers and dates.
Uint8List xlsx(List<List<Object>> rows) {
  final book = Excel.createExcel();
  final sheet = book.getDefaultSheet()!;
  for (final row in rows) {
    book.appendRow(sheet, [
      for (final cell in row)
        switch (cell) {
          final int n => IntCellValue(n),
          final DateTime d => DateCellValue(
            year: d.year,
            month: d.month,
            day: d.day,
          ),
          _ => TextCellValue('$cell'),
        },
    ]);
  }
  return Uint8List.fromList(book.save()!);
}
