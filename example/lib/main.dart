import 'package:example/debug.dart';
import 'package:example/uint8list_extension.dart';
import 'package:file_magic_number/file_magic_number.dart';
import 'package:file_magic_number/file_magic_number_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Magic Number',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter File Magic Number Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FileMagicNumberType? _typeFile;
  String? _error;

  void _loadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
    );
    if (result != null) {
      final bytes = result.files.single.bytes;
      bytes?.printInDebug(fileName: result.files.single.name);
      final bytesType = FileMagicNumber.detectFileTypeFromBytes(bytes);
      final pathType = await FileMagicNumber.detectFileTypeFromPathOrBlob(
        result.files.single.path!,
      );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('The loaded file is of type:'),
            Text(
              _error ?? _typeFile?.name ?? "FILE NOT LOADED",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFile,
        tooltip: 'Load File',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
