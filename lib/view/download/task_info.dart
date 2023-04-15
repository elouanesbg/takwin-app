import 'package:flutter_downloader/flutter_downloader.dart';

class TaskInfo {
  String? audioName;
  String? lessonName;
  TaskInfo({this.audioName, this.lessonName});

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}
