import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:takwin/view/download/download_tile.dart';

class OfflineDownloads extends StatefulWidget with WidgetsBindingObserver {
  const OfflineDownloads({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OfflineDownloadsState createState() => _OfflineDownloadsState();
}

class _OfflineDownloadsState extends State<OfflineDownloads> {
  //final ReceivePort _port = ReceivePort();
  List<Map> downloadsListMaps = [];

  @override
  void initState() {
    super.initState();
    task();
  }

  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    log("getting task...");
    // ignore: no_leading_underscores_for_local_identifiers
    for (var _task in getTasks!) {
      if (_task.status == DownloadTaskStatus.complete) {
        FlutterDownloader.remove(taskId: _task.taskId);
      }
      Map map = {};
      map['status'] = _task.status;
      map['progress'] = _task.progress;
      map['id'] = _task.taskId;
      map['filename'] = _task.filename;
      map['savedDirectory'] = _task.savedDir;
      log("status: ${_task.status}  filename: ${_task.filename}");
      downloadsListMaps.add(map);
    }
    setState(() {});
  }

  Widget downloadStatus(DownloadTaskStatus status) {
    log("getting statud: $status");

    if (status == DownloadTaskStatus.complete) {
      return const Icon(
        Icons.download_done,
        color: Colors.white,
      );
    } else if (status == DownloadTaskStatus.canceled) {
      return const Icon(
        Icons.cancel,
        color: Colors.white,
      );
    } else if (status == DownloadTaskStatus.enqueued) {
      return const Icon(
        Icons.lock_clock,
        color: Colors.white,
      );
    } else if (status == DownloadTaskStatus.failed) {
      return const Icon(
        Icons.running_with_errors,
        color: Colors.white,
      );
    } else if (status == DownloadTaskStatus.paused) {
      return const Icon(
        Icons.pause_circle,
        color: Colors.white,
      );
    } else if (status == DownloadTaskStatus.running) {
      return const Icon(
        Icons.download_for_offline,
        color: Colors.white,
      );
    } else {
      return const Icon(
        Icons.cancel,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return downloadsListMaps.isEmpty
        ? const Expanded(child: Center(child: Text("لا يوجد تحميلات")))
        : ListView.builder(
            itemCount: downloadsListMaps.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Map map = downloadsListMaps[index];

              int progress = map['progress'];
              DownloadTaskStatus status = map['status'];
              String taskId = map['id'];
              return DownloadTile(
                progress: progress,
                status: status,
                taskId: taskId,
              );
            },
          );
  }
}
