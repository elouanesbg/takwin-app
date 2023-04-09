import 'dart:io';

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:takwin/model/main_category_model.dart';
import 'package:takwin/service/data_service.dart';
import 'package:takwin/view/filter/main_category_filter.dart';
import 'package:takwin/view/home/categorie_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<MainCategory> takwinData = [];
  int selectedCategory = 0;
  bool isLoadingData = true;
  getData() async {
    var data = await DataService().readJson();
    setState(() {
      takwinData = data;
      isLoadingData = false;
    });
  }

  /*Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }*/

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(AppBar().preferredSize.height),
      //drawer: _appDrawer(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      itemCount: takwinData[selectedCategory].categorys.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CategorieTile(
                            category:
                                takwinData[selectedCategory].categorys[index]);
                      }),
                ],
              ),
            ),
    );
  }

  var _currentIndex = 0;
  _bottomNavigationBar() => SalomonBottomBar(
        backgroundColor: const Color(0xFF343A40),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple,
              unselectedColor: Colors.white),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Likes"),
            selectedColor: Colors.pink,
            unselectedColor: Colors.white,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.orange,
            unselectedColor: Colors.white,
          ),

          /// Profile
          SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal,
              unselectedColor: Colors.white),
        ],
      );

  _appBar(height) => PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width,
            height + (Platform.isWindows ? 120 : 80)),
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              height: height + 85,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: StreamBuilder<Object>(
                    stream: null,
                    builder: (context, snapshot) {
                      return const Center(
                        child: Text(
                          "تكوين الراسخين",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(),
            Positioned(
              top: 120.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                primary: false,
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 40,
                  child: ListView.builder(
                      itemCount: takwinData.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return mainCategoryTile(
                            text: takwinData[index].title,
                            isSelected:
                                index == selectedCategory ? true : false,
                            index: index);
                      }),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MainCategoryFilter(
                                  mainCategorys: takwinData);
                            });
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.white,
                      ))
                ],
              ),
            )
          ],
        ),
      );

  mainCategoryTile(
      {required text, required bool isSelected, required int index}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                text,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: isSelected ? 18 : 16),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            isSelected
                ? Container(
                    height: 4,
                    width: text.length.toDouble() * 5,
                    decoration: BoxDecoration(
                        color: const Color(0xff007084),
                        borderRadius: BorderRadius.circular(12)),
                  )
                : Container()
          ],
        ));
  }
}
