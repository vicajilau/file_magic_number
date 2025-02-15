import 'magic_number_type.dart';

class MagicNumberBase {
  /// A map of known magic number signatures associated with file types.
  static const Map<List<int>, MagicNumberType> magicNumbers = {
    [0x50, 0x4B, 0x03, 0x04]: MagicNumberType.zip,
    [0x25, 0x50, 0x44, 0x46]: MagicNumberType.pdf,
    [0x89, 0x50, 0x4E, 0x47]: MagicNumberType.png,
    [0xFF, 0xD8, 0xFF]: MagicNumberType.jpg,
    [0x7F, 0x45, 0x4C, 0x46]: MagicNumberType.elf,
    [0x42, 0x4D]: MagicNumberType.bmp,
    [0x4D, 0x5A]: MagicNumberType.exe,
  };
}