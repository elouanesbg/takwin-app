import 'dart:developer';

import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadService {
  Future<List<Map>> task() async {
    List<Map> downloadsListMaps = [];
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    log("getting task...service");
    for (var task in getTasks!) {
      if (task.status == DownloadTaskStatus.complete) {
        FlutterDownloader.remove(taskId: task.taskId);
      }
      Map map = {};
      map['url'] = task.url;
      map['status'] = task.status;
      map['progress'] = task.progress;
      map['id'] = task.taskId;
      map['filename'] = task.filename;
      map['savedDirectory'] = task.savedDir;
      log("status: ${task.status}  filename: ${task.filename}");
      downloadsListMaps.add(map);
    }
    return downloadsListMaps;
  }
}
