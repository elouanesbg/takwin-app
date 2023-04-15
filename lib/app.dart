import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:takwin/main_app_bar.dart';
import 'package:takwin/view/about/about_page.dart';
import 'package:takwin/view/download/download_task_list.dart';
import 'package:takwin/view/favorite/favorite_page.dart';
import 'package:takwin/view/home/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF234E70),
            Color(0xFF2C5F2D),
            Color(0xFF97BC62),
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: const MainAppBar(),
          bottomNavigationBar: _mainBottomNavigationBar(),
          body: Column(
            children: [
              if (_currentIndex == 0) const HomePage(),
              if (_currentIndex == 1) const FavoritePage(),
              if (_currentIndex == 2) const OfflineDownloads(),
              if (_currentIndex == 3) AboutPage(),
            ],
          )),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _mainBottomNavigationBar() {
    return BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xEE234E70),
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "المفضلة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: "التحميلات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "حول",
          ),
        ]);
  }
}
