import 'package:hive/hive.dart';
part 'audio_metadata_model.g.dart';

@HiveType(typeId: 1)
class AudioMetadataModel extends HiveObject {
  @HiveField(0)
  String? mainCategoryTitle;
  @HiveField(1)
  String? categoryTitle;
  @HiveField(2)
  String? subCategoryTitle;
  @HiveField(3)
  String? lessonTitle;
  @HiveField(4)
  String? audioFileTitle;
  AudioMetadataModel({
    this.mainCategoryTitle,
    this.categoryTitle,
    this.subCategoryTitle,
    this.lessonTitle,
    this.audioFileTitle,
  });

  Map toJson() => {
        "mainCategoryTitle": mainCategoryTitle ?? "",
        "categoryTitle": categoryTitle ?? "",
        "subCategoryTitle": subCategoryTitle ?? "",
        "lessonTitle": lessonTitle ?? "",
        "audioFileTitle": audioFileTitle ?? ""
      };

  @override
  int get hashCode => ((mainCategoryTitle ?? '') +
          (categoryTitle ?? '') +
          (subCategoryTitle ?? '') +
          (lessonTitle ?? '') +
          (audioFileTitle ?? ''))
      .hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}
