import 'dart:developer';

import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadService {
  Future<List<Map>> task() async {
    List<Map> downloadsListMaps = [];
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    log("getting task...service");
    for (var _task in getTasks!) {
      if (_task.status == DownloadTaskStatus.complete) {
        FlutterDownloader.remove(taskId: _task.taskId);
      }
      Map _map = {};
      _map['url'] = _task.url;
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      log("status: ${_task.status}  filename: ${_task.filename}");
      downloadsListMaps.add(_map);
    }
    return downloadsListMaps;
  }
}
