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

  deleteAll() {
    var box = Hive.box<AudioMetadataModel>('historyData');
    for (var element in box.values) {
      box.delete(element.key);
    }
  }

  loadTask() {
    var box = Hive.box<AudioMetadataModel>('historyData');

    var data = box.values.toList();
    data.sort((a, b) => a.key > b.key ? -1 : (a.key < b.key ? 1 : 0));

    historyModel.value =
        data.isNotEmpty && data.length > 5 ? data.sublist(0, 5) : data;
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
