import 'dart:math';

import 'package:flutter/material.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/view/home/lesson_view_tile.dart';

class HomePage extends StatefulWidget {
  final List<MainCategory> takwinData;
  const HomePage({super.key, required this.takwinData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 16,
            ),
            Image.asset(
              "assets/img/main_img.jpg",
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "متفرقات",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final randomMainCategoryIndex =
                        _random.nextInt(widget.takwinData.length);
                    final randomMainCategory =
                        widget.takwinData[randomMainCategoryIndex];

                    final randomCategoryIndex =
                        _random.nextInt(randomMainCategory.categorys.length);
                    final randomCategory =
                        randomMainCategory.categorys[randomCategoryIndex];

                    final randomSubCategoryIndex =
                        _random.nextInt(randomCategory.subcategorys.length);
                    final randomSubCategory =
                        randomCategory.subcategorys[randomSubCategoryIndex];

                    final randomLessonIndex =
                        _random.nextInt(randomSubCategory.lessons.length);
                    final randomLesson =
                        randomSubCategory.lessons[randomLessonIndex];

                    return LessonViewTile(
                      lesson: randomLesson,
                      subcategoryTitle: randomSubCategory.title,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
