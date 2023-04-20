import 'package:takwin/model/category_model.dart';

class MainCategory {
  final String title;
  final List<Category> categorys;

  MainCategory({required this.title, required this.categorys});

  factory MainCategory.fromJson(Map<String, dynamic> data) {
    final categorys = data["categorys"] as List;
    return MainCategory(
        title: data["title"],
        categorys: categorys.map((e) => Category.fromJson(e)).toList());
  }

  Map toJson() =>
      {"title": title, "categorys": categorys.map((e) => e.toJson()).toList()};
}
