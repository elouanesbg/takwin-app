import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takwin/controller/history_controller.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/model/audio_metadata_model.dart';
import 'package:takwin/view/filter/main_category_filter.dart';
import 'package:takwin/view/home/lesson_view_tile.dart';
import 'package:takwin/view/lesson/lesson_page.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HistoryController historyController = Get.find();
  late List<AudioData> takwinData = [];
  final _random = Random();

  @override
  void initState() {
    var box = Hive.box<AudioData>('takwinData');
    takwinData.addAll(box.values.map((e) => e).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopWidget(widget: widget),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                      bottom: 10,
                    ),
                    child: SectionHeader(
                      title: "متفرقات",
                      action: "المزيد",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final randomLesson = geRandomeLesson(10);
                        return LessonViewTile(
                          mainCategory: randomLesson[index]["mainCategory"],
                          category: randomLesson[index]["category"],
                          subcategory: randomLesson[index]["subcategory"],
                          lesson: randomLesson[index]["lesson"],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5,
                      top: 20,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        const SectionHeader(title: "السجل", action: "المزيد"),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<HistoryController>(
                          builder: (controller) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.historyModel.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return AudioViewTile(
                                  audioMetadataModel:
                                      controller.historyModel[index],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  List<Map> geRandomeLesson(int size) {
    List<Map> randomLesson = [];
    for (int i = 0; i < size; i++) {
      final randomDataindex = _random.nextInt(takwinData.length);

      final String mainCategory = takwinData[randomDataindex].mainCategoryTitle;

      final String category = takwinData[randomDataindex].categoryTitle;
      final String subcategory = takwinData[randomDataindex].subcategoryTitle;
      final String lesson = takwinData[randomDataindex].lessonTitle;
      randomLesson.add({
        "mainCategory": mainCategory,
        "category": category,
        "subcategory": subcategory,
        "lesson": lesson,
      });
    }
    return randomLesson;
  }
}

class AudioViewTile extends StatelessWidget {
  const AudioViewTile({
    super.key,
    required this.audioMetadataModel,
  });

  // ignore: prefer_typing_uninitialized_variables
  final AudioMetadataModel audioMetadataModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LessonPage(
            audioMetadataModel: audioMetadataModel,
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15.0,
              ),
              color: Colors.white.withOpacity(
                0.1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        audioMetadataModel.subCategoryTitle!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        audioMetadataModel.lessonTitle!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.play_circle,
                    color: Color(0xFF2C5F2D),
                    size: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const SectionHeader({
    required this.title,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
        Text(
          action,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}

class _TopWidget extends StatelessWidget {
  const _TopWidget({
    required this.widget,
  });

  final HomePage widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مرحبا",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "استمع لمختلف الدروس ",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const MainCategoryFilter();
                }),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            //overflow: TextOverflow.ellipsis,
                            "اضغط هنا لتصفح الدروس",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //old
              ],
            ),
          ),
        ],
      ),
    );
  }
}
