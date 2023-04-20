import 'dart:developer';
// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/lesson/audio_controler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:takwin/view/lesson/audio_metadata.dart';
import 'package:takwin/view/lesson/lesson_page_tile.dart';
// ignore: depend_on_referenced_packages

class LessonPage extends StatefulWidget {
  final String mainCategory;
  final String category;
  final String subcategory;
  final String lesson;
  const LessonPage({
    super.key,
    required this.mainCategory,
    required this.category,
    required this.subcategory,
    required this.lesson,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with WidgetsBindingObserver {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playList;

  late List<AudioData> audioFiles;

  bool hasConnection = false;
  List<Map> downloadsListMaps = [];

  List<AudioSource> getPlayList() {
    List<AudioSource> list = [];
    int i = 0;
    for (var element in audioFiles) {
      Uri url = Uri.parse("${element.onlineUrl}");
      if (element.isAvilableOffline!) {
        list.add(AudioSource.asset(element.offlineFilePath!,
            tag: MediaItem(
              id: "$i",
              title: element.title,
              artist: element.lessonTitle,
            )));
      } else {
        list.add(AudioSource.uri(url,
            tag: MediaItem(
              id: "$i",
              title: element.title,
              artist: element.lessonTitle,
            )));
      }

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
    audioFiles = DataService().getAudioFiles(
      widget.mainCategory,
      widget.category,
      widget.subcategory,
      widget.lesson,
    );
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _playList = ConcatenatingAudioSource(children: getPlayList());
    _init();
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
    _player.dispose();
    super.dispose();
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
                          return const Center(
                              child: Text("يتم تحميل البيانات ..."));
                        }
                        final currentIndex = snapshot.data!.currentIndex;
                        return ListView.builder(
                          itemCount: audioFiles.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return LessonPageTile(
                              audioFile: audioFiles.elementAt(index),
                              isPlay: index == currentIndex,
                              player: _player,
                              playIndex: index,
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
      title: Text(audioFiles.first.lessonTitle),
      actions: [
        IconButton(
          onPressed: () {
            /* if (Provider.of<UserData>(context, listen: false)
                .isFvLesson(audioFiles.first.isAvilableOffline)) {
              context.read<UserData>().deleteContact(widget.lesson.key);
            } else {
              context.read<UserData>().addLesson(widget.lesson);
            }*/
          },
          icon: const Icon(
            Icons.favorite,
            /*color: context.watch<UserData>().isFvLesson(widget.lesson.url)
                ? Colors.red
                : Colors.white,*/
            color: Colors.white,
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
}

class PositionData {
  final Duration position;
  final Duration bufferdPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferdPosition, this.duration);
}
