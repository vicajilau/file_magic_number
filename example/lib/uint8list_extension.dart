import 'package:flutter/foundation.dart';

/// Extension on Uint8List to provide debugging utilities.
extension Uint8ListExtension on Uint8List {
  /// Prints the content of the Uint8List in debug mode.
  ///
  /// - If the list contains more than 10 bytes, only the first 10 bytes
  ///   are printed, followed by `...` to indicate truncation.
  /// - If the list contains 10 or fewer bytes, it prints the entire content.
  /// - This helps prevent excessive logging when dealing with large files.
  void printInDebug() {
    if (kDebugMode) {
      final int maxLength = 10;

      /// Extracts up to `maxLength` bytes for display.
      final displayBytes =
          length > maxLength ? '${sublist(0, maxLength)}...' : toString();

      print("Uint8List($length bytes. Bytes: $displayBytes)");
    }
  }
}
