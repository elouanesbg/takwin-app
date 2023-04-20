import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:takwin/controller/download_controller.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/download/download_tile.dart';

class OfflineDownloads extends StatefulWidget with WidgetsBindingObserver {
  const OfflineDownloads({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OfflineDownloadsState createState() => _OfflineDownloadsState();
}

class _OfflineDownloadsState extends State<OfflineDownloads> {
  @override
  void initState() {
    super.initState();

    loadTask();
  }

  Future loadTask() async {}

  @override
  Widget build(BuildContext context) {
    return GetX<DownloadController>(
      builder: (controller) {
        return Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: controller.downloadModel.length,
            itemBuilder: (context, index) {
              AudioData metadata = DataService()
                  .getAudioFileFromUrl(controller.downloadModel[index].url!);
              return DownloadTile(
                  audioData: metadata,
                  downloadModel: controller.downloadModel[index]);
            },
          ),
        );
      },
    );

    /*FutureBuilder(
      future: FlutterDownloader.loadTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<DownloadTask> listTask = snapshot.data!;
          return SingleChildScrollView(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listTask.length,
              itemBuilder: (context, index) {
                AudioMetadata metadata =
                    DataService().getAudioFileMetadata(listTask[index].url);

                return DownloadTile(
                  metadata: metadata,
                  progress: listTask[index].progress,
                  task: listTask[index],
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
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );*/
  }
}
