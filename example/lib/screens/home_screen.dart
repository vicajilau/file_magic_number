import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../extensions/debug.dart';
import '../extensions/uint8list_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileMagicNumberType? _typeFile;
  String? _error;

  void _loadFileManually() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image,
    );
    if (result != null) {
      final bytes = result.files.single.bytes;
      final path = result.files.single.path;
      if (path != null) {
        await _loadPathType(bytes, path);
      }
    }
  }

  Future<void> _loadPathType(Uint8List? bytes, String path) async {
    final bytesType = FileMagicNumber.detectFileTypeFromBytes(bytes);
    final pathType = await FileMagicNumber.detectFileTypeFromPathOrBlob(path);
    bytes?.printInDebug(fileName: path);
    setState(() {
      if (bytesType == pathType) {
        _typeFile = bytesType;
        _error = null;
      } else {
        _typeFile = FileMagicNumberType.unknown;
        _error = "FILE TYPES DO NOT MATCH";
      }
      printInDebug("FileMagicNumberType using bytes is: $bytesType");
      printInDebug("FileMagicNumberType using path is: $pathType");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: DropTarget(
        onDragDone: (detail) async {
          final bytes = await FileMagicNumber.getBytesFromPathOrBlob(
            detail.files.single.path,
          );
          await _loadPathType(bytes, detail.files.single.path);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('The loaded file is of type:'),
              Text(
                _error ?? _typeFile?.name ?? "FILE NOT LOADED",
                style:
                    isError()
                        ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        )
                        : Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFileManually,
        tooltip: 'Load File',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool isError() => _error != null;
}
