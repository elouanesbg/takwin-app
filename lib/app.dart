import 'package:flutter/material.dart';
import 'package:takwin/main_app_bar.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/about/about_page.dart';
import 'package:takwin/view/favorite/favorite_page.dart';
import 'package:takwin/view/home/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<MainCategory> takwinData = [];
  bool isLoadingData = true;
  var _currentIndex = 0;

  getData() async {
    var data = await DataService().readJson();
    for (var element in data) {
      for (var element in element.categorys) {
        for (var element in element.subcategorys) {
          element.lessons.removeWhere((element) => element.audioFiles.isEmpty);
        }
      }
    }
    for (var element in data) {
      for (var element in element.categorys) {
        element.subcategorys.removeWhere((element) => element.lessons.isEmpty);
      }
    }
    for (var element in data) {
      element.categorys.removeWhere((element) => element.subcategorys.isEmpty);
    }
    setState(() {
      takwinData = data;
      isLoadingData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: const MainAppBar(),
          bottomNavigationBar: const MainBottomNavigationBar(),
          body: isLoadingData
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    if (_currentIndex == 0) HomePage(takwinData: takwinData),
                    if (_currentIndex == 1)
                      FavoritePage(
                          subcategory:
                              takwinData[0].categorys[0].subcategorys[0]),
                    if (_currentIndex == 2) AboutPage(),
                    if (_currentIndex == 3) AboutPage(),
                  ],
                )),
    );
  }
}

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple.shade800,
        unselectedItemColor: Colors.white,
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
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "حول",
          ),
        ]);
  }
}
