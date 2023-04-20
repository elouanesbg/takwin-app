import 'package:get/get.dart';
import 'package:takwin/model/audio_data_model.dart';

class FavController extends GetxController {
  var favModel = <AudioData>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadTask();
  }

  loadTask() {}
}
