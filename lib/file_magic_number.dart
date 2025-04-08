export 'src/file_magic_number.dart';
export 'src/file_magic_number_match_type.dart';
export 'src/file_magic_number_type.dart';
export 'src/reader/file_magic_number_reader_base.dart'
if (dart.library.io) 'src/reader/file_magic_number_reader_io.dart'
if (dart.library.html) 'src/reader/file_magic_number_reader_web.dart';