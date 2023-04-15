import 'package:hive/hive.dart';
import 'package:takwin/model/lesson_model.dart';
part 'subcategory_model.g.dart';

@HiveType(typeId: 2)
class Subcategory extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final List<Lesson> lessons;

  Subcategory(
      {required this.title, required this.description, required this.lessons});

  factory Subcategory.fromJson(Map<String, dynamic> data) {
    final lessons = data["lessons"] as List;
    return Subcategory(
        title: data["title"],
        description: data["description"] ?? "",
        lessons: lessons.map((e) => Lesson.fromJson(e)).toList());
  }
  Map toJson() => {
        "title": title,
        "description": description,
        "lessons": lessons.map((e) => e.toJson()).toList()
      };
}
