[![File Magic Number](https://github.com/vicajilau/file_magic_number/blob/main/.github/assets/file_magic_number.png)](https://pub.dev/packages/file_magic_number)
# File Magic Number
[![pub package](https://img.shields.io/pub/v/http.svg)](https://pub.dev/packages/file_magic_number)
![CI Status](https://github.com/vicajilau/file_magic_number/actions/workflows/dart_analyze_unit_test.yml/badge.svg)
[![codecov](https://codecov.io/gh/vicajilau/file_magic_number/graph/badge.svg?token=LS2Q5TKXKG)](https://codecov.io/gh/vicajilau/file_magic_number)

A Flutter package to detect file types based on their magic number instead of relying on MIME types. Works on Flutter for mobile, desktop, and web without requiring native code.

## 🚀 Features
- Detects file types using their magic number (signature bytes)
- Supports Flutter on Android, iOS, macOS, Windows, Linux, and Web
- No need for native plugins
- Lightweight and easy to extend with custom signatures

## 📌 Installation
Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  file_magic_number: latest_version
```

Then, run:
```sh
flutter pub get
```

## 🛠️ Usage

### Detect a file type from bytes
```dart
import 'package:file_magic_number/file_magic_number.dart';

void main() async {
  final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
  final fileType = MagicNumber.detectFileType(bytes);
  print(fileType);
}
```

### Detect a file type from file_picker
Integrating file_magic_number with [file_picker](https://pub.dev/packages/file_picker) allows you to easily detect the type of a file selected by the user without relying on MIME types. 
You can use file_picker to open the file dialog and then pass the file's bytes to [MagicNumber.detectFileType](https://github.com/vicajilau/file_magic_number/blob/main/lib/magic_number_type.dart) to identify its type. 
Here's how you can do it:
```dart
import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    final fileType = MagicNumber.detectFileType(result.files.single.bytes);
    print(fileType);
  }
}
```

## 🎯 Supported File Types
| File Type | Magic Number (Hex)      |
|-----------|-------------------------|
| ZIP       | 50 4B 03 04             |
| PDF       | 25 50 44 46             |
| PNG       | 89 50 4E 47 0D 0A 1A 0A |
| JPG       | FF D8 FF                |
| ELF       | 7F 45 4C 46             |
| BMP       | 42 4D                   |
| EXE       | 4D 5A                   |

## 📌 Contributing
Feel free to contribute by adding more file signatures or improving the implementation. Fork the repo and submit a PR!

## 📜 License
This project is licensed under the MIT License.