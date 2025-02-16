import 'dart:typed_data';

import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/magic_number_type.dart';
import 'package:test/test.dart';

void main() {
  group('MagicNumber', () {
    test('Detects ZIP file', () {
      final bytes = Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.zip);
    });

    test('Detects RAR v1.5 - v2.0 file', () {
      final bytes = Uint8List.fromList([
        0x52,
        0x61,
        0x72,
        0x21,
        0x1A,
        0x07,
        0x00,
      ]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.rar);
    });

    test('Detects RAR v5 file', () {
      final bytes = Uint8List.fromList([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.rar);
    });

    test('Detects 7Z file', () {
      final bytes = Uint8List.fromList([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.sevenZ);
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

    test('Detects JPG file', () {
      final bytes = Uint8List.fromList([0xFF, 0xD8, 0xFF]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.jpg);
    });

    test('Detects GIF file', () {
      final bytes = Uint8List.fromList([0x47, 0x49, 0x46, 0x38]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.gif);
    });

    test('Detects TIFF file', () {
      final bytes = Uint8List.fromList([0x49, 0x49, 0x2A, 0x00]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.tiff);
    });

    test('Detects BMP file', () {
      final bytes = Uint8List.fromList([0x42, 0x4D]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.bmp);
    });

    test('Detects MP3 file', () {
      final bytes = Uint8List.fromList([0x49, 0x44, 0x33]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.mp3);
    });

    test('Detects WAV file', () {
      final bytes = Uint8List.fromList([0x52, 0x49, 0x46, 0x46]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.wav);
    });

    test('Detects MP4 file', () {
      final bytes = Uint8List.fromList([0x66, 0x74, 0x79, 0x70]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.mp4);
    });

    test('Detects ELF file', () {
      final bytes = Uint8List.fromList([0x7F, 0x45, 0x4C, 0x46]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.elf);
    });

    test('Detects EXE file', () {
      final bytes = Uint8List.fromList([0x4D, 0x5A]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.exe);
    });

    test('Detects TAR file', () {
      final bytes = Uint8List.fromList([0x75, 0x73, 0x74, 0x61, 0x72]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.tar);
    });

    test('Detects SQLite file', () {
      final bytes = Uint8List.fromList([0x53, 0x51, 0x4C, 0x69, 0x74, 0x65]);
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.sqlite);
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

    test('Limits byte check to _maxSignatureLength', () {
      final bytes = Uint8List.fromList(
        [0x66, 0x74, 0x79, 0x70] + List.filled(16, 0x00),
      );
      final result = MagicNumber.detectFileType(bytes);
      expect(result, MagicNumberType.mp4);
    });
  });
}
