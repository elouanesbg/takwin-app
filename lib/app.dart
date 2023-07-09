import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takwin/controller/fav_controller.dart';
import 'package:takwin/controller/history_controller.dart';
import 'package:takwin/view/about/about_page.dart';
import 'package:takwin/view/download/download_page.dart';
import 'package:takwin/view/favorite/favorite_page.dart';
import 'package:takwin/view/home/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final favController = Get.put(FavController());
  final historyController = Get.put(HistoryController());
  var _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const Icon(Icons.grid_view_rounded),
            actions: [
              Center(
                child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const Text(
                      "شروح صوتية للعلوم الشرعية",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
          bottomNavigationBar: _mainBottomNavigationBar(),
          body: Column(
            children: [
              if (_currentIndex == 0) const HomePage(),
              if (_currentIndex == 1) FavoritePage(),
              if (_currentIndex == 2) DownloadPage(),
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
