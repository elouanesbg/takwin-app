import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:takwin/app.dart';
import 'package:takwin/model/audio_files_model.dart';
import 'package:takwin/model/category_model.dart';
import 'package:takwin/model/lesson_model.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/model/subcategory_model.dart';
import 'package:takwin/provider/user_provide.dart';
import 'package:takwin/service/data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          false, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Hive.registerAdapter(AudioFilesAdapter());
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(SubcategoryAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(MainCategoryAdapter());
  runApp(const MyApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await DataService().getData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
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
      ),
    );
  }
}
