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
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  subcategoryTitle,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                color: Colors.deepPurple.shade600.withOpacity(0.5),
              ),
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.65,
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                color: Colors.white.withOpacity(
                  0.3,
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
                          overflow: TextOverflow.ellipsis,
                          lesson.title,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.play_circle,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
