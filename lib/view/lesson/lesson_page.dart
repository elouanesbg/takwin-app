import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:takwin/model/audio_files_model.dart';
import 'package:takwin/view/lesson/audio_controler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:takwin/view/lesson/audio_metadata.dart';

class LessonPage extends StatefulWidget {
  final String title;
  final String url;
  final List<AudioFiles> audioFiles;
  const LessonPage(
      {super.key,
      required this.audioFiles,
      required this.title,
      required this.url});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playList;
  late String audioUrl = '${widget.url}/${widget.audioFiles[0].name}';

  List<AudioSource> getPlayList() {
    List<AudioSource> list = [];
    int i = 0;
    for (var element in widget.audioFiles) {
      Uri url = Uri.parse("${widget.url}/${element.name}");
      list.add(AudioSource.uri(url,
          tag: MediaItem(
            id: "$i",
            title: element.title,
            artist: widget.title,
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
    _playList = ConcatenatingAudioSource(children: getPlayList());
    _init();
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
      child: Scaffold(
        bottomSheet: SizedBox(
          height: 120,
          child: ColoredBox(
            color: Theme.of(context).primaryColor,
            child: Center(
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

                          //baseBarColor: Colors.greenAccent,
                          //thumbColor: Colors.red,
                          progress: positonData?.position ?? Duration.zero,
                          buffered:
                              positonData?.bufferdPosition ?? Duration.zero,
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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              )),
          automaticallyImplyLeading: false,
          title: Text(widget.title),
        ),
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
                        itemCount: widget.audioFiles.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              _player.seek(Duration.zero, index: index);
                              _player.play();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 70,
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        color: index == currentIndex
                                            ? Colors.red
                                            : Colors.blue,
                                        width: 50,
                                        height: 50,
                                        child: const Icon(Icons.play_arrow,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.audioFiles[index].title,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.audio_file,
                                          color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
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
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferdPosition;
  final Duration duration;
  const PositionData(this.position, this.bufferdPosition, this.duration);
}
