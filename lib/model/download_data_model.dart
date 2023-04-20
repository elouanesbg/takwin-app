import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadDataModel {
  String? url = "";
  String? taskId = "";
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
  int? progress = 0;

  DownloadDataModel({this.url, this.taskId, this.status, this.progress});
}
