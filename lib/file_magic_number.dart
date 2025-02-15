import 'dart:io';
import 'dart:typed_data';

import 'package:file_magic_number/stream_extension.dart';

/// A utility class for detecting file types based on their magic numbers.
///
/// Magic numbers are specific byte sequences at the beginning of a file
/// that indicate its format. This approach is more reliable than using MIME types.
///
/// Supported file types:
/// - ZIP (`0x50 0x4B 0x03 0x04`)
/// - PDF (`0x25 0x50 0x44 0x46`)
/// - PNG (`0x89 0x50 0x4E 0x47`)
/// - JPG (`0xFF 0xD8 0xFF`)
/// - ELF (`0x7F 0x45 0x4C 0x46`)
/// - BMP (`0x42 0x4D`)
/// - EXE (`0x4D 0x5A`)
class MagicNumber {
  /// A map of known magic number signatures associated with file types.
  static const Map<List<int>, String> _magicNumbers = {
    [0x50, 0x4B, 0x03, 0x04]: 'zip',
    [0x25, 0x50, 0x44, 0x46]: 'pdf',
    [0x89, 0x50, 0x4E, 0x47]: 'png',
    [0xFF, 0xD8, 0xFF]: 'jpg',
    [0x7F, 0x45, 0x4C, 0x46]: 'elf',
    [0x42, 0x4D]: 'bmp',
    [0x4D, 0x5A]: 'exe',
  };

  /// Detects the file type by reading its magic number.
  ///
  /// This method reads the first 16 bytes of the given file and checks if
  /// they match any known magic number signatures.
  ///
  /// - Returns the file type as a `String`, or `null` if the type is unknown or the file is empty.
  ///
  /// - Throws a `FileSystemException` if the file does not exist or cannot be read.
  ///
  /// Example usage:
  /// ```dart
  /// String? fileType = await MagicNumber.detectFileType('path/to/file');
  /// print(fileType); // Output: 'png', 'pdf', etc.
  /// ```
  static Future<String?> detectFileType(String filePath) async {
    final file = File(filePath);
    if (!(await file.exists())) return null;

    final Stream<List<int>> stream = file.openRead(0, 16);
    final List<int>? byteList = await stream.firstOrNull();

    if (byteList == null || byteList.isEmpty) {
      return null; // Prevents "Bad state: No element" error
    }

    final Uint8List bytes = Uint8List.fromList(byteList);

    for (var entry in _magicNumbers.entries) {
      if (_matches(bytes, entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Checks if the given byte sequence matches a known magic number signature.
  ///
  /// - `bytes`: The first bytes of the file.
  /// - `signature`: The expected magic number signature.
  ///
  /// - Returns `true` if the bytes match the signature, otherwise `false`.
  static bool _matches(Uint8List bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (int i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }
}
