import 'dart:typed_data';

import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/magic_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MagicNumber', () {
    test('Detects ZIP file', () {
      final bytes = Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.zip);
    });

    test('Detects PDF file', () {
      final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.pdf);
    });

    test('Detects PNG file', () {
      final bytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.png);
    });

    test('Returns unknown for unrecognized file type', () {
      final bytes = Uint8List.fromList([0x12, 0x34, 0x56, 0x78]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.unknown);
    });

    test('Returns emptyFile for empty input', () {
      final bytes = Uint8List.fromList([]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.emptyFile);
    });

    test('Returns emptyFile for null input', () {
      final result = MagicNumber.detectFileType(null);
      expect(result, MagicNumberType.emptyFile);
    });
  });
}
