import 'dart:async';
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
  //List<Map> downloadsListMaps = [];
  List<DownloadTask> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future loadTask() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();

    setState(() {
      tasks = [];
      tasks.addAll(getTasks!);
    });
  }

  Future<void> _requestDownload(DownloadTask task) async {}

  Future<void> _pauseDownload(DownloadTask task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
    await loadTask();
  }

  Future<void> _resumeDownload(DownloadTask task) async {
    await FlutterDownloader.resume(taskId: task.taskId);
    await loadTask();
  }

  Future<void> _retryDownload(DownloadTask task) async {
    await FlutterDownloader.retry(taskId: task.taskId);
    await loadTask();
  }

  Future<void> _delete(DownloadTask task) async {
    await FlutterDownloader.remove(
      taskId: task.taskId,
      shouldDeleteContent: true,
    );
    await loadTask();
  }

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? const Expanded(child: Center(child: Text("لا يوجد تحميلات")))
        : ListView.builder(
            itemCount: tasks.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return DownloadTile(
                task: tasks[index],
                onActionTap: (task) {
                  if (task.status == DownloadTaskStatus.undefined) {
                    _requestDownload(task);
                  } else if (task.status == DownloadTaskStatus.running) {
                    _pauseDownload(task);
                  } else if (task.status == DownloadTaskStatus.paused) {
                    _resumeDownload(task);
                  } else if (task.status == DownloadTaskStatus.complete ||
                      task.status == DownloadTaskStatus.canceled) {
                    _delete(task);
                  } else if (task.status == DownloadTaskStatus.failed) {
                    _retryDownload(task);
                  }
                },
              );
            },
          );
  }
}
