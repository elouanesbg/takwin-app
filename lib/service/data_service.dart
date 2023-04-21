import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/model/audio_files_model.dart';
import 'package:takwin/model/category_model.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/model/subcategory_model.dart';

class DataService {
  Future<List<MainCategory>> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response) as List;
    List<MainCategory> mainCategorys =
        data.map((e) => MainCategory.fromJson(e)).toList();

    return mainCategorys;
  }

  setupUserData() async {}

  getData() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AudioDataAdapter());
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDataSetup = prefs.getBool("isDataSetup") ?? false;
    if (!isDataSetup) {
      List<MainCategory> data = await DataService().readJson();
      for (var element in data) {
        for (var element in element.categorys) {
          for (var element in element.subcategorys) {
            element.lessons
                .removeWhere((element) => element.audioFiles.isEmpty);
            for (var element in element.lessons) {
              var url = element.url;
              for (var element in element.audioFiles) {
                element.onlineUrl = "$url/${element.name}";
              }
            }
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

      for (MainCategory mainCategory in data) {
        final String mainCategoryTitle = mainCategory.title;
        for (Category category in mainCategory.categorys) {
          final String categoryTitle = category.title;
          for (Subcategory subcategory in category.subcategorys) {
            final String subcategoryTitle = subcategory.title;
            final String subcategoryDescription = subcategory.description;
            for (Lesson lesson in subcategory.lessons) {
              final String lessonTitle = lesson.title;
              for (AudioFiles audioFiles in lesson.audioFiles) {
                AudioData audioFile = AudioData(
                  name: audioFiles.name,
                  title: audioFiles.title,
                  length: audioFiles.length,
                  mainCategoryTitle: mainCategoryTitle,
                  categoryTitle: categoryTitle,
                  subcategoryTitle: subcategoryTitle,
                  subcategoryDescription: subcategoryDescription,
                  lessonTitle: lessonTitle,
                  onlineUrl: audioFiles.onlineUrl,
                );
                await Hive.box<AudioData>('takwinData')
                    .put(audioFile.onlineUrl, audioFile);
              }
            }
          }
        }
      }

      prefs.setBool("isDataSetup", true);
    }
  }

  Set<String> getMainCategory() {
    return Hive.box<AudioData>('takwinData')
        .values
        .map((e) => e.mainCategoryTitle)
        .toSet();
  }

  Set<String> getCategory(String mainCategory) {
    return Hive.box<AudioData>('takwinData')
        .values
        .where((element) => element.mainCategoryTitle == mainCategory)
        .map((e) => e.categoryTitle)
        .toSet();
  }

  Set<String> getSubCategory(String mainCategory, String category) {
    return Hive.box<AudioData>('takwinData')
        .values
        .where((element) =>
            element.mainCategoryTitle == mainCategory &&
            element.categoryTitle == category)
        .map((e) => e.subcategoryTitle)
        .toSet();
  }

  Set<String> getLesson(
      String mainCategory, String category, String subCategory) {
    return Hive.box<AudioData>('takwinData')
        .values
        .where((element) =>
            element.mainCategoryTitle == mainCategory &&
            element.categoryTitle == category &&
            element.subcategoryTitle == subCategory)
        .map((e) => e.lessonTitle)
        .toSet();
  }

  List<AudioData> getAudioFiles(
      String mainCategory, String category, String subCategory, String lesson) {
    var data = Hive.box<AudioData>('takwinData')
        .values
        .where((element) =>
            element.mainCategoryTitle == mainCategory &&
            element.categoryTitle == category &&
            element.subcategoryTitle == subCategory &&
            element.lessonTitle == lesson)
        .toList();
    return data;
  }

  AudioData getAudioFileFromUrl(String? url) {
    return Hive.box<AudioData>('takwinData')
        .values
        .firstWhere((element) => element.onlineUrl == url);
  }

  void updateAudioFileToOffline(String url, String path) async {
    var data = Hive.box<AudioData>('takwinData')
        .values
        .firstWhere((element) => element.onlineUrl == url);
    data.isAvilableOffline = true;
    data.offlineFilePath = path;
    await Hive.box<AudioData>('takwinData').put(data.key, data);
  }
/*
  AudioMetadata getAudioFileMetadata(String url) {
    try {
      final List<MainCategory> mainCategoryList = [];
      mainCategoryList.addAll(
          Hive.box<MainCategory>('takwinData').values.map((e) => e).toList());
      //get lesson
      var mainCategory = mainCategoryList.where((element) => element.categorys
          .any((element) => element.subcategorys.any((element) =>
              element.lessons.any((element) => element.audioFiles
                  .any((element) => element.onlineUrl == url)))));

      String mainCategoryTitle = mainCategory.first.title;

      var category = mainCategory
          .firstWhere((element) => element.title == mainCategoryTitle)
          .categorys
          .where((element) => element.subcategorys.any((element) =>
              element.lessons.any((element) => element.audioFiles
                  .any((element) => element.onlineUrl == url))));

      String categoryTitle = category.first.title;

      var subCategory = category
          .firstWhere((element) => element.title == categoryTitle)
          .subcategorys
          .where((element) => element.lessons.any((element) =>
              element.audioFiles.any((element) => element.onlineUrl == url)));

      String subCategoryTitle = subCategory.first.title;

      var lesson = subCategory
          .firstWhere((element) => element.title == subCategoryTitle)
          .lessons
          .where((element) =>
              element.audioFiles.any((element) => element.onlineUrl == url));

      String lessonTitle = lesson.first.title;

      var audioFile = lesson
          .firstWhere((element) => element.title == lessonTitle)
          .audioFiles
          .where((element) => element.onlineUrl == url);

      String audioFileTitle = audioFile.first.title;
      return AudioMetadata(
        mainCategoryTitle: mainCategoryTitle,
        categoryTitle: categoryTitle,
        subCategoryTitle: subCategoryTitle,
        lessonTitle: lessonTitle,
        audioFileTitle: audioFileTitle,
      );
    } catch (e) {
      return AudioMetadata(
        mainCategoryTitle: "",
        categoryTitle: "",
        subCategoryTitle: "",
        lessonTitle: "",
        audioFileTitle: "",
      );
    }
  }


*/
}
