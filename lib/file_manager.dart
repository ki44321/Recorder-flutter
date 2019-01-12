import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  static final _finalFile = _FinalFile();
  Future<bool> get existFinalFile async {
    return _finalFile.future.then((exists) => _finalFile.file != null);
  }

  String get finalFilePath {
    return _finalFile.path;
  }

  removeFinalFile() {
    _finalFile.remove();
  }
}

class _FinalFile {
  String path;
  File _file;
  Future future;

  _FinalFile() {
    try {
      future = getApplicationDocumentsDirectory().then((appDocDirectory) {
        path = appDocDirectory.path + '/' + "sound.m4a";
        _file = File(path);
      });
    } catch (e) {
      print(e);
    }
  }

  File get file {
    if (_file.existsSync()) {
      return _file;
    }

    return null;
  }

  remove() {
    file?.deleteSync();
  }
}
