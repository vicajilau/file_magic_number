import 'package:file_magic_number/file_magic_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileMagicNumberReader (Base Class)', () {
    test('readFile should throw UnimplementedError', () async {
      final reader = FileMagicNumberReader();

      expect(
        () => reader.readFile('test.txt'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
