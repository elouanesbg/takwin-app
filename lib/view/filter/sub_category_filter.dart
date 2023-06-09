import 'package:flutter/material.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/lesson/lessons_list_page.dart';

class SubCategoryFilter extends StatefulWidget {
  final String title;
  final String mainCategory;
  final String category;
  const SubCategoryFilter({
    super.key,
    required this.title,
    required this.mainCategory,
    required this.category,
  });

  @override
  State<SubCategoryFilter> createState() => _SubCategoryFilterState();
}

class _SubCategoryFilterState extends State<SubCategoryFilter> {
  late Set<String> subcategorys;
  @override
  void initState() {
    subcategorys =
        DataService().getSubCategory(widget.mainCategory, widget.category);
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
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: ListView.builder(
                  itemCount: subcategorys.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonHomePage(
                              mainCategory: widget.mainCategory,
                              category: widget.category,
                              subcategory: subcategorys.elementAt(index),
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
                            color: Colors.white.withOpacity(
                              0.3,
                            ),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color:
                                      const Color(0xFF234E70).withOpacity(0.5),
                                  width: 70,
                                  height: 70,
                                  child: const Icon(Icons.category,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        subcategorys.elementAt(index),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
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
            ),
          ),
        ),
      ),
    );
  }
}
