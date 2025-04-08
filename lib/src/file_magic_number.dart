import 'dart:typed_data';

import '../file_magic_number.dart';

/// A utility class for detecting file types based on their magic numbers.
///
/// Magic numbers are specific byte sequences at the beginning of a file
/// that indicate its format. This approach is more reliable than using MIME types.
class FileMagicNumber {
  /// A map of known magic number signatures associated with file types.
  static const Map<List<int>, FileMagicNumberType> _magicNumbers = {
    // Compressed files
    [0x50, 0x4B, 0x03, 0x04]: FileMagicNumberType.zip,
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00]: FileMagicNumberType.rar,
    [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07]: FileMagicNumberType.rar,
    [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C]: FileMagicNumberType.sevenZ,

    // Images
    [0x89, 0x50, 0x4E, 0x47]: FileMagicNumberType.png,
    [0xFF, 0xD8, 0xFF]: FileMagicNumberType.jpg,
    [0x47, 0x49, 0x46, 0x38]: FileMagicNumberType.gif,
    [0x49, 0x49, 0x2A, 0x00]: FileMagicNumberType.tiff,
    [0x4D, 0x4D, 0x00, 0x2A]: FileMagicNumberType.tiff,
    [0x42, 0x4D]: FileMagicNumberType.bmp,
    [0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63]: FileMagicNumberType.heic,

    // Audio & Video
    [0x49, 0x44, 0x33]: FileMagicNumberType.mp3,
    [0x52, 0x49, 0x46, 0x46]: FileMagicNumberType.wav,
    [0x66, 0x74, 0x79, 0x70]: FileMagicNumberType.mp4,

    // Other formats
    [0x25, 0x50, 0x44, 0x46]: FileMagicNumberType.pdf,
    [0x7F, 0x45, 0x4C, 0x46]: FileMagicNumberType.elf,
    [0x4D, 0x5A]: FileMagicNumberType.exe,
    [0x75, 0x73, 0x74, 0x61, 0x72]: FileMagicNumberType.tar,
    [0x53, 0x51, 0x4C, 0x69, 0x74, 0x65]: FileMagicNumberType.sqlite,
  };

  /// The length of the longest known magic number signature, doubled.
  static final int _maxSignatureLength = 8;

  /// Detects the file type from a byte array using its magic number.
  ///
  /// - [bytes]: The byte data of the file.
  /// - Returns the detected file type, or `FileMagicNumberType.unknown` if not recognized.
  /// - Returns `FileMagicNumberType.emptyFile` if the byte array is empty.
  ///
  /// Example usage:
  /// ```dart
  /// Uint8List fileBytes = await someMethodToGetBytes();
  /// FileMagicNumberType fileType = MagicNumber.detectFileType(fileBytes);
  /// print(fileType); // Output: FileMagicNumberType.png, FileMagicNumberType.pdf, etc.
  /// ```
  static FileMagicNumberType detectFileTypeFromBytes(Uint8List? bytes) {
    if (bytes == null || bytes.isEmpty) {
      return FileMagicNumberType.emptyFile;
    }

    // Only check the first `_maxSignatureLength` bytes to avoid unnecessary processing.
    final Uint8List limitedBytes = bytes.length > _maxSignatureLength
        ? bytes.sublist(0, _maxSignatureLength)
        : bytes;

    for (var entry in _magicNumbers.entries) {
      if (entry.value.matchType == FileMagicNumberMatchType.exact) {
        if (_matchesExact(limitedBytes, entry.key)) {
          return entry.value;
        }
      } else {
        if (_matchesWithOffset(limitedBytes, entry.key)) {
          return entry.value;
        }
      }
    }
    return FileMagicNumberType.unknown;
  }

  /// Detects the file type from a byte array using its magic number.
  ///
  /// - [bytes]: The byte data of the file.
  /// - Returns the detected file type, or `FileMagicNumberType.unknown` if not recognized.
  /// - Returns `FileMagicNumberType.emptyFile` if the byte array is empty.
  ///
  /// Example usage:
  /// ```dart
  /// Uint8List fileBytes = await someMethodToGetBytes();
  /// FileMagicNumberType fileType = MagicNumber.detectFileType(fileBytes);
  /// print(fileType); // Output: FileMagicNumberType.png, FileMagicNumberType.pdf, etc.
  /// ```
  static Future<FileMagicNumberType> detectFileTypeFromPathOrBlob(
    String pathOrBlob,
  ) async {
    final reader = FileMagicNumberReader();
    final bytes = await reader.readFile(pathOrBlob);
    return detectFileTypeFromBytes(bytes);
  }

  /// Asynchronously reads a file or blob from the given [pathOrBlob] and returns its content as a [Uint8List].
  ///
  /// This method uses the [FileMagicNumberReader] to read the file or blob based on the provided input.
  /// It handles both file paths and Blob URLs, ensuring that the file content is returned as a byte array.
  ///
  /// [pathOrBlob]: A string representing either a file path or a Blob URL.
  ///
  /// Returns a [Future<Uint8List>] that resolves to the content of the file as a byte array.
  static Future<Uint8List> getBytesFromPathOrBlob(String pathOrBlob) async {
    final reader = FileMagicNumberReader();
    return await reader.readFile(pathOrBlob);
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
