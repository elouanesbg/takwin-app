import 'package:flutter/material.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/view/filter/category_filter.dart';

class MainCategoryFilter extends StatelessWidget {
  final List<MainCategory> mainCategorys;
  const MainCategoryFilter({super.key, required this.mainCategorys});

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
            title: const Text("الفئة الرئيسية"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: ListView.builder(
                  itemCount: mainCategorys.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CategoryFilter(
                                title: mainCategorys[index].title,
                                categorys: mainCategorys[index].categorys,
                              );
                            }).then((value) => Navigator.pop(context));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: Colors.white.withOpacity(0.3),
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
                                        mainCategorys[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
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
