import 'package:takwin/model/subcategory_model.dart';

class Category {
  final String title;
  final List<Subcategory> subcategorys;

  Category({required this.title, required this.subcategorys});

  factory Category.fromJson(Map<String, dynamic> data) {
    final subcategorys = data["subcategorys"] as List;
    return Category(
        title: data["title"],
        subcategorys:
            subcategorys.map((e) => Subcategory.fromJson(e)).toList());
  }
  Map toJson() => {
        "title": title,
        "subcategorys": subcategorys.map((e) => e.toJson()).toList()
      };
}
