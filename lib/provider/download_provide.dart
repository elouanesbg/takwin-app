import 'package:flutter/material.dart';
import 'package:takwin/model/lesson_model.dart';

class DownloadProvider extends ChangeNotifier {
  final Set<Lesson> _downloadQueen = {};

  Set<Lesson> getQueen() {
    return _downloadQueen;
  }

  Lesson geDownloadQueen(index) {
    return _downloadQueen.elementAt(index);
  }

  Lesson geDownloadQueenByUrl(url) {
    return _downloadQueen.firstWhere((element) => element.url == url);
  }

  /// Returns the length of the contact array
  int get downloadQueenCount {
    return _downloadQueen.length;
  }

  bool isInDownloadQueen(String url) {
    return _downloadQueen.map((e) => e.url).toList().contains(url);
  }

  void addDownload(Lesson task) async {
    _downloadQueen.add(task);
    notifyListeners();
  }

  void removeFromDownloadQueen(url) async {
    _downloadQueen.removeWhere((element) => element.url == url);
    notifyListeners();
  }
}
