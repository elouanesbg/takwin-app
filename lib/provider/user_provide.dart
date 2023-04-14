import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:takwin/model/lesson_model.dart';

class UserData extends ChangeNotifier {
  // Name our hive box for this data
  final String _boxName = "userBox";

  List<Lesson> _favLesson = [];

  /// Gets all falv lesson from the hive box and loads them into our state List
  void getContacts() async {
    var box = await Hive.openBox<Lesson>(_boxName);

    // Update our provider state data with a hive read, and refresh the ui
    _favLesson = box.values.toList();
    notifyListeners();
  }

  Lesson getLesson(index) {
    return _favLesson[index];
  }

  /// Returns the length of the contact array
  int get favLessonCount {
    return _favLesson.length;
  }

  bool isFvLesson(String url) {
    return _favLesson.map((e) => e.url).contains(url);
  }

  void addLesson(Lesson newLesson) async {
    var box = await Hive.openBox<Lesson>(_boxName);

    await box.add(newLesson);

    _favLesson = box.values.toList();

    notifyListeners();
  }

  void deleteContact(key) async {
    var box = await Hive.openBox<Lesson>(_boxName);

    await box.delete(key);

    _favLesson = box.values.toList();

    notifyListeners();
  }

  // lesson sownload
  Set<String> downloadQueen = {};

  void addDownload(String url) {
    downloadQueen.add(url);
    notifyListeners();
  }

  void removeDownload(String url) {
    downloadQueen.remove(url);
    notifyListeners();
  }

  int getDownloadQueenSize() {
    return downloadQueen.length;
  }
}
