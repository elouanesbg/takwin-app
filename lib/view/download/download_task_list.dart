import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
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
  final DownloadController downloadController = Get.find();
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
        return controller.downloadModel.isEmpty
            ? const Expanded(
                child: Center(
                  child: Text(
                    "لا يوجد تحميلات",
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.downloadModel.length,
                  itemBuilder: (context, index) {
                    AudioData metadata = DataService().getAudioFileFromUrl(
                        controller.downloadModel[index].url);
                    return DownloadTile(
                        onTap: (taskId) {
                          _delete(taskId);
                          downloadController.loadTask();
                        },
                        audioData: metadata,
                        downloadModel: controller.downloadModel[index]);
                  },
                ),
              );
      },
    );
  }

  Future<void> _delete(String taskId) async {
    await FlutterDownloader.remove(
      taskId: taskId,
      shouldDeleteContent: true,
    );

    setState(() {});
  }
}
