import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:file_magic_number/file_magic_number.dart';

void main() {
  group('MagicNumber', () {
    test('Detects ZIP file', () async {
      final tempFile = await _createTempFile([0x50, 0x4B, 0x03, 0x04]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, 'zip');
      await tempFile.delete();
    });

    test('Detects PDF file', () async {
      final tempFile = await _createTempFile([0x25, 0x50, 0x44, 0x46]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, 'pdf');
      await tempFile.delete();
    });

    test('Detects PNG file', () async {
      final tempFile = await _createTempFile([0x89, 0x50, 0x4E, 0x47]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, 'png');
      await tempFile.delete();
    });

    test('Returns null for unknown file type', () async {
      final tempFile = await _createTempFile([0x12, 0x34, 0x56, 0x78]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, isNull);
      await tempFile.delete();
    });

    test('Returns null for empty file', () async {
      final tempFile = await _createTempFile([]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, isNull);
      await tempFile.delete();
    });
  });
}

/// 📁 Crea un archivo temporal con los bytes especificados.
Future<File> _createTempFile(List<int> bytes) async {
  final tempFile = File('${Directory.systemTemp.path}/test_magic_number.tmp');
  await tempFile.writeAsBytes(Uint8List.fromList(bytes));
  return tempFile;
}
