import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:takwin/app.dart';
import 'package:takwin/model/audio_data_model.dart';
import 'package:takwin/model/audio_metadata_model.dart';
import 'package:takwin/service/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(AudioDataAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AudioMetadataModelAdapter());
  }
  await Hive.openBox<AudioData>('takwinData');
  await Hive.openBox<AudioMetadataModel>('historyData');
  await Hive.openBox<AudioMetadataModel>('favData');
  await DataService().getData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    );
  }
}
