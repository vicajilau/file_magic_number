import 'dart:io';
import 'dart:typed_data';

import 'package:file_magic_number/src/file_magic_number.dart';
import 'package:file_magic_number/src/file_magic_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file_extension.dart';

void main() {
  group('FileMagicNumber detectFileTypeFromPathOrBlob (IO)', () {
    test('Detects RAR v5 file', () async {
      final testFile = File('RARv5.rar');
      await testFile.writeToFile([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.rar);
      await testFile.delete();
    });

    test('Detects 7Z file', () async {
      final testFile = File('test.7z');
      await testFile.writeToFile([0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.sevenZ);
      await testFile.delete();
    });

    test('Detects BMP file', () async {
      final testFile = File('test.bmp');
      await testFile.writeToFile([0x42, 0x4D]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.bmp);
      await testFile.delete();
    });

    test('Detects ELF file', () async {
      final testFile = File('test.elf');
      await testFile.writeToFile([0x7F, 0x45, 0x4C, 0x46]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.elf);
      await testFile.delete();
    });

    test('Detects EXE file', () async {
      final testFile = File('test.exe');
      await testFile.writeToFile([0x4D, 0x5A]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.exe);
      await testFile.delete();
    });

    test('Detects TAR file', () async {
      final testFile = File('test.tar');
      await testFile.writeToFile([0x75, 0x73, 0x74, 0x61, 0x72]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.tar);
      await testFile.delete();
    });

    test('Detects SQLite file', () async {
      final testFile = File('test.sqlite');
      await testFile.writeToFile([0x53, 0x51, 0x4C, 0x69, 0x74, 0x65]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.sqlite);
      await testFile.delete();
    });

    test('Detects ZIP file', () async {
      final testFile = File('test.zip');
      await testFile.writeToFile([0x50, 0x4B, 0x03, 0x04]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.zip);
      await testFile.delete();
    });

    test('Detects AVI file', () async {
      final testFile = File('test.avi');
      await testFile.writeToFile(
          [0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x41, 0x56, 0x49, 0x20]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.avi);
      await testFile.delete();
    });

    test('Detects DOCX file', () async {
      final testFile = File('test.docx');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.docx);
      await testFile.delete();
    });

    test('Detects XLSX file', () async {
      final testFile = File('test.xlsx');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.xlsx);
      await testFile.delete();
    });

    test('Detects PPTX file', () async {
      final testFile = File('test.pptx');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.pptx);
      await testFile.delete();
    });

    test('Detects HTML file', () async {
      final testFile = File('test.html');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.html);
      await testFile.delete();
    });

    test('Detects JSON file', () async {
      final testFile = File('test.json');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.json);
      await testFile.delete();
    });

    test('Detects XML file', () async {
      final testFile = File('test.xml');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.xml);
      await testFile.delete();
    });

    test('Detects CSV file', () async {
      final testFile = File('test.csv');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.csv);
      await testFile.delete();
    });

    test('Detects SVG file', () async {
      final testFile = File('test.svg');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.svg);
      await testFile.delete();
    });

    test('Detects TXT file', () async {
      final testFile = File('test.txt');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.txt);
      await testFile.delete();
    });

    test('Detects RTF file', () async {
      final testFile = File('test.rtf');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.rtf);
      await testFile.delete();
    });

    test('Detects EPUB file', () async {
      final testFile = File('test.epub');
      await testFile.writeToFile([1, 2, 3]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.epub);
      await testFile.delete();
    });

    test('Detects empty file', () async {
      final testFile = File('empty.txt');
      await testFile.writeToFile([]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.emptyFile);
      await testFile.delete();
    });

    test(
      'detectFileTypeFromPathOrBlob should throw exception for nonexistent file',
      () async {
        expect(
          () async => await FileMagicNumber.detectFileTypeFromPathOrBlob(
            "testFile.path",
          ),
          throwsA(isA<PathNotFoundException>()),
        );
      },
    );
  });

  test('Detects Uint8list file', () async {
    final testFile = File('RARv5.rar');
    final bytes = [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07];
    await testFile.writeToFile(bytes);
    final result = await FileMagicNumber.getBytesFromPathOrBlob(
      testFile.path,
    );
    expect(result, Uint8List.fromList(bytes));
    await testFile.delete();
  });
}
