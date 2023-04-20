import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takwin/controller/fav_controller.dart';
import 'package:takwin/view/lesson/lesson_page.dart';

// ignore: must_be_immutable
class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});
  FavController favController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<FavController>(
      builder: (controller) {
        return controller.favModel.isEmpty
            ? const Expanded(
                child: Center(
                  child: Text(
                    "...",
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.favModel.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonPage(
                              audioMetadataModel: controller.favModel[index],
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
                                  color: Colors.deepPurple.withOpacity(0.5),
                                  width: 70,
                                  height: 70,
                                  child: const Icon(Icons.audio_file,
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
                                        controller
                                            .favModel[index].subCategoryTitle!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      ),
                                      Text(
                                        controller.favModel[index].lessonTitle!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
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
                  },
                ),
              );
      },
    );
  }
}
