import 'dart:math';
import 'package:flutter/material.dart';
import 'package:takwin/model/main_category_model.dart';
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
  late Box<MainCategory> mainCategoryBox;
  late List<MainCategory> mainCategoryList = [];
  final _random = Random();

  @override
  void initState() {
    mainCategoryBox = Hive.box<MainCategory>('takwinData');
    mainCategoryList.addAll(mainCategoryBox.values.map((e) => e).toList());
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
                        final randomLesson = geRandomeLesson();
                        return LessonViewTile(
                          lesson: randomLesson['lesson'],
                          subcategoryTitle: randomLesson['subcategoryTitle'],
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
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final randomLesson = geRandomeLesson();
                            return AudioViewTile(randomLesson: randomLesson);
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

  geRandomeLesson() {
    mainCategoryBox.values.map((e) => e).toList();
    final randomMainCategoryIndex = _random.nextInt(mainCategoryList.length);
    final randomMainCategory = mainCategoryList[randomMainCategoryIndex];

    final randomCategoryIndex =
        _random.nextInt(randomMainCategory.categorys.length);
    final randomCategory = randomMainCategory.categorys[randomCategoryIndex];

    final randomSubCategoryIndex =
        _random.nextInt(randomCategory.subcategorys.length);
    final randomSubCategory =
        randomCategory.subcategorys[randomSubCategoryIndex];

    final randomLessonIndex = _random.nextInt(randomSubCategory.lessons.length);
    final randomLesson = randomSubCategory.lessons[randomLessonIndex];
    return {
      "lesson": randomLesson,
      "subcategoryTitle": randomSubCategory.title,
    };
  }
}

class AudioViewTile extends StatelessWidget {
  const AudioViewTile({
    super.key,
    required this.randomLesson,
  });

  // ignore: prefer_typing_uninitialized_variables
  final randomLesson;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LessonPage(
            lesson: randomLesson["lesson"],
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
                        randomLesson["subcategoryTitle"],
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        randomLesson["lesson"].title,
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
