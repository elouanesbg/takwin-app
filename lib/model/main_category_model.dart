import 'package:hive/hive.dart';
import 'package:takwin/model/category_model.dart';
part 'main_category_model.g.dart';

@HiveType(typeId: 0)
class MainCategory {
  @HiveField(0)
  final String title;
  @HiveField(1)
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
