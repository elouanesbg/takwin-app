import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:takwin/model/audio_metadata_model.dart';

class FavController extends GetxController {
  var favModel = <AudioMetadataModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadTask();
  }

  loadTask() {
    var box = Hive.box<AudioMetadataModel>('favData');
    favModel.value = box.values.toList();
  }

  addToFav(AudioMetadataModel model) {
    var index = favModel.indexWhere(
        (element) => element.toJson() == model.toJson(), -1);
    if (index == -1) {
      var box = Hive.box<AudioMetadataModel>('favData');
      box.put(model.hashCode, model);
      loadTask();
    }
  }

  removeFromFav(AudioMetadataModel model) {
    var box = Hive.box<AudioMetadataModel>('favData');

    box.delete(model.hashCode);
    loadTask();
  }

  bool isFav(AudioMetadataModel model) {
    var index = favModel.indexWhere((element) => element == model, -1);
    return index == -1 ? false : true;
  }
}
