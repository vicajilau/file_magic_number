import 'dart:io';
import 'dart:typed_data';

import 'package:file_magic_number/file_magic_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileMagicNumberReader (IO)', () {
    test('readFile should return correct Uint8List content', () async {
      final reader = FileMagicNumberReader();
      final testFile = File('readFile.txt');

      // Write sample data
      await testFile.writeAsBytes(
        Uint8List.fromList([0x25, 0x50, 0x44, 0x46]),
      ); // "%PDF"
      final Uint8List result = await reader.readFile(testFile.path);

      expect(result, isNotNull);
      expect(result, equals(Uint8List.fromList([0x25, 0x50, 0x44, 0x46])));
      await testFile.delete();
    });

    test('readFile should throw exception for nonexistent file', () async {
      final reader = FileMagicNumberReader();
      expect(
        () => reader.readFile('non_existent_file.txt'),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}
