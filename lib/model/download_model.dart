import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadModel {
  DownloadTask? task;
  String lessonName;
  String audioFileName;
  DownloadModel(
      {required this.lessonName, required this.audioFileName, this.task});
}
