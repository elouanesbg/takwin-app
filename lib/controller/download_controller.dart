import 'dart:developer';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:takwin/model/download_data_model.dart';

class DownloadController extends GetxController {
  var downloadModel = <DownloadDataModel>[].obs;

  @override
  void onInit() {
    log("onInit getx");
    super.onInit();

    loadTask();
  }

  loadTask() async {
    //load download task
    final tasks = await FlutterDownloader.loadTasks();
    List<DownloadDataModel> list = [];
    for (var element in tasks!) {
      list.add(
        DownloadDataModel(
          url: element.url,
          taskId: element.taskId,
          status: element.status,
          progress: element.progress,
        ),
      );
    }
    downloadModel.value = list;
  }

  getTaskByUrl(String url) {
    try {
      return downloadModel.firstWhere((element) => element.url == url);
    } catch (e) {
      return DownloadDataModel();
    }
  }

  updateTask(DownloadDataModel downloadDataModel) async {
    int index = downloadModel.indexWhere(
        (element) => element.taskId == downloadDataModel.taskId, -1);
    log("updateTask index: $index");
    if (index == -1) {
      var listTasks = await FlutterDownloader.loadTasks();
      DownloadTask task = listTasks!
          .firstWhere((element) => element.taskId == downloadDataModel.taskId);
      log("getting task: ${task.url}");
      downloadModel.add(
        DownloadDataModel(
          url: task.url,
          taskId: task.taskId,
          status: task.status,
          progress: task.progress,
        ),
      );
    } else {
      downloadModel[index] = downloadDataModel;
    }
  }
}
