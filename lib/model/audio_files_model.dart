import 'package:hive/hive.dart';
part 'audio_files_model.g.dart';

@HiveType(typeId: 1)
class AudioFiles extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String length;

  AudioFiles({required this.name, required this.title, required this.length});

  factory AudioFiles.fromJson(Map<String, dynamic> data) {
    return AudioFiles(
        name: data["name"], title: data["title"], length: data["length"]);
  }
}
