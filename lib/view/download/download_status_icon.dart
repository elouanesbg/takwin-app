import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadStatusIcon extends StatelessWidget {
  final DownloadTaskStatus status;
  const DownloadStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return status == DownloadTaskStatus.complete
        ? const Icon(Icons.download_done, color: Colors.white)
        : status == DownloadTaskStatus.canceled
            ? const Icon(
                Icons.cancel,
                color: Colors.white,
              )
            : status == DownloadTaskStatus.enqueued
                ? const Icon(
                    Icons.lock_clock,
                    color: Colors.white,
                  )
                : status == DownloadTaskStatus.failed
                    ? const Icon(
                        Icons.running_with_errors,
                        color: Colors.white,
                      )
                    : status == DownloadTaskStatus.paused
                        ? const Icon(
                            Icons.pause_circle,
                            color: Colors.white,
                          )
                        : status == DownloadTaskStatus.running
                            ? const Icon(
                                Icons.download_for_offline,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              );
  }
}
