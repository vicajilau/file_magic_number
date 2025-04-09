import 'dart:typed_data';

import 'package:file_magic_number/file_magic_number.dart';
import 'package:test/test.dart';

void main() {
  group('FileMagicNumber - detectFileTypeFromBytes', () {
    test('Detects ZIP file', () {
      final bytes = Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.zip);
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
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.rar);
    });

    test('Detects RAR v5 file', () {
      final bytes = Uint8List.fromList([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.rar);
    });

    test('Detects 7Z file', () {
      final bytes = Uint8List.fromList([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.sevenZ);
    });

    test('Detects PDF file', () {
      final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.pdf);
    });

    test('Detects PNG file', () {
      final bytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.png);
    });

    test('Detects JPG file', () {
      final bytes = Uint8List.fromList([0xFF, 0xD8, 0xFF]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.jpg);
    });

    test('Detects GIF file', () {
      final bytes = Uint8List.fromList([0x47, 0x49, 0x46, 0x38]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.gif);
    });

    test('Detects TIFF file', () {
      final bytes = Uint8List.fromList([0x49, 0x49, 0x2A, 0x00]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.tiff);
    });

    test('Detects BMP file', () {
      final bytes = Uint8List.fromList([0x42, 0x4D]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.bmp);
    });

    test('Detects MP3 file', () {
      final bytes = Uint8List.fromList([0x49, 0x44, 0x33]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.mp3);
    });

    test('Detects WAV file', () {
      final bytes = Uint8List.fromList([0x52, 0x49, 0x46, 0x46]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.wav);
    });

    test('Detects MP4 file', () {
      final bytes =
          Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.mp4);
    });

    test('Detects ELF file', () {
      final bytes = Uint8List.fromList([0x7F, 0x45, 0x4C, 0x46]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.elf);
    });

    test('Detects EXE file', () {
      final bytes = Uint8List.fromList([0x4D, 0x5A]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.exe);
    });

    test('Detects TAR file', () {
      final bytes = Uint8List.fromList([0x75, 0x73, 0x74, 0x61, 0x72]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.tar);
    });

    test('Detects SQLite file', () {
      final bytes = Uint8List.fromList([0x53, 0x51, 0x4C, 0x69, 0x74, 0x65]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.sqlite);
    });

    test('Returns unknown for unrecognized file type', () {
      final bytes = Uint8List.fromList([0x12, 0x34, 0x56, 0x78]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.unknown);
    });

    test('Returns emptyFile for empty input', () {
      final bytes = Uint8List.fromList([]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.emptyFile);
    });

    test('Returns emptyFile for null input', () {
      final result = FileMagicNumber.detectFileTypeFromBytes(null);
      expect(result, FileMagicNumberType.emptyFile);
    });

    test('Detects MP4 file when bytes.length > _maxSignatureLength', () {
      final bytes = Uint8List.fromList(
        [0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D] +
            List.filled(100, 0x00),
      );
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.mp4);
    });

    test('Detects HEIC file with ftypmi signature', () {
      final bytes = Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x6D, 0x69]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.heic);
    });

    test('Detects HEIC file with ftypmi signature', () {
      final bytes = Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x6D, 0x69]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.heic);
    });

    test('Detects HEIC file with ftypheic signature', () {
      final bytes =
          Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.heic);
    });

    test('Detects HEIC file with ftypmif1 signature', () {
      final bytes =
          Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x6D, 0x69, 0x66, 0x31]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.heic);
    });

    test('Detects HEIC file with ftypheix signature', () {
      final bytes =
          Uint8List.fromList([0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x78]);
      final result = FileMagicNumber.detectFileTypeFromBytes(bytes);
      expect(result, FileMagicNumberType.heic);
    });
  });
}
