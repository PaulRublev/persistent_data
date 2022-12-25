import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DataInteraction {
  late final Directory _appDocDir;
  late File _filenames;
  List<String> _imageNamesList = [];

  final Function setStateCallback;

  DataInteraction(this.setStateCallback) {
    _initialize();
  }

  List<String> get imageNamesList {
    return _imageNamesList;
  }

  Future<void> save(String filename) async {
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
    setStateCallback(() {});
  }

  void delete() async {
    for (var filePath in _imageNamesList) {
      File(filePath).delete();
    }
    await _filenames.delete();
    _imageNamesList = [];
    setStateCallback(() {});
  }
}
