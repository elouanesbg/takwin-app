import 'package:hive/hive.dart';
part 'audio_data_model.g.dart';

@HiveType(typeId: 0)
class AudioData extends HiveObject {
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
  @HiveField(6)
  final String mainCategoryTitle;
  @HiveField(7)
  final String categoryTitle;
  @HiveField(8)
  final String subcategoryTitle;
  @HiveField(9)
  final String subcategoryDescription;
  @HiveField(10)
  final String lessonTitle;
  @HiveField(11)
  bool? isFav = false;

  AudioData(
      {required this.name,
      required this.title,
      required this.length,
      required this.mainCategoryTitle,
      required this.categoryTitle,
      required this.subcategoryTitle,
      required this.subcategoryDescription,
      required this.lessonTitle,
      this.onlineUrl});

  factory AudioData.fromJson(Map<String, dynamic> data) {
    return AudioData(
      name: data["name"],
      title: data["title"],
      length: data["length"],
      mainCategoryTitle: data["mainCategoryTitle"],
      categoryTitle: data["categoryTitle"],
      subcategoryTitle: data["subcategoryTitle"],
      subcategoryDescription: data["subcategoryDescription"],
      lessonTitle: data["lessonTitle"],
    );
  }

  Map toJson() => {
        "name": name,
        "title": title,
        "length": length,
        "mainCategoryTitle": mainCategoryTitle,
      };

  @override
  int get hashCode => onlineUrl.hashCode;

  @override
  bool operator ==(Object other) {
    return onlineUrl == (other as AudioData).onlineUrl;
  }
}
