import 'dart:io';
import 'dart:typed_data';

/// Creates a temporary file with the specified bytes.
///
/// This function generates a temporary file in the system's temporary directory,
/// writes the provided list of bytes to it, and returns the created file.
///
/// - `bytes`: A list of integers representing the byte sequence to be written to the file.
///
/// - Returns: A `Future<File>` representing the created temporary file.
///
/// Example usage:
/// ```dart
/// final tempFile = await _createTempFile([0x50, 0x4B, 0x03, 0x04]);
/// ```
Future<File> createTempFile(List<int> bytes) async {
  final tempFile = File('${Directory.systemTemp.path}/test_magic_number.tmp');
  await tempFile.writeAsBytes(Uint8List.fromList(bytes));
  return tempFile;
}