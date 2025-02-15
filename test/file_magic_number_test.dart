import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/magic_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_temp_file.dart';

void main() {
  group('MagicNumber', () {
    test('Detects ZIP file', () async {
      final tempFile = await createTempFile([0x50, 0x4B, 0x03, 0x04]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, MagicNumberType.zip);
      await tempFile.delete();
    });

    test('Detects PDF file', () async {
      final tempFile = await createTempFile([0x25, 0x50, 0x44, 0x46]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, MagicNumberType.pdf);
      await tempFile.delete();
    });

    test('Detects PNG file', () async {
      final tempFile = await createTempFile([0x89, 0x50, 0x4E, 0x47]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, MagicNumberType.png);
      await tempFile.delete();
    });

    test('Returns null for unknown file type', () async {
      final tempFile = await createTempFile([0x12, 0x34, 0x56, 0x78]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, MagicNumberType.unknown);
      await tempFile.delete();
    });

    test('Returns null for empty file', () async {
      final tempFile = await createTempFile([]);
      final result = await MagicNumber.detectFileType(tempFile.path);
      expect(result, MagicNumberType.emptyFile);
      await tempFile.delete();
    });

    test('Returns fileNotExist for non-existent file', () async {
      final nonExistentFilePath = '/fake-path/non_existent_file.tmp';
      final result = await MagicNumber.detectFileType(nonExistentFilePath);
      expect(result, MagicNumberType.fileNotExist);
    });
  });
}
