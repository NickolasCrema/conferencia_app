import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ipProvider with ChangeNotifier {
  String _serverIp;

  String getServerIp(){
    return _serverIp;
  }

  Future<String> get _getLocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _getLocalFile async {
    final path = await _getLocalPath;
    return File('$path/get.json');
  }

  Future<void> readCounter() async {
    try {
      final file = await _getLocalFile;

      final contents = await file.readAsString();

      _serverIp = contents;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> writeCounter(String ip) async {
    final file = await _getLocalFile;
    // Write the file
    file.writeAsString(ip);
    _serverIp = ip;
  }
}



