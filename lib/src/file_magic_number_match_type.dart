import '../file_magic_number.dart';

/// Defines how a magic number should be matched within a file's byte sequence.
///
/// This enum is used internally by the library to determine whether a magic number
/// should be matched exactly at the beginning of the file (`exact`)
/// or if it can appear at any position within a predefined range (`offset`).
enum FileMagicNumberMatchType {
  exact,
  offset;

  /// Determines how the magic number should be matched for this file type.
  ///
  /// By default, file types are matched exactly at the beginning of the file (`exact`).
  /// However, some formats (such as MP4) allow their magic number to appear at an
  /// offset, so they are matched differently (`offset`).
  ///
  /// This method is used internally by the library during file type detection.
  static bool isExact(FileMagicNumberType type) {
    switch (type) {
      case FileMagicNumberType.mp4:
      case FileMagicNumberType.heic:
        return false;
      default:
        return true;
    }
  }
}
