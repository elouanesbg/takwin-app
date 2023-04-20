import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/model/download_data_model.dart';

class DownloadTile extends StatelessWidget {
  final AudioData audioData;
  final DownloadDataModel downloadModel;
  Function(String) onTap;
  DownloadTile({
    super.key,
    required this.audioData,
    required this.downloadModel,
    required this.onTap,
  });

  Icon getIcon() {
    return downloadModel.status == DownloadTaskStatus.undefined
        ? const Icon(
            Icons.warning,
            color: Colors.white,
          )
        : downloadModel.status == DownloadTaskStatus.complete
            ? const Icon(
                Icons.download_done,
                color: Colors.white,
              )
            : downloadModel.status == DownloadTaskStatus.running
                ? const Icon(
                    Icons.downloading,
                    color: Colors.white,
                  )
                : downloadModel.status == DownloadTaskStatus.enqueued
                    ? const Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                      )
                    : downloadModel.status == DownloadTaskStatus.failed
                        ? const Icon(
                            Icons.error,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.download,
                            color: Colors.white,
                          );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: getIcon()),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(audioData.subcategoryTitle),
                      Text(audioData.lessonTitle),
                      Text(audioData.title),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () async {
                      onTap(downloadModel.taskId!);
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
                  color: Colors.red,
                  backgroundColor: const Color(0xFF2C5F2D),
                  minHeight: 8,
                  value: downloadModel.progress! / 100,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
