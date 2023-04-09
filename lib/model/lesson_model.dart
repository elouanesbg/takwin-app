import 'package:takwin/model/audio_files_model.dart';

class Lesson {
  final String title;
  final String url;
  final List<AudioFiles> audioFiles;
  Lesson({required this.title, required this.url, required this.audioFiles});

  factory Lesson.fromJson(Map<String, dynamic> data) {
    final audioFiles = data["audioFiles"] as List;
    return Lesson(
        title: data["title"],
        url: data["url"],
        audioFiles: audioFiles.map((e) => AudioFiles.fromJson(e)).toList());
  }
}
