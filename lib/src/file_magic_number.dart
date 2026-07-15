import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';
import 'file_magic_number_type.dart';
import 'stream_extension.dart';

/// A utility class for detecting file types based on their content and extension.
class FileMagicNumber {
  static final MimeTypeResolver _resolver = MimeTypeResolver()
    // Register custom extensions
    ..addExtension('elf', 'application/x-elf')
    ..addExtension('sqlite', 'application/x-sqlite3')
    ..addExtension('tar', 'application/x-tar')
    ..addExtension('gz', 'application/gzip')
    ..addExtension('ogg', 'audio/ogg')
    ..addExtension('flac', 'audio/flac')

    // Register custom magic numbers (byte signatures)
    ..addMagicNumber([0x7F, 0x45, 0x4C, 0x46], 'application/x-elf')
    ..addMagicNumber(
        [0x53, 0x51, 0x4C, 0x69, 0x74, 0x65], 'application/x-sqlite3')
    ..addMagicNumber([0x75, 0x73, 0x74, 0x61, 0x72], 'application/x-tar')
    ..addMagicNumber([0x4D, 0x5A], 'application/x-msdownload')
    ..addMagicNumber([0x50, 0x4B, 0x03, 0x04], 'application/zip')
    ..addMagicNumber([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x00],
        'application/x-rar-compressed')
    ..addMagicNumber([0x52, 0x61, 0x72, 0x21, 0x1A, 0x07, 0x01, 0x00],
        'application/x-rar-compressed')
    ..addMagicNumber(
        [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C], 'application/x-7z-compressed')
    ..addMagicNumber([0x42, 0x4D], 'image/bmp')
    ..addMagicNumber(
        [0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x41, 0x56, 0x49, 0x20],
        'video/x-msvideo',
        mask: [0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF])
    ..addMagicNumber([0x1F, 0x8B], 'application/gzip')
    ..addMagicNumber([0x4F, 0x67, 0x67, 0x53], 'audio/ogg')
    ..addMagicNumber([0x66, 0x4C, 0x61, 0x43], 'audio/flac');

  static final Map<String, FileMagicNumberType> _customMimeMappings = {};

  /// Detects the file type from a byte array.
  ///
  /// - [bytes]: The byte data of the file.
  /// - Returns the detected file type, or `FileMagicNumberType.unknown` if not recognized.
  /// - Returns `FileMagicNumberType.emptyFile` if the byte array is empty or null.
  static FileMagicNumberType detectFileTypeFromBytes(Uint8List? bytes) {
    if (bytes == null || bytes.isEmpty) {
      return FileMagicNumberType.emptyFile;
    }

    final mime = _resolver.lookup('', headerBytes: bytes);
    final type = _mapMimeToType(mime);
    if (type != FileMagicNumberType.unknown) {
      return type;
    }

    // Special check for TAR at offset 257 since MimeTypeResolver only checks offset 0
    if (_matchAt(bytes, [0x75, 0x73, 0x74, 0x61, 0x72], 257)) {
      return FileMagicNumberType.tar;
    }

    return FileMagicNumberType.unknown;
  }

  /// Detects the file type from a byte array and/or path.
  ///
  /// - [pathOrBlob]: A string representing either a file path or a Blob URL.
  /// - Returns the detected file type.
  static Future<FileMagicNumberType> detectFileTypeFromPathOrBlob(
    String pathOrBlob,
  ) async {
    final file = XFile(pathOrBlob);
    Uint8List bytes;
    try {
      final magicMaxLength = _resolver.magicNumbersMaxLength;
      final readLength = magicMaxLength > 512 ? magicMaxLength : 512;
      final stream = file.openRead(0, readLength);
      final chunk = await stream.firstOrNull();
      bytes = chunk ?? Uint8List(0);
    } catch (_) {
      rethrow;
    }

    if (bytes.isEmpty) {
      return FileMagicNumberType.emptyFile;
    }
    final mime = _resolver.lookup(pathOrBlob, headerBytes: bytes);

    final typeFromMime = _mapMimeToType(mime);
    if (typeFromMime != FileMagicNumberType.unknown) {
      return typeFromMime;
    }

    return detectFileTypeFromBytes(bytes);
  }

  /// Registers a custom file type dynamic signature.
  ///
  /// - [extension]: The file extension (e.g., 'custom').
  /// - [mimeType]: The MIME type of the file (e.g., 'application/x-custom').
  /// - [magicNumber]: The magic byte signature of the file.
  /// - [type]: The mapped [FileMagicNumberType] (default: [FileMagicNumberType.unknown]).
  static void registerCustomType({
    required String extension,
    required String mimeType,
    required List<int> magicNumber,
    FileMagicNumberType type = FileMagicNumberType.unknown,
  }) {
    _resolver.addExtension(extension, mimeType);
    _resolver.addMagicNumber(magicNumber, mimeType);
    if (type != FileMagicNumberType.unknown) {
      _customMimeMappings[mimeType] = type;
    }
  }

  static bool _matchAt(Uint8List data, List<int> pattern, int offset) {
    if (offset + pattern.length > data.length) {
      return false;
    }
    for (int i = 0; i < pattern.length; i++) {
      if (data[offset + i] != pattern[i]) {
        return false;
      }
    }
    return true;
  }

  /// Asynchronously reads a file or blob from the given [pathOrBlob] and returns its content as a [Uint8List].
  ///
  /// [pathOrBlob]: A string representing either a file path or a Blob URL.
  ///
  /// Returns a [Future<Uint8List>] that resolves to the content of the file as a byte array.
  static Future<Uint8List> getBytesFromPathOrBlob(String pathOrBlob) async {
    final file = XFile(pathOrBlob);
    return await file.readAsBytes();
  }

  /// Maps a MIME string to the corresponding [FileMagicNumberType] enum value.
  static FileMagicNumberType _mapMimeToType(String? mime) {
    if (mime == null) {
      return FileMagicNumberType.unknown;
    }

    final customMapping = _customMimeMappings[mime];
    if (customMapping != null) {
      return customMapping;
    }

    switch (mime) {
      case 'application/gzip':
      case 'application/x-gzip':
        return FileMagicNumberType.gzip;
      case 'audio/ogg':
      case 'video/ogg':
      case 'application/ogg':
        return FileMagicNumberType.ogg;
      case 'audio/flac':
      case 'audio/x-flac':
        return FileMagicNumberType.flac;
      case 'application/pdf':
        return FileMagicNumberType.pdf;
      case 'application/zip':
        return FileMagicNumberType.zip;
      case 'application/x-rar-compressed':
      case 'application/x-rar':
        return FileMagicNumberType.rar;
      case 'application/x-7z-compressed':
        return FileMagicNumberType.sevenZ;
      case 'application/x-tar':
        return FileMagicNumberType.tar;
      case 'image/png':
        return FileMagicNumberType.png;
      case 'image/jpeg':
        return FileMagicNumberType.jpg;
      case 'image/gif':
        return FileMagicNumberType.gif;
      case 'image/tiff':
        return FileMagicNumberType.tiff;
      case 'image/bmp':
      case 'image/x-ms-bmp':
        return FileMagicNumberType.bmp;
      case 'image/heic':
      case 'image/heif':
        return FileMagicNumberType.heic;
      case 'image/webp':
        return FileMagicNumberType.webp;
      case 'audio/mpeg':
      case 'audio/mp3':
        return FileMagicNumberType.mp3;
      case 'audio/wav':
      case 'audio/x-wav':
      case 'audio/vnd.wave':
        return FileMagicNumberType.wav;
      case 'video/mp4':
        return FileMagicNumberType.mp4;
      case 'video/x-msvideo':
      case 'video/avi':
        return FileMagicNumberType.avi;
      case 'application/x-sqlite3':
      case 'application/vnd.sqlite3':
        return FileMagicNumberType.sqlite;
      case 'application/x-executable':
      case 'application/x-elf':
      case 'application/x-sharedlib':
        return FileMagicNumberType.elf;
      case 'application/x-msdownload':
      case 'application/pe-executable':
      case 'application/x-msdos-program':
        return FileMagicNumberType.exe;
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return FileMagicNumberType.docx;
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return FileMagicNumberType.xlsx;
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return FileMagicNumberType.pptx;
      case 'text/html':
        return FileMagicNumberType.html;
      case 'application/json':
        return FileMagicNumberType.json;
      case 'application/xml':
      case 'text/xml':
        return FileMagicNumberType.xml;
      case 'text/csv':
        return FileMagicNumberType.csv;
      case 'image/svg+xml':
        return FileMagicNumberType.svg;
      case 'text/plain':
        return FileMagicNumberType.txt;
      case 'application/rtf':
      case 'text/rtf':
        return FileMagicNumberType.rtf;
      case 'application/epub+zip':
        return FileMagicNumberType.epub;
      default:
        return FileMagicNumberType.unknown;
    }
  }
}
