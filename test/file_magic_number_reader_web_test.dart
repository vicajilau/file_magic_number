import 'dart:js_interop';
import 'dart:typed_data';

import 'package:file_magic_number/reader/file_magic_number_reader_web.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart';

void main() {
  group('FileMagicNumberReader (Web)', () {
    late FileMagicNumberReader reader;

    setUp(() {
      reader = FileMagicNumberReader();
    });

    test('readFile should return Uint8List from mock fetch', () async {
      // Mock response (simulate a PNG file)
      Uint8List mockData = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]);

      final blob = Blob([mockData.toJS].toJS);

      final blobUrl = URL.createObjectURL(blob);

      final Uint8List result = await reader.readFile(blobUrl);

      expect(result, equals(mockData));
    });

    test('readFile should throw exception for invalid URL', () async {
      expect(() => reader.readFile('invalid-url'), throwsA(isA<Exception>()));
    });
  });
}
