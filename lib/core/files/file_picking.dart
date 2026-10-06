import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A file the person chose: its name (never trusted for the type) and
/// contents.
typedef PickedFile = ({String name, Uint8List bytes});

/// Opens the platform's file picker (Android, iOS and web) for one file
/// with one of [extensions]. Null when nothing was chosen.
typedef FileChooser =
    Future<PickedFile?> Function({required List<String> extensions});

Future<PickedFile?> _choose({required List<String> extensions}) async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: extensions,
  );
  if (file == null) return null;
  return (name: file.name, bytes: await file.xFile.readAsBytes());
}

/// The file picker; tests replace it.
final fileChooserProvider = Provider<FileChooser>((ref) => _choose);

/// Saves [bytes] as an Excel file called [name] (without extension): a
/// download on the web, the Files app or downloads folder on phones.
typedef ExcelSaver = Future<void> Function(String name, Uint8List bytes);

Future<void> _saveExcel(String name, Uint8List bytes) async {
  await FileSaver.instance.saveFile(
    name: name,
    bytes: bytes,
    fileExtension: 'xlsx',
    mimeType: MimeType.microsoftExcel,
  );
}

/// The file saver; tests replace it.
final excelSaverProvider = Provider<ExcelSaver>((ref) => _saveExcel);
