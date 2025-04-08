import 'dart:typed_data';

/// Abstract base class for reading the binary data of a file.
///
/// This class provides a common interface for platform-specific implementations
/// of file reading. The actual reading logic should be implemented in platform-
/// specific subclasses.
class FileMagicNumberReader {
  /// Reads the binary content of a file from the given path.
  ///
  /// This method should be implemented by platform-specific subclasses.
  ///
  /// - [path]: The path or URL of the file to read.
  /// - Returns: A `Uint8List` containing the binary content of the file.
  /// - Throws: An `UnimplementedError` if not overridden by a subclass.
  Future<Uint8List> readFile(String path) async {
    throw UnimplementedError();
  }
}
