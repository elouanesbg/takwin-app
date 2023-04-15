import 'package:hive/hive.dart';
part 'audio_files_model.g.dart';

@HiveType(typeId: 4)
class AudioFiles extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String length;
  @HiveField(3)
  String? onlineUrl = "";
  @HiveField(4)
  bool? isAvilableOffline = false;
  @HiveField(5)
  String? offlineFilePath = "";

  AudioFiles(
      {required this.name,
      required this.title,
      required this.length,
      this.onlineUrl});

  factory AudioFiles.fromJson(Map<String, dynamic> data) {
    return AudioFiles(
        name: data["name"], title: data["title"], length: data["length"]);
  }

  Map toJson() => {"name": name, "title": title, "length": length};
}
