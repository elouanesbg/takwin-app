import 'package:flutter/material.dart';

class AudioMetadata extends StatelessWidget {
  final String title;
  final String artist;
  const AudioMetadata({super.key, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        /* const SizedBox(
          height: 2,
        ),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),*/
      ],
    );
  }
}
