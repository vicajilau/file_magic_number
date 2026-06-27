import 'dart:math' as math;
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
  final List<ProcessedFile> _processedFiles = [];
  bool _isLoading = false;

  void _loadFileManually(FileType type) async {
    final result = await FilePicker.pickFiles(type: type);

    if (result != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        for (var file in result.files) {
          final bytes = await file.readAsBytes();
          final path = file.path ?? file.name;
          final name = file.name;
          final size = file.size;

          final processed = await _processFile(
            bytes: bytes,
            path: path,
            name: name,
            size: size,
          );

          setState(() {
            _processedFiles.add(processed);
          });
        }
      } catch (e) {
        printInDebug("Error picking files: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<ProcessedFile> _processFile({
    required Uint8List bytes,
    required String path,
    required String name,
    required int size,
  }) async {
    final bytesType = FileMagicNumber.detectFileTypeFromBytes(bytes);
    FileMagicNumberType pathType;
    try {
      pathType = await FileMagicNumber.detectFileTypeFromPathOrBlob(path);
    } catch (e) {
      printInDebug("Error detecting path type for $name: $e");
      pathType = FileMagicNumberType.unknown;
    }

    bytes.printInDebug(fileName: name);
    printInDebug("FileMagicNumberType using bytes is: $bytesType");
    printInDebug("FileMagicNumberType using path is: $pathType");

    return ProcessedFile(
      name: name,
      path: path,
      size: size,
      bytesType: bytesType,
      pathType: pathType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions:
            _processedFiles.isNotEmpty
                ? [
                  IconButton(
                    tooltip: 'Clear list',
                    icon: const Icon(Icons.restart_alt),
                    onPressed: () {
                      setState(() {
                        _processedFiles.clear();
                      });
                    },
                  ),
                ]
                : null,
      ),
      body: DropTarget(
        onDragDone: (detail) async {
          setState(() {
            _isLoading = true;
          });
          try {
            for (var file in detail.files) {
              final bytes = await file.readAsBytes();
              final path = file.path;
              final name = file.name;
              final size = await file.length();

              final processed = await _processFile(
                bytes: bytes,
                path: path,
                name: name,
                size: size,
              );

              setState(() {
                _processedFiles.add(processed);
              });
            }
          } catch (e) {
            printInDebug("Error dropping files: $e");
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Stack(
          children: [
            if (_processedFiles.isEmpty)
              _buildEmptyState()
            else
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: _processedFiles.length,
                itemBuilder: (context, index) {
                  return _buildFileItem(_processedFiles[index]);
                },
              ),
            if (_isLoading)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _loadFileManually(FileType.image),
        tooltip: 'Load Images',
        child: const Icon(Icons.image),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24.0),
        padding: const EdgeInsets.all(32.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_file_outlined,
              size: 80.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'No documents loaded',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Drag & drop files here or click the button below to browse files.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: () => _loadFileManually(FileType.any),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Select Files'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(ProcessedFile file) {
    final isMatch = file.isMatch;

    IconData fileIcon;
    Color iconColor;

    switch (file.bytesType) {
      case FileMagicNumberType.pdf:
        fileIcon = Icons.picture_as_pdf;
        iconColor = Colors.red.shade700;
        break;
      case FileMagicNumberType.png:
      case FileMagicNumberType.jpg:
      case FileMagicNumberType.gif:
      case FileMagicNumberType.tiff:
      case FileMagicNumberType.bmp:
      case FileMagicNumberType.heic:
      case FileMagicNumberType.webp:
        fileIcon = Icons.image;
        iconColor = Colors.blue.shade700;
        break;
      case FileMagicNumberType.zip:
      case FileMagicNumberType.rar:
      case FileMagicNumberType.sevenZ:
      case FileMagicNumberType.tar:
        fileIcon = Icons.archive;
        iconColor = Colors.amber.shade800;
        break;
      case FileMagicNumberType.mp3:
      case FileMagicNumberType.wav:
        fileIcon = Icons.audiotrack;
        iconColor = Colors.purple.shade700;
        break;
      case FileMagicNumberType.mp4:
      case FileMagicNumberType.avi:
        fileIcon = Icons.movie;
        iconColor = Colors.teal.shade700;
        break;
      case FileMagicNumberType.sqlite:
        fileIcon = Icons.storage;
        iconColor = Colors.indigo.shade700;
        break;
      case FileMagicNumberType.exe:
      case FileMagicNumberType.elf:
        fileIcon = Icons.settings_applications;
        iconColor = Colors.grey.shade800;
        break;
      case FileMagicNumberType.unknown:
      case FileMagicNumberType.emptyFile:
        fileIcon = Icons.insert_drive_file;
        iconColor = Colors.grey.shade600;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(fileIcon, color: iconColor, size: 28.0),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    file.path,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    file.formattedSize,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      _buildBadge(
                        label: 'Bytes: ${file.bytesType.name.toUpperCase()}',
                        backgroundColor:
                            isMatch
                                ? Colors.green.shade50
                                : Colors.orange.shade50,
                        textColor:
                            isMatch
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                      ),
                      _buildBadge(
                        label: 'Path: ${file.pathType.name.toUpperCase()}',
                        backgroundColor:
                            isMatch ? Colors.green.shade50 : Colors.red.shade50,
                        textColor:
                            isMatch
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                      ),
                    ],
                  ),
                  if (!isMatch) ...[
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 16.0,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            'Mismatched format detection!',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _processedFiles.remove(file);
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                Icon(
                  isMatch ? Icons.check_circle : Icons.error,
                  color: isMatch ? Colors.green : Colors.red,
                  size: 20.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProcessedFile {
  final String name;
  final String path;
  final int size;
  final FileMagicNumberType bytesType;
  final FileMagicNumberType pathType;

  ProcessedFile({
    required this.name,
    required this.path,
    required this.size,
    required this.bytesType,
    required this.pathType,
  });

  bool get isMatch => bytesType == pathType;

  String get formattedSize {
    if (size <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (math.log(size) / math.log(1024)).floor();
    return '${(size / math.pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }
}
