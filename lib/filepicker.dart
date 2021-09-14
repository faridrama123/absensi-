import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as Io;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController();
  Future<Directory?>? _appDocumentsDirectory;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['pdf'],
      ))
          ?.files;

      final path = _paths!.map((e) => e.path).toList()[0].toString();
      final bytes = Io.File(path).readAsBytesSync();

      String img64 = base64Encode(bytes);
      print(img64.substring(0, 100));

      // Uint8List byteszz = base64.decode(img64);
      // String dir = (await getApplicationDocumentsDirectory()).path;
      // File file = File(
      //     "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
      // await file.writeAsBytes(byteszz);

      // print("file" + file.toString());

      final decodedBytes = base64Decode(img64);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      print("appDocPath " + appDocPath);

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      print("tempPath " + tempPath);

      Directory downloadsDirectory;

      downloadsDirectory = (await DownloadsPathProvider.downloadsDirectory)!;

      var file = Io.File(downloadsDirectory.path + "/hehehes.pdf");
      file.writeAsBytesSync(decodedBytes);
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles().then((result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    });
  }

  void _selectFolder() {
    FilePicker.platform.getDirectoryPath().then((value) {
      setState(() => _directoryPath = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: DropdownButton<FileType>(
                      hint: const Text('LOAD PATH FROM'),
                      value: _pickingType,
                      items: <DropdownMenuItem<FileType>>[
                        DropdownMenuItem(
                          child: const Text('FROM AUDIO'),
                          value: FileType.audio,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM IMAGE'),
                          value: FileType.image,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM VIDEO'),
                          value: FileType.video,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM MEDIA'),
                          value: FileType.media,
                        ),
                        DropdownMenuItem(
                          child: const Text('FROM ANY'),
                          value: FileType.any,
                        ),
                        DropdownMenuItem(
                          child: const Text('CUSTOM FORMAT'),
                          value: FileType.custom,
                        ),
                      ],
                      onChanged: (value) => setState(() {
                            _pickingType = value!;
                            if (_pickingType != FileType.custom) {
                              _controller.text = _extension = '';
                            }
                          })),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100.0),
                  child: _pickingType == FileType.custom
                      ? TextFormField(
                          maxLength: 15,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _controller,
                          decoration:
                              InputDecoration(labelText: 'File extension'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                        )
                      : const SizedBox(),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 200.0),
                  child: SwitchListTile.adaptive(
                    title:
                        Text('Pick multiple files', textAlign: TextAlign.right),
                    onChanged: (bool value) =>
                        setState(() => _multiPick = value),
                    value: _multiPick,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _openFileExplorer(),
                        child: const Text("Open file picker"),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectFolder(),
                        child: const Text("Pick folder"),
                      ),
                      ElevatedButton(
                        onPressed: () => _clearCachedFiles(),
                        child: const Text("Clear temporary files"),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: const CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath!),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                    itemCount:
                                        _paths != null && _paths!.isNotEmpty
                                            ? _paths!.length
                                            : 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final bool isMultiPath =
                                          _paths != null && _paths!.isNotEmpty;
                                      final String name = 'File $index: ' +
                                          (isMultiPath
                                              ? _paths!
                                                  .map((e) => e.name)
                                                  .toList()[index]
                                              : _fileName ?? '...');
                                      final path = _paths!
                                          .map((e) => e.path)
                                          .toList()[index]
                                          .toString();
                                      print("file :" + path);

                                      return ListTile(
                                        title: Text(
                                          name,
                                        ),
                                        subtitle: Text(path),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(),
                                  )),
                                )
                              : const SizedBox(),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
