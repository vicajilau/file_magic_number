export 'package:file_magic_number/reader/file_magic_number_reader_base.dart'
    if (dart.library.io) 'package:file_magic_number/reader/file_magic_number_reader_io.dart'
    if (dart.library.html) 'package:file_magic_number/reader/file_magic_number_reader_web.dart';
