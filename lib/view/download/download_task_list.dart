import 'dart:async';
import 'dart:developer';
import 'dart:io';
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
    for (var _task in getTasks!) {
      if (_task.status == DownloadTaskStatus.complete) {
        FlutterDownloader.remove(taskId: _task.taskId);
      }
      Map _map = {};
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      log("status: ${_task.status}  filename: ${_task.filename}");
      downloadsListMaps.add(_map);
    }
    setState(() {});
  }

  Widget downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? const Icon(
            Icons.cancel,
            color: Colors.white,
          )
        : _status == DownloadTaskStatus.complete
            ? const Icon(
                Icons.download_done,
                color: Colors.white,
              )
            : _status == DownloadTaskStatus.failed
                ? const Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                : _status == DownloadTaskStatus.paused
                    ? const Icon(
                        Icons.pause,
                        color: Colors.white,
                      )
                    : _status == DownloadTaskStatus.running
                        ? const Icon(
                            Icons.downloading,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.query_builder,
                            color: Colors.white,
                          );
  }

  @override
  Widget build(BuildContext context) {
    return downloadsListMaps.length == 0
        ? const Expanded(child: Center(child: Text("لا يوجد تحميلات")))
        : ListView.builder(
            itemCount: downloadsListMaps.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              Map _map = downloadsListMaps[index];
              String _filename = _map['filename'];
              int _progress = _map['progress'];
              DownloadTaskStatus _status = _map['status'];
              String _savedDirectory = _map['savedDirectory'];
              String _taskId = _map['id'];
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
                            child: downloadStatus(_status),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_filename),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                FlutterDownloader.pause(taskId: _taskId);
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
                                FlutterDownloader.resume(taskId: _taskId);
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
                              onPressed: () {
                                FlutterDownloader.remove(taskId: _taskId);
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
                            value: _progress / 100,
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
