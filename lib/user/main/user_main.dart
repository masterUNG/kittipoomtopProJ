import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/user/main/user_favorite.dart';
import 'package:hangout/user/main/user_home.dart';
import 'package:hangout/user/main/user_info.dart';
import 'package:hangout/user/main/user_notification.dart';
import 'package:hexcolor/hexcolor.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  final List _screens = [
    UserHome(),
    UserFavorite(),
    UserNotification(),
    UserInfo(),
  ];
  int _currentIndex = 0;

  Widget currentWidget = UserHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      backgroundColor: MyConstant.primary,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: HexColor('#181818'),
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30.0,
            ),
            label: 'หน้าแรก',
            activeIcon: Icon(
              Icons.home,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              size: 30.0,
            ),
            label: 'ร้านโปรด',
            activeIcon: Icon(
              Icons.favorite,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_outlined,
              size: 30.0,
            ),
            label: 'การจอง',
            activeIcon: Icon(
              Icons.book,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_outline,
              size: 30.0,
            ),
            label: 'ข้อมูล',
            activeIcon: Icon(
              Icons.info,
              size: 30.0,
            ),
          ),
        ].asMap().values.toList(),
        selectedLabelStyle: MyFont().white12,
        unselectedLabelStyle: MyFont().white12,
      ),
    );
  }
}
