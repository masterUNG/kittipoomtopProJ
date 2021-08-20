import 'package:flutter/material.dart';
import 'package:hangout/admin/admin_info.dart';
import 'package:hangout/admin/admin_order.dart';
import 'package:hangout/admin/admin_promotion.dart';
import 'package:hangout/admin/admin_table.dart';
import 'package:hangout/shared/font.dart';
import 'package:hexcolor/hexcolor.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key? key}) : super(key: key);

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {

  final List _screens = [
    AdminOrder(),
    AdminTable(),
    AdminPromotion(),
    AdminInfo(),
  ];
  int _currentIndex = 0;

   Widget currentWidget = AdminOrder();



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
            icon: Icon(Icons.book_outlined),
            title: new Text('แก้ไขโต๊ะ', style: MyFont().white12),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_rounded),
            title: new Text('เพิ่มโปรโมชั่น', style: MyFont().white12),
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
   