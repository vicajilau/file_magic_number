import 'dart:typed_data';

import 'package:file_magic_number/magic_number_type.dart';

/// A utility class for detecting file types based on their magic numbers.
///
/// Magic numbers are specific byte sequences at the beginning of a file
/// that indicate its format. This approach is more reliable than using MIME types.
class MagicNumber {
  /// A map of known magic number signatures associated with file types.
  static const Map<List<int>, MagicNumberType> _magicNumbers = {
    [0x50, 0x4B, 0x03, 0x04]: MagicNumberType.zip,
    [0x25, 0x50, 0x44, 0x46]: MagicNumberType.pdf,
    [0x89, 0x50, 0x4E, 0x47]: MagicNumberType.png,
    [0xFF, 0xD8, 0xFF]: MagicNumberType.jpg,
    [0x7F, 0x45, 0x4C, 0x46]: MagicNumberType.elf,
    [0x42, 0x4D]: MagicNumberType.bmp,
    [0x4D, 0x5A]: MagicNumberType.exe,
  };

  /// Detects the file type from a byte array using its magic number.
  ///
  /// - [bytes]: The byte data of the file.
  /// - Returns the detected file type, or `MagicNumberType.unknown` if not recognized.
  /// - Returns `MagicNumberType.emptyFile` if the byte array is empty.
  ///
  /// Example usage:
  /// ```dart
  /// Uint8List fileBytes = await someMethodToGetBytes();
  /// MagicNumberType fileType = MagicNumber.detectFileType(fileBytes);
  /// print(fileType); // Output: MagicNumberType.png, MagicNumberType.pdf, etc.
  /// ```
  static MagicNumberType detectFileType(Uint8List? bytes) {
    if (bytes == null || bytes.isEmpty) {
      return MagicNumberType.emptyFile;
    }

    for (var entry in _magicNumbers.entries) {
      if (_matches(bytes, entry.key)) {
        return entry.value;
      }
    }
    return MagicNumberType.unknown;
  }

  /// Checks if the given byte sequence matches a known magic number signature.
  static bool _matches(Uint8List bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (int i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }
}
