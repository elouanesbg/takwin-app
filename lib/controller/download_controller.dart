import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:takwin/model/download_data_model.dart';

class DownloadController extends GetxController {
  var downloadModel = <DownloadDataModel>[].obs;
  final ReceivePort _port = ReceivePort();

  @override
  void onInit() {
    log("onInit getx");
    super.onInit();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
    loadTask();
  }

  loadTask() async {
    //load download task
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
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
    if (index == -1) {
      var listTasks = await FlutterDownloader.loadTasks();
      DownloadTask task = listTasks!
          .firstWhere((element) => element.taskId == downloadDataModel.taskId);
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

///////////////isolate/////////////////////////////////////////
  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus(data[1] as int);
      final progress = data[2] as int;

      updateTask(DownloadDataModel(
        taskId: taskId,
        status: status,
        progress: progress,
      ));
      log("listen : taskId: $taskId status $status progress: $progress");
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    log("callback id: $id status: $status progress: $progress");

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status.value, progress]);
  }
}
