import 'package:takwin/model/lesson_model.dart';

class Subcategory {
  final String title;
  final String description;
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
