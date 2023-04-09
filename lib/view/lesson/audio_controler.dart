import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioControl extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const AudioControl({super.key, required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => audioPlayer.seekToNext(),
              icon: const Icon(
                Icons.skip_next_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            StreamBuilder<PlayerState>(
              stream: audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (!(playing ?? false)) {
                  return IconButton(
                    onPressed: () => audioPlayer.play(),
                    iconSize: 40,
                    color: Colors.white,
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                    ),
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    onPressed: () => audioPlayer.pause(),
                    iconSize: 40,
                    color: Colors.grey,
                    icon: const Icon(
                      Icons.pause_rounded,
                    ),
                  );
                }
                return const Icon(
                  Icons.play_arrow_rounded,
                  size: 40,
                  color: Colors.white,
                );
              },
            ),
            IconButton(
              onPressed: () => audioPlayer.seekToPrevious(),
              icon: const Icon(
                Icons.skip_previous_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
