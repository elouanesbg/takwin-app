import 'package:hive/hive.dart';
import 'package:takwin/model/subcategory_model.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String title;
  @HiveField(1)
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
