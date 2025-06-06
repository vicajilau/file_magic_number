import 'dart:io';
import 'dart:typed_data';

import 'package:file_magic_number/src/file_magic_number.dart';
import 'package:file_magic_number/src/file_magic_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'file_extension.dart';

void main() {
  group('FileMagicNumber detectFileTypeFromPathOrBlob (IO)', () {
    test('Detects RAR v5 file', () async {
      final testFile = File('RARv5.txt');
      await testFile.writeToFile([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]);
      final result = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        testFile.path,
      );
      expect(result, FileMagicNumberType.rar);
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
    final testFile = File('RARv5.txt');
    final bytes = [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07];
    await testFile.writeToFile(bytes);
    final result = await FileMagicNumber.getBytesFromPathOrBlob(
      testFile.path,
    );
    expect(result, Uint8List.fromList(bytes));
    await testFile.delete();
  });
}
