import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:takwin/app.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تكوين الراسخين',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF343A40),
          ),
          canvasColor: Colors.grey[50],
          primaryColor: const Color(0xFF343A40),
          fontFamily: "Almarai",
          textTheme: const TextTheme()),
      home:
          const Directionality(textDirection: TextDirection.rtl, child: App()),
    );
  }
}
