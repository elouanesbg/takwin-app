import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:takwin/view/download/download_status_icon.dart';

class DownloadTile extends StatelessWidget {
  final DownloadTaskStatus status;
  final String taskId;
  final int progress;
  const DownloadTile(
      {super.key,
      required this.status,
      required this.taskId,
      required this.progress});

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
                  child: DownloadStatusIcon(status: status),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("filename"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      FlutterDownloader.pause(taskId: taskId);
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
  }
}
