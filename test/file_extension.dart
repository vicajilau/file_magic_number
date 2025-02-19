import 'dart:io';
import 'dart:typed_data';

extension FileExtension on File {
  void writeToFile(List<int> bytes) async {
    await writeAsBytes(Uint8List.fromList(bytes));
  }
}
