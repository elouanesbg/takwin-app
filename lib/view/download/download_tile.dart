import 'package:flutter/material.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/model/download_data_model.dart';

class DownloadTile extends StatelessWidget {
  final AudioData audioData;
  final DownloadDataModel downloadModel;
  const DownloadTile({
    super.key,
    required this.audioData,
    required this.downloadModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.3,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  color: const Color(
                    0xFF2C5F2D,
                  ).withOpacity(0.4),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(audioData.subcategoryTitle),
                      Text(audioData.lessonTitle),
                      Text(audioData.title),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () async {},
                    icon: const Icon(
                      Icons.cancel,
                      color: Color(
                        0xFF2C5F2D,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  color: Colors.red,
                  backgroundColor: const Color(0xFF2C5F2D),
                  minHeight: 8,
                  value: downloadModel.progress! / 100,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
