import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class OfflineDownloads extends StatefulWidget with WidgetsBindingObserver {
  const OfflineDownloads({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OfflineDownloadsState createState() => _OfflineDownloadsState();
}

class _OfflineDownloadsState extends State<OfflineDownloads> {
  final ReceivePort _port = ReceivePort();
  List<Map> downloadsListMaps = [];

  @override
  void initState() {
    super.initState();
    task();
    _bindBackgroundIsolate();
    //FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      var task = downloadsListMaps.where((element) => element['id'] == id);
      for (var element in task) {
        element['progress'] = progress;
        element['status'] = status;
        setState(() {});
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
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
              String filename = map['filename'];
              int progress = map['progress'];
              DownloadTaskStatus status = map['status'];
              String taskId = map['id'];
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.3,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            color: const Color(
                              0xFF2C5F2D,
                            ).withOpacity(0.4),
                            width: 40,
                            height: 40,
                            child: downloadStatus(status),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(filename),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                FlutterDownloader.pause(taskId: taskId);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.pause,
                                color: Color(
                                  0xFF2C5F2D,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                FlutterDownloader.resume(taskId: taskId);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Color(
                                  0xFF2C5F2D,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () async {
                                FlutterDownloader.remove(taskId: taskId);
                                await task();
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color(
                                  0xFF2C5F2D,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            color: const Color(0xFF234E70),
                            backgroundColor: const Color(0xFF2C5F2D),
                            minHeight: 8,
                            value: progress / 100,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }
}
