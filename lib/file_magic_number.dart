export 'magic_number_stub.dart'
    if (dart.library.io) 'magic_number_native.dart'
    if (dart.library.html) 'magic_number_web.dart';
