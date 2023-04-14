import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:takwin/model/audio_files_model.dart';
import 'package:uuid/uuid.dart';

class LessonPageTile extends StatefulWidget {
  DownloadTaskStatus status;
  bool isPlay;
  AudioFiles audioFile;
  AudioPlayer player;
  int playIndex;
  String audioUrl;
  LessonPageTile(
      {super.key,
      required this.audioFile,
      required this.status,
      required this.isPlay,
      required this.player,
      required this.playIndex,
      required this.audioUrl});

  @override
  State<LessonPageTile> createState() => _LessonPageTileState();
}

class _LessonPageTileState extends State<LessonPageTile> {
  Future<void> requestDownload(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      //create file name
      final extension = path.extension(url);
      Uuid uuid = const Uuid();
      String name = '${uuid.v1()}$extension';
      final dir =
          await getApplicationDocumentsDirectory(); //From path_provider package
      var localPath = dir.path + name;
      final savedDir = Directory(localPath);
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: url,
          fileName: name,
          savedDir: localPath,
          showNotification: true,
          openFileFromNotification: false,
        );
      });
    } else {
      log("permission not granted...");
    }
  }

  Icon downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.undefined
        ? const Icon(
            Icons.download,
            color: Colors.white,
          )
        : _status == DownloadTaskStatus.canceled
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            color: Colors.white.withOpacity(
              0.3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    requestDownload(widget.audioUrl);
                  },
                  icon: downloadStatus(
                    widget.status,
                  ),
                ),
                Flexible(
                  child: Text(
                    //overflow: TextOverflow.ellipsis,
                    widget.audioFile.title,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    log("play audio widget");
                    widget.player.seek(Duration.zero, index: 1);
                    widget.player.play();
                  },
                  icon: Icon(
                    Icons.play_circle,
                    color: widget.isPlay
                        ? const Color(0xFF2C5F2D)
                        : const Color(0xFF234E70),
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        //old
      ],
    );
  }
}
