import 'dart:io';
import 'dart:typed_data';

/// Platform-specific implementation of `FileMagicNumberReader` for IO (mobile & desktop).
///
/// This class reads binary data from a local file system using Dart's `dart:io` package.
class FileMagicNumberReader {
  /// Reads the binary data of a file from the local file system.
  ///
  /// - [path]: The absolute path of the file to read.
  /// - Returns: A `Uint8List` containing the binary content of the file.
  /// - Throws: An `IOException` if there is an error reading the file.
  Future<Uint8List> readFile(String path) async {
    // Create a File object for the provided file path.
    final file = File(path);

    // Read the file content as bytes and return it.
    return await file.readAsBytes();
  }
}
