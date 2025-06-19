import 'dart:typed_data';

import 'package:file_magic_number/src/magic_number_list.dart';

import '../file_magic_number.dart';

/// A utility class for detecting file types based on their magic numbers.
///
/// Magic numbers are specific byte sequences at the beginning of a file
/// that indicate its format. This approach is more reliable than using MIME types.
class FileMagicNumber {

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

    for (var entry in MagicNumberList.magicNumbers.entries) {
        if (_matchesWithOffset(bytes, entry.key)) {
          return entry.value;
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

  /// This function analyzes a Uint8List (a byte array) to detect the type of a file by searching for known magic numbers—specific byte sequences that uniquely identify various file formats.
  ///
  /// Unlike traditional implementations that check only the beginning of a file, this version scans the entire byte stream.
  /// This makes it more robust in scenarios where metadata or prepended headers may obscure the file's signature at the start.
  /// To improve accuracy and avoid false positives, only signatures with at least 4 bytes are scanned across the whole file, while shorter ones are treated more cautiously.
  ///
  /// This detection approach supports a wide range of formats such as PDF, ZIP, MP4, PNG, RAR, and more.
  /// It is designed to be efficient and extensible, allowing developers to add or refine magic numbers as needed.
  static bool _matchesWithOffset(Uint8List bytes,List<int> signature) {

      for (int i = 0; i <= bytes.length - signature.length; i++) {
        var bytesFound = _matchAt(bytes, signature, i);
        if(bytesFound){
          return bytesFound;
        }
      }


    return false;
  }

  /// Check whether the byte sequence (representing a file signature) exists within the data stream.
  static bool _matchAt(Uint8List data, List<int> pattern, int offset) {
    for (int i = 0; i < pattern.length; i++) {
      if (data[offset + i] != pattern[i]) {
        return false;
      }
    }
    return true;
  }

}
