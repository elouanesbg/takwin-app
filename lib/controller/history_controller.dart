import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:takwin/model/audio_metadata_model.dart';

class HistoryController extends GetxController {
  var historyModel = <AudioMetadataModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    loadTask();
  }

  loadTask() {
    var box = Hive.box<AudioMetadataModel>('historyData');
    historyModel.value = box.values.toList();
  }

  addToHistory(AudioMetadataModel model) {
    var index = historyModel.indexWhere(
        (element) => element.toJson() == model.toJson(), -1);
    if (index == -1) {
      var box = Hive.box<AudioMetadataModel>('historyData');
      int index = box.values.length;
      box.put(index, model.copy);
      loadTask();
    }
  }

  removeFromHistory(AudioMetadataModel model) {
    var box = Hive.box<AudioMetadataModel>('historyData');

    box.delete(model.hashCode);
    loadTask();
  }
}
