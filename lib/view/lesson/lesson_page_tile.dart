import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takwin/model/audio_data_model.dart';

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
  @override
  void initState() {
    super.initState();
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
