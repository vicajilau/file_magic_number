export 'magic_number_stub.dart'
    if (dart.library.io) 'file_magic_number_native.dart'
    if (dart.library.html) 'file_magic_number_web.dart';
