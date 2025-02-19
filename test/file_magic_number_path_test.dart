import 'dart:io';

import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/file_magic_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file_extension.dart';

void main() {
  group('FileMagicNumber detectFileTypeFromPathOrBlob (IO)', () {
    late File testFile;

    setUp(() async {
      testFile = File('test.txt');
    });

    tearDown(() async {
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('Detects RAR v5 file', () async {
      testFile.writeToFile([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.rar);
    });

    test('Detects empty file', () async {
      testFile.writeToFile([]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.emptyFile);
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
}
