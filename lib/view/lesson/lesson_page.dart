import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/provider/user_provide.dart';
import 'package:takwin/service/download_service.dart';
import 'package:takwin/view/lesson/audio_controler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:takwin/view/lesson/audio_metadata.dart';
import 'package:takwin/view/lesson/lesson_page_tile.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with WidgetsBindingObserver {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playList;

  bool hasConnection = false;
  final ReceivePort _port = ReceivePort();
  List<Map> downloadsListMaps = [];

  List<AudioSource> getPlayList() {
    List<AudioSource> list = [];
    int i = 0;
    for (var element in widget.lesson.audioFiles) {
      Uri url = Uri.parse("${widget.lesson.url}/${element.name}");
      list.add(AudioSource.uri(url,
          tag: MediaItem(
            id: "$i",
            title: element.title,
            artist: widget.lesson.title,
          )));
      i++;
    }
    return list;
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _playList = ConcatenatingAudioSource(children: getPlayList());
    _init();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
    if (state == AppLifecycleState.detached) {
      _player.stop();
    }
  }

  Future<void> _init() async {
    var task = await DownloadService().task();
    setState(() {
      downloadsListMaps = task;
    });
    hasConnection = await InternetConnectionChecker().hasConnection;

    await _player.setLoopMode(LoopMode.all);
    try {
      await _player.setAudioSource(_playList);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      log("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web: a generic message
      log("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      log("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all errors
      log("$e");
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _player.dispose();
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF234E70),
              Color(0xFF2C5F2D),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomSheet: _audioPlayerWidget(),
          appBar: _appbar(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<SequenceState?>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;

                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final currentIndex = snapshot.data!.currentIndex;
                        return ListView.builder(
                          itemCount: widget.lesson.audioFiles.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            String url =
                                "${widget.lesson.url}/${widget.lesson.audioFiles[index].name}";
                            Map? map = downloadsListMaps.firstWhereOrNull(
                                (element) => element["url"] == url);
                            return LessonPageTile(
                              audioFile: widget.lesson.audioFiles[index],
                              status: map == null
                                  ? DownloadTaskStatus.undefined
                                  : map["status"],
                              isPlay: index == currentIndex,
                              player: _player,
                              playIndex: index,
                              audioUrl:
                                  "${widget.lesson.url}/${widget.lesson.audioFiles[index].name}",
                            );
                          },
                        );
                      }),
                  const SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context, false),
        icon: const Icon(
          Icons.cancel,
          color: Colors.white,
        ),
      ),
      automaticallyImplyLeading: false,
      title: Text(widget.lesson.title),
      actions: [
        IconButton(
          onPressed: () {
            if (Provider.of<UserData>(context, listen: false)
                .isFvLesson(widget.lesson.url)) {
              context.read<UserData>().deleteContact(widget.lesson.key);
            } else {
              context.read<UserData>().addLesson(widget.lesson);
            }
          },
          icon: Icon(
            Icons.favorite,
            color: context.watch<UserData>().isFvLesson(widget.lesson.url)
                ? Colors.red
                : Colors.white,
          ),
        ),
      ],
    );
  }

  _audioPlayerWidget() {
    return SizedBox(
      height: 130,
      child: ColoredBox(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AudioControl(audioPlayer: _player),
                StreamBuilder<SequenceState?>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;

                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadta = state!.currentSource!.tag as MediaItem;
                    return AudioMetadata(
                      title: metadta.title,
                      artist: metadta.artist ?? '',
                    );
                  },
                ),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positonData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ProgressBar(
                        barHeight: 4,
                        progress: positonData?.position ?? Duration.zero,
                        buffered: positonData?.bufferdPosition ?? Duration.zero,
                        total: positonData?.duration ?? Duration.zero,
                        onSeek: _player.seek,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* double progress = -1;
  Map<String, double> downloadProgress = {};
  void downloadFile(String url) async {
    log("start download: $url");
    final request = Request('GET', Uri.parse(url));

    final StreamedResponse response = await Client().send(request);

    final contentLength = response.contentLength;

    //update ui set download started (set it as 0.0001)
    log("update ui contentLength: $contentLength");
    // ignore: use_build_context_synchronously
    setState(() {
      progress = 0.001;
    });
    List<int> bytes = [];

    final file = await _getFile('audio.mp3');
    int downloadProgress = 0;
    response.stream.listen((List<int> value) {
      bytes.addAll(value);
      final downloadLength = value.length;
      downloadProgress += downloadLength;
      log("stream : ${downloadProgress.toDouble()}");
      // update the ui (downloadLength.toDouble()/ (contentLength) ?? 1)
      setState(() {
        progress = (downloadProgress.toDouble() / contentLength!);
      });
    }, onDone: () async {
      log("Done");
      //update the ui set download done
      setState(() {
        progress = 1;
      });
      await file.writeAsBytes(bytes);
    });
  }
*/
  /*Future<File> _getFile(String filename) async {
    final dir = await getTemporaryDirectory();
    log("save to ${dir.path}/$filename ");
    return File("${dir.path}/$filename");
  }*/
}

class PositionData {
  final Duration position;
  final Duration bufferdPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferdPosition, this.duration);
}
