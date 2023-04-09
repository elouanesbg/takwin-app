import 'package:flutter/material.dart';
import 'package:takwin/model/subcategory_model.dart';
import 'package:takwin/view/lesson/lesson_page.dart';

class FavoritePage extends StatelessWidget {
  final Subcategory subcategory;
  const FavoritePage({super.key, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subcategory.lessons.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LessonPage(
                    audioFiles: subcategory.lessons[index].audioFiles,
                    title: subcategory.lessons[index].title,
                    url: subcategory.lessons[index].url),
              ),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      color: Colors.grey,
                      width: 70,
                      height: 70,
                      child: const Icon(Icons.category, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(subcategory.lessons[index].title),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
