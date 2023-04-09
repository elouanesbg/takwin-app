import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:takwin/model/main_category_model.dart';

class DataService {
  Future<List<MainCategory>> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response) as List;
    List<MainCategory> mainCategorys =
        data.map((e) => MainCategory.fromJson(e)).toList();

    return mainCategorys;
  }
}
