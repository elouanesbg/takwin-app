import 'package:hive/hive.dart';
import 'package:takwin/model/audio_files_model.dart';
part 'lesson_model.g.dart';

@HiveType(typeId: 0)
class Lesson extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String url;
  @HiveField(2)
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
