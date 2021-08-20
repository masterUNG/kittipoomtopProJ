import 'package:flutter/material.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/user/user_home.dart';
import 'package:hangout/user/user_info.dart';
import 'package:hangout/user/user_notification.dart';
import 'package:hangout/user/user_promotion.dart';
import 'package:hexcolor/hexcolor.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  final List _screens = [
    UserHome(),
    UserPromotion(),
    UserNotification(),
    UserInfo(),
  ];
  int _currentIndex = 0;

  Widget currentWidget = UserHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hangout'),
      ),
      body: _screens[_currentIndex],
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
              Icons.home,
            ),
            title: new Text('หน้าแรก', style: MyFont().white12),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_rounded),
            title: new Text('โปรโมชั่น', style: MyFont().white12),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_outlined,
            ),
            title: new Text('การจอง', style: MyFont().white12),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            title: new Text('ข้อมูล', style: MyFont().white12),
          ),
        ].asMap().values.toList(),
      ),
    );
  }
}
