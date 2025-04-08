import 'dart:typed_data';

/// Extension for [Uint8List] providing utility functions.
extension Uint8ListUtils on Uint8List {
  /// Removes leading zeros from the [Uint8List].
  ///
  /// This method iterates through the bytes of the [Uint8List]
  /// to find the index of the first non-zero byte. If all bytes
  /// are zero, an empty [Uint8List] is returned. Otherwise, a new
  /// [Uint8List] is created that contains only the bytes from the
  /// first non-zero index to the end of the original list.
  ///
  /// Returns:
  /// A [Uint8List] with leading zeros removed.
  Uint8List removeLeadingZeros() {
    int firstNonZeroIndex = 0;

    // Iterate through the list to find the first non-zero byte
    while (firstNonZeroIndex < length && this[firstNonZeroIndex] == 0) {
      firstNonZeroIndex++;
    }

    // If all bytes are zero, return an empty Uint8List
    if (firstNonZeroIndex == length) {
      return Uint8List(0);
    }

    // Create a new Uint8List from the first non-zero index to the end
    return Uint8List.view(
        buffer, offsetInBytes + firstNonZeroIndex, length - firstNonZeroIndex);
  }
}
