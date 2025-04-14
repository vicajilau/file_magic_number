/// Enum representing different file types based on their magic numbers.
///
/// Magic numbers are unique byte sequences at the beginning of a file
/// that help identify its format. This enum provides categorized file
/// types based on their signatures.
///
/// The `unknown` type is returned when the file type cannot be determined,
/// and `emptyFile` is used when the input is null or contains no data.
enum FileMagicNumberType {
  /// File type could not be determined from the magic number.
  unknown,

  /// The file is empty or null, making detection impossible.
  emptyFile,

  // Compressed files
  /// ZIP archive file format.
  zip,

  /// RAR archive file format.
  rar,

  /// 7z (7-Zip) archive file format.
  sevenZ,

  // Image formats
  /// PNG (Portable Network Graphics) image format.
  png,

  /// JPG (JPEG) image format.
  jpg,

  /// GIF (Graphics Interchange Format) image format.
  gif,

  /// TIFF (Tagged Image File Format) image format.
  tiff,

  /// BMP (Bitmap) image format.
  bmp,

  /// HEIC (High Efficiency Image Coding), part of the HEIF (High Efficiency Image File) format.
  /// Commonly used by Apple devices for photos.
  heic,

  // Audio and video formats
  /// MP3 (MPEG Audio Layer III) audio file format.
  mp3,

  /// WAV (Waveform Audio File Format).
  wav,

  /// MP4 (MPEG-4 Part 14) video file format.
  mp4,

  // Other formats
  /// PDF (Portable Document Format) file.
  pdf,

  /// ELF (Executable and Linkable Format) used for executables on Unix-like systems.
  elf,

  /// EXE (Windows Executable) file format.
  exe,

  /// TAR (Tape Archive) file format.
  tar,

  /// SQLite database file format.
  sqlite;
}
