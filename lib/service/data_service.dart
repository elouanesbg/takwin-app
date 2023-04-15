import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwin/model/main_category_model.dart';

class DataService {
  Future<List<MainCategory>> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response) as List;
    List<MainCategory> mainCategorys =
        data.map((e) => MainCategory.fromJson(e)).toList();

    return mainCategorys;
  }

  getData() async {
    log("getData");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDataSetup = prefs.getBool("isDataSetup") ?? false;
    if (!isDataSetup) {
      List<MainCategory> data = await DataService().readJson();
      for (var element in data) {
        for (var element in element.categorys) {
          for (var element in element.subcategorys) {
            element.lessons
                .removeWhere((element) => element.audioFiles.isEmpty);
          }
        }
      }
      for (var element in data) {
        for (var element in element.categorys) {
          element.subcategorys
              .removeWhere((element) => element.lessons.isEmpty);
        }
      }
      for (var element in data) {
        element.categorys
            .removeWhere((element) => element.subcategorys.isEmpty);
      }

      var box = await Hive.openBox<MainCategory>('takwinData');
      for (MainCategory element in data) {
        box.put(element.title, element);
      }

      prefs.setBool("isDataSetup", true);
    }

    await Hive.openBox<MainCategory>('takwinData');
  }
}
