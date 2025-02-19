import 'dart:io';
import 'dart:typed_data';

import 'package:file_magic_number/reader/file_magic_number_reader_io.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileMagicNumberReader (IO)', () {
    late File testFile;
    late FileMagicNumberReader reader;

    setUp(() async {
      reader = FileMagicNumberReader();
      testFile = File('test.txt');

      // Write sample data
      await testFile.writeAsBytes(
        Uint8List.fromList([0x25, 0x50, 0x44, 0x46]),
      ); // "%PDF"
    });

    tearDown(() async {
      if (await testFile.exists()) {
        await testFile.delete();
      }
    });

    test('readFile should return correct Uint8List content', () async {
      final Uint8List? result = await reader.readFile(testFile.path);

      expect(result, isNotNull);
      expect(result, equals(Uint8List.fromList([0x25, 0x50, 0x44, 0x46])));
    });

    test('readFile should throw exception for nonexistent file', () async {
      expect(
        () => reader.readFile('non_existent_file.txt'),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}
