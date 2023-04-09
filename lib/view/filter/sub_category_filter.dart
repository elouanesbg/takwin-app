import 'package:flutter/material.dart';
import 'package:takwin/model/subcategory_model.dart';
import 'package:takwin/view/lesson/lessons_list_page.dart';

class SubCategoryFilter extends StatelessWidget {
  final String title;
  final List<Subcategory> subcategorys;
  const SubCategoryFilter(
      {super.key, required this.subcategorys, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              )),
          automaticallyImplyLeading: false,
          title: Text(title),
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              LessonHomePage(subcategory: subcategorys[index]),
                        ),
                      );

                      /*showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MainCategoryFilter(
                                mainCategorys: mainCategorys);
                          }).then((value) => Navigator.pop(context));*/
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
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
                                child: const Icon(Icons.category,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(subcategorys[index].title),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.blue),
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
    );
  }
}
