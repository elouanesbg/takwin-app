import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:takwin/model/download_data_model.dart';
import 'package:takwin/service/data_service.dart';

class DownloadController extends GetxController {
  var downloadModel = <DownloadDataModel>[].obs;

  @override
  void onInit() {
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

  updateToffline(String taskid) async {
    var data = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskid'");
    if (data!.isNotEmpty) {
      var task = data.first;
      final String saveDir = task.savedDir;
      final String? filename = task.filename;
      final String url = task.url;

      DataService().updateAudioFileToOffline(url, "$saveDir/$filename");
    }
  }

  updateTask(String taskId, DownloadTaskStatus status, int progress) async {
    int index =
        downloadModel.indexWhere((element) => element.taskId == taskId, -1);
    if (index == -1) {
      var listTasks = await FlutterDownloader.loadTasks();
      DownloadTask task =
          listTasks!.firstWhere((element) => element.taskId == taskId);
      downloadModel.add(
        DownloadDataModel(
          url: task.url,
          taskId: task.taskId,
          status: task.status,
          progress: task.progress,
        ),
      );
    } else {
      DownloadDataModel model = DownloadDataModel(
        url: downloadModel[index].url,
        status: status,
        progress: progress,
        taskId: taskId,
      );
      downloadModel[index] = model;
    }
    if (status == DownloadTaskStatus.complete) {
      await updateToffline(taskId);
    }
  }
}
