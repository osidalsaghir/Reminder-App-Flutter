import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SaveDuc {
  Future<String> get _localPath async {
    final directory = (await getApplicationDocumentsDirectory()).path;

    return directory;
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;
      await file.delete();
      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/da.txt');
  }

  Future<List<String>> readCounter() async {
    try {
      final file = await _localFile;
      var contents = await file.readAsLines();
      return contents;
    } catch (e) {
      List<String> nds = [];
      return nds;
    }
  }

  Future<void> writeCounter(List<String> list) async {
    final file = await _localFile;

    for (String s in list) file.writeAsStringSync(s, mode: FileMode.append);
  }

  Future<void> writeFromScratch(List<String> list) async {
    await deleteFile();
    final file = await _localFile;
    print("what to write : " + list.toString());
    for (String s in list)
      file.writeAsStringSync(s + "\n", mode: FileMode.append);
  }
}
