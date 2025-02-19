import 'dart:io';
import 'dart:typed_data';

/// An extension on the [File] class to add custom functionalities.
extension FileExtension on File {
  /// Writes a list of bytes to the file.
  ///
  /// This method converts the provided list of integers into a [Uint8List]
  /// and writes it to the file asynchronously.
  ///
  /// [bytes] - A list of integers representing the byte data to be written to the file.
  void writeToFile(List<int> bytes) async {
    await writeAsBytes(Uint8List.fromList(bytes));
  }
}
