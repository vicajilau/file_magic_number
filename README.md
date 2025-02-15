# File Magic Number
[![pub package](https://img.shields.io/pub/v/http.svg)](https://pub.dev/packages/file_magic_number))
![CI Status](https://github.com/vicajilau/file_magic_number/actions/workflows/dart_analyze_unit_test.yml/badge.svg)
A Dart package to detect file types based on their magic number instead of relying on MIME types. Works on Flutter for mobile, desktop, and web without requiring native code.

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
dart pub get
```

## 🛠️ Usage

### Detect a file type from a local file (mobile & desktop)
```dart
import 'package:file_magic_number/file_magic_number.dart';

void main() async {
  String? fileType = await MagicNumber.detectFileType('/path/to/file');
  print(fileType ?? 'Unknown file type');
}
```

### Detect a file type in Flutter Web
```dart
import 'dart:html' as html;
import 'package:file_magic_number/file_magic_number.dart';

void pickFile() {
  final input = html.FileUploadInputElement()..accept = '*/*';
  input.click();
  input.onChange.listen((_) async {
    final file = input.files?.first;
    if (file != null) {
      String? fileType = await MagicNumber.detectFileType(file);
      print(fileType ?? 'Unknown file type');
    }
  });
}
```

## 🎯 Supported File Types
| File Type | Magic Number (Hex) |
|-----------|--------------------|
| ZIP       | 50 4B 03 04        |
| PDF       | 25 50 44 46        |
| PNG       | 89 50 4E 47 0D 0A 1A 0A |
| JPG       | FF D8 FF           |
| ELF       | 7F 45 4C 46        |
| BMP       | 42 4D              |
| EXE       | 4D 5A              |

## 📌 Contributing
Feel free to contribute by adding more file signatures or improving the implementation. Fork the repo and submit a PR!

## 📜 License
This project is licensed under the MIT License.

