import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/provider/user_provide.dart';
import 'package:takwin/view/lesson/audio_controler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:takwin/view/lesson/audio_metadata.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  const LessonPage({super.key, required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with WidgetsBindingObserver {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playList;
  late String audioUrl =
      '${widget.lesson.url}/${widget.lesson.audioFiles[0].name}';

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
    await _player.setLoopMode(LoopMode.all);
    await _player.setAudioSource(_playList);
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
                          return const SizedBox();
                        }
                        final currentIndex = snapshot.data!.currentIndex;
                        return ListView.builder(
                          itemCount: widget.lesson.audioFiles.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                _player.seek(Duration.zero, index: index);
                                _player.play();
                              },
                              child: Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              //overflow: TextOverflow.ellipsis,
                                              widget.lesson.audioFiles[index]
                                                  .title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.play_circle,
                                            color: index == currentIndex
                                                ? const Color(0xFF2C5F2D)
                                                : const Color(0xFF234E70),
                                            size: 40,
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
                              ),
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
        onPressed: () => Navigator.pop(context),
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
}

class PositionData {
  final Duration position;
  final Duration bufferdPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferdPosition, this.duration);
}
