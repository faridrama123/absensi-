import 'package:flutter_application_1/pages/menu/menu_akun.dart';
import 'package:flutter_application_1/pages/menu/menu_application.dart';
import 'package:flutter_application_1/pages/menu/menu_data.dart';
import 'package:flutter_application_1/pages/menu/menu_home.dart';
import 'package:flutter_application_1/pages/menu/menu_lembur.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int currentIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            children: <Widget>[
              MenuHome(),
              MenuData(),
              MenuLembur(),
              MenuApplication(),
              MenuAkun()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          showElevation: false,
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() => currentIndex = index);
            pageController!.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Dashboard'),
              activeColor: ColorsTheme.primary1,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.history),
              title: Text('Riwayat'),
              activeColor: ColorsTheme.primary1,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.add),
              title: Text('Overtime'),
              activeColor: ColorsTheme.primary1,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.work_off),
              title: Text('Leave Application'),
              activeColor: ColorsTheme.primary1,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Akun'),
              activeColor: ColorsTheme.primary1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
