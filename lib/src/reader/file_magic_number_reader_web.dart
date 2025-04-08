import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart';

/// Platform-specific implementation of `FileMagicNumberReader` for Web.
///
/// This class reads binary data from a Blob URL using JavaScript interop.
class FileMagicNumberReader {
  /// Reads the binary data of a file from a Blob URL.
  ///
  /// This method fetches the file using the browser's `fetch` API and processes it as a Blob.
  ///
  /// - [path]: The Blob URL of the file to read.
  /// - Returns: A `Uint8List` containing the binary content of the file.
  /// - Throws: An `Exception` if there is an error fetching or reading the file.
  Future<Uint8List> readFile(String path) async {
    try {
      // Fetch the Blob from the URL.
      final response = await window.fetch(path.toJS).toDart;
      final blob = await response.blob().toDart;

      // Create a FileReader to read the Blob's content.
      final reader = FileReader();
      final completer = Completer<Uint8List>();

      // Set up a listener for when the reading is complete.
      reader.onLoadEnd.listen((event) {
        if (reader.error != null) {
          completer.completeError('Error reading the blob: ${reader.error}');
        } else {
          ByteBuffer? byteBuffer = (reader.result as JSArrayBuffer?)?.toDart;
          completer.complete(byteBuffer?.asUint8List());
        }
      });

      // Read the Blob as an ArrayBuffer.
      reader.readAsArrayBuffer(blob);

      // Return the result as a Future<Uint8List>.
      return await completer.future;
    } catch (e) {
      throw Exception('Error reading the file: $e');
    }
  }
}
