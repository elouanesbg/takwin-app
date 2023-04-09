import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/about/about_page.dart';
import 'package:takwin/view/filter/main_category_filter.dart';
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "تكوين الراسخين",
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MainCategoryFilter(
                        mainCategorys: takwinData,
                      );
                    });
              },
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(),
        body: isLoadingData
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  if (_currentIndex == 0) HomePage(takwinData: takwinData),
                  if (_currentIndex == 1) AboutPage(),
                  if (_currentIndex == 2) AboutPage(),
                  if (_currentIndex == 3) AboutPage(),
                ],
              ));
  }

  _bottomNavigationBar() => SalomonBottomBar(
        backgroundColor: const Color(0xFF343A40),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("الرئيسية"),
              selectedColor: Colors.blue,
              unselectedColor: Colors.white),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("المفضلة"),
            selectedColor: Colors.blue,
            unselectedColor: Colors.white,
          ),
          SalomonBottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text("الإعدادات"),
              selectedColor: Colors.teal,
              unselectedColor: Colors.white),
          SalomonBottomBarItem(
            icon: const Icon(Icons.help),
            title: const Text("حول"),
            selectedColor: Colors.orange,
            unselectedColor: Colors.white,
          ),
        ],
      );
}
