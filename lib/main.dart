import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:takwin/app.dart';
import 'package:takwin/model/audio_files_model.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/provider/user_provide.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Hive.registerAdapter(AudioFilesAdapter());
  Hive.registerAdapter(LessonAdapter());
  runApp(const MyApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'تكوين الراسخين',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF343A40),
          ),
          primaryColor: const Color(0xFF234E70),
          fontFamily: "Almarai",
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder(
                future: _initHive(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.error != null) {
                      log("${snapshot.error}");
                      return const Scaffold(
                        body: Center(
                          child: Text('Error initializing hive data store.'),
                        ),
                      );
                    } else {
                      return const Directionality(
                          textDirection: TextDirection.rtl, child: App());
                    }
                  } else {
                    return const Scaffold();
                  }
                },
              ),
        },
      ),
    );
  }
}
