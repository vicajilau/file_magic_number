import 'dart:typed_data';

import 'package:file_magic_number/magic_number_type.dart';

import 'magic_number_match_type.dart';

/// A utility class for detecting file types based on their magic numbers.
///
/// Magic numbers are specific byte sequences at the beginning of a file
/// that indicate its format. This approach is more reliable than using MIME types.
class MagicNumber {
  /// A map of known magic number signatures associated with file types.
  static const Map<List<int>, MagicNumberType> _magicNumbers = {
    // Compressed files
    [0x50, 0x4B, 0x03, 0x04]: MagicNumberType.zip,
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00]: MagicNumberType.rar,
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]: MagicNumberType.rar,
    [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]: MagicNumberType.sevenZ,

    // Images
    [0x89, 0x50, 0x4E, 0x47]: MagicNumberType.png,
    [0xFF, 0xD8, 0xFF]: MagicNumberType.jpg,
    [0x47, 0x49, 0x46, 0x38]: MagicNumberType.gif,
    [0x49, 0x49, 0x2A, 0x00]: MagicNumberType.tiff,
    [0x4D, 0x4D, 0x00, 0x2A]: MagicNumberType.tiff,
    [0x42, 0x4D]: MagicNumberType.bmp,

    // Audio & Video
    [0x49, 0x44, 0x33]: MagicNumberType.mp3,
    [0x52, 0x49, 0x46, 0x46]: MagicNumberType.wav,
    [0x66, 0x74, 0x79, 0x70]: MagicNumberType.mp4,

    // Other formats
    [0x25, 0x50, 0x44, 0x46]: MagicNumberType.pdf,
    [0x7F, 0x45, 0x4C, 0x46]: MagicNumberType.elf,
    [0x4D, 0x5A]: MagicNumberType.exe,
    [0x75, 0x73, 0x74, 0x61, 0x72]: MagicNumberType.tar,
    [0x53, 0x51, 0x4C, 0x69, 0x74, 0x65]: MagicNumberType.sqlite,
  };

  /// The length of the longest known magic number signature, doubled.
  static final int _maxSignatureLength =
      _magicNumbers.keys.map((e) => e.length).reduce((a, b) => a > b ? a : b) *
      2;

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

    // Only check the first `_maxSignatureLength` bytes to avoid unnecessary processing.
    final Uint8List limitedBytes =
        bytes.length > _maxSignatureLength
            ? bytes.sublist(0, _maxSignatureLength)
            : bytes;

    for (var entry in _magicNumbers.entries) {
      if (entry.value.matchType == MagicNumberMatchType.exact) {
        if (_matchesExact(limitedBytes, entry.key)) {
          return entry.value;
        }
      } else {
        if (_matchesWithOffset(limitedBytes, entry.key)) {
          return entry.value;
        }
      }
    }
    return MagicNumberType.unknown;
  }

  /// Checks if the given byte sequence matches a known magic number signature exactly.
  static bool _matchesExact(Uint8List bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (int i = 0; i < signature.length; i++) {
      if (bytes[i] != signature[i]) return false;
    }
    return true;
  }

  /// Checks if the given byte sequence contains the magic number signature at any offset.
  static bool _matchesWithOffset(Uint8List bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (int i = 0; i <= bytes.length - signature.length; i++) {
      if (signature.asMap().entries.every(
        (entry) => bytes[i + entry.key] == entry.value,
      )) {
        return true;
      }
    }
    return false;
  }
}
