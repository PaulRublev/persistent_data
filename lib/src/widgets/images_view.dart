import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImagesView extends StatefulWidget {
  const ImagesView({super.key});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  final _editingController =
      TextEditingController(text: 'https://i.postimg.cc/1tf6qqQP/grozny.jpg');
  late final Directory _appDocDir;
  late File _filenames;
  List<String> _imageNamesList = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _save(String filename) async {
    var name =
        '${_appDocDir.path}/${_imageNamesList.length}.${filename.split('.').last}';
    _imageNamesList.add(name);
    var filenamesString = _imageNamesList.join(' ');
    _filenames.writeAsString(filenamesString);
    var imageFile = File(name);
    await imageFile.create();

    final http.Response responseData = await http.get(Uri.parse(filename));
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    await imageFile.writeAsBytes(buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));
  }

  void _initialize() async {
    _appDocDir = await getApplicationDocumentsDirectory();
    _filenames = File('${_appDocDir.path}/filenames.txt');
    if (!await _filenames.exists()) {
      await _filenames.create();
    } else {
      var filenamesString = await _filenames.readAsString();
      if (filenamesString.isNotEmpty) {
        _imageNamesList = filenamesString.split(' ');
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              for (var filePath in _imageNamesList) {
                File(filePath).delete();
              }
              await _filenames.delete();
              _imageNamesList = [];
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _imageNamesList.isNotEmpty
                ? ListView.builder(
                    itemCount: _imageNamesList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.blueAccent,
                        height: 200,
                        child: Image.file(
                          File(_imageNamesList[index]),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                        Text(
                          'No saved images',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
          ),
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextField(
                    controller: _editingController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _save(_editingController.value.text);
                    setState(() {});
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
