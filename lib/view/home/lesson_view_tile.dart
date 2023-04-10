import 'package:flutter/material.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/view/lesson/lesson_page.dart';

class LessonViewTile extends StatelessWidget {
  final String subcategoryTitle;
  final Lesson lesson;
  const LessonViewTile(
      {super.key, required this.lesson, required this.subcategoryTitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LessonPage(
            lesson: lesson,
          ),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            color: const Color.fromARGB(118, 112, 215, 112),
            width: 150,
            padding: const EdgeInsets.only(right: 12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    textAlign: TextAlign.right,
                    lesson.title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    textAlign: TextAlign.right,
                    subcategoryTitle,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
