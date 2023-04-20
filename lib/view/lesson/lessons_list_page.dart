import 'package:flutter/material.dart';
import 'package:takwin/model/audio_metadata_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/lesson/lesson_page.dart';

class LessonHomePage extends StatefulWidget {
  final String mainCategory;
  final String category;
  final String subcategory;
  const LessonHomePage({
    super.key,
    required this.mainCategory,
    required this.category,
    required this.subcategory,
  });

  @override
  State<LessonHomePage> createState() => _LessonHomePageState();
}

class _LessonHomePageState extends State<LessonHomePage> {
  late Set<String> lessons;
  @override
  void initState() {
    lessons = DataService()
        .getLesson(widget.mainCategory, widget.category, widget.subcategory);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF234E70),
              Color(0xFF2C5F2D),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.subcategory),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  /* Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "widget.subcategory.description",
                      textAlign: TextAlign.justify,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 16),
                    ),
                  ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  lessons.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 70,
                              color: Colors.deepPurple.withOpacity(0.3),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.deepPurple.withOpacity(0.5),
                                    width: 70,
                                    height: 70,
                                    child: const Icon(Icons.no_cell,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text("لا تتوفر دروس حاليا"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lessons.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LessonPage(
                                      audioMetadataModel: AudioMetadataModel(
                                        mainCategoryTitle: widget.mainCategory,
                                        categoryTitle: widget.category,
                                        subCategoryTitle: widget.subcategory,
                                        lessonTitle: lessons.elementAt(index),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 70,
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          color: Colors.deepPurple
                                              .withOpacity(0.5),
                                          width: 70,
                                          height: 70,
                                          child: const Icon(Icons.audio_file,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                lessons.elementAt(index),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
