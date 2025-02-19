<p align="center">
  <a href="https://pub.dev/packages/file_magic_number">
    <img src="https://raw.githubusercontent.com/vicajilau/file_magic_number/main/.github/assets/file_magic_number.png" height="200" alt="File Magic Number Logo">
  </a>
  <h1 align="center">File Magic Number</h1>
</p>

<p align="center">
  <a href="https://pub.dev/packages/file_magic_number">
    <img src="https://img.shields.io/pub/v/file_magic_number?label=pub.dev&labelColor=333940&logo=dart" alt="Pub Version">
  </a>
  <a href="https://github.com/vicajilau/file_magic_number/actions/workflows/dart_analyze_unit_test.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/vicajilau/file_magic_number/dart_analyze_unit_test.yml?branch=main&label=CI&labelColor=333940&logo=github" alt="CI Status">
  </a>
  <a href="https://github.com/vicajilau/pdf_combiner/actions/workflows/publish_pub_dev.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/vicajilau/file_magic_number/publish_pub_dev.yml?label=CD&labelColor=333940&logo=github" alt="CD Status">
  </a>
  <a href="https://codecov.io/gh/vicajilau/file_magic_number">
    <img src="https://img.shields.io/codecov/c/github/vicajilau/file_magic_number?logo=codecov&logoColor=fff&labelColor=333940" alt="Code Coverage">
  </a>
</p>

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

Then for Flutter, run:
```sh
flutter pub get
```

## 🛠️ Usage

### Detect a file type from bytes
```dart
import 'package:file_magic_number/file_magic_number.dart';

void main() async {
  final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
  final FileMagicNumberType fileType = FileMagicNumber.detectFileTypeFromBytes(bytes);
  print(fileType);
}
```

### Detect a file type from file_picker
Integrating file_magic_number with [file_picker](https://pub.dev/packages/file_picker) allows you to easily detect the type of a file selected by the user without relying on MIME types.
You can use file_picker to open the file dialog and then pass the file's bytes to [FileMagicNumber.detectFileTypeFromBytes](https://github.com/vicajilau/file_magic_number/blob/main/lib/file_magic_number_type.dart) to identify its type.
Here's how you can do it:
```dart
import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);

  if (result != null) {
    final FileMagicNumberType fileType = FileMagicNumber.detectFileTypeFromBytes(result.files.single.bytes!);
    print(fileType);
  }
}
```

## 🎯 Supported File Types
| File Type | Magic Number (Hex)        |
|-----------|---------------------------|
| ZIP       | 50 4B 03 04               |
| RAR       | 52 61 72 21 1A 07 00      |
| RAR       | 52 61 72 21 1A 07         |
| 7Z        | 37 7A BC AF 27 1C         |
| PDF       | 25 50 44 46               |
| PNG       | 89 50 4E 47 0D 0A 1A 0A   |
| JPG       | FF D8 FF                  |
| GIF       | 47 49 46 38               |
| TIFF      | 49 49 2A 00 / 4D 4D 00 2A |
| BMP       | 42 4D                     |
| MP3       | 49 44 33                  |
| WAV       | 52 49 46 46               |
| MP4       | 66 74 79 70               |
| ELF       | 7F 45 4C 46               |
| EXE       | 4D 5A                     |
| TAR       | 75 73 74 61 72            |
| SQLite    | 53 51 4C 69 74 65         |

## 📌 Contributing
Feel free to contribute by adding more file signatures or improving the implementation. Fork the repo and submit a PR!

## 📜 License
This project is licensed under the MIT License.