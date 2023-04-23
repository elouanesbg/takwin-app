import 'dart:developer';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:uuid/uuid.dart';
import 'package:android_path_provider/android_path_provider.dart';

class LessonPageTile extends StatefulWidget with WidgetsBindingObserver {
  final bool isPlay;
  final AudioData audioFile;
  final AudioPlayer player;
  final int playIndex;
  const LessonPageTile({
    super.key,
    required this.audioFile,
    required this.isPlay,
    required this.player,
    required this.playIndex,
  });

  @override
  State<LessonPageTile> createState() => _LessonPageTileState();
}

class _LessonPageTileState extends State<LessonPageTile> {
  late String _localPath;
  late bool _permissionReady;
  late bool isDownloding;
  @override
  void initState() {
    super.initState();
    _permissionReady = false;
    isDownloding = false;
    _retryRequestPermission();
  }

  Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        //externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        final directory = await getApplicationDocumentsDirectory();
        externalStorageDirPath = directory.path;
      } catch (err, st) {
        log('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
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
                  onPressed: () async {
                    if (!widget.audioFile.isAvilableOffline! &&
                        !isDownloding &&
                        _permissionReady) {
                      final String url = widget.audioFile.onlineUrl!;
                      //create file name
                      final extension = path.extension(url);
                      Uuid uuid = const Uuid();
                      String filename = '${uuid.v1()}$extension';
                      log("_localPath: $_localPath");
                      await FlutterDownloader.enqueue(
                        url: url,
                        fileName: filename,
                        headers: {}, // optional: header send with url (auth token etc)
                        savedDir: _localPath,
                        showNotification:
                            true, // show download progress in status bar (for Android)
                        openFileFromNotification:
                            false, // click on notification to open downloaded file (for Android)
                      );
                      setState(() {
                        isDownloding = true;
                      });
                    }
                  },
                  // ignore: unnecessary_null_comparison
                  icon: isDownloding
                      ? const Icon(
                          Icons.downloading,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.download,
                          color: Colors.white,
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
                    widget.player.seek(Duration.zero, index: widget.playIndex);
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
