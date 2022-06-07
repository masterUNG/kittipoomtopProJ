import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/admin/main/admin_info.dart';
import 'package:hangout/admin/main/admin_order.dart';
import 'package:hangout/admin/main/admin_promotion.dart';
import 'package:hangout/admin/main/admin_table.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';

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
          title: Text(
            'hangout',
            style: MyFont().white32,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: MyConstant.primary,),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyConstant.primary,
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
        selectedItemColor: MyConstant.light,
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
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.design_services_outlined,
                size: 30.0,
              ),
              label: 'แก้ไขโต๊ะ',
              activeIcon: Icon(
                Icons.design_services,
                size: 30.0,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.assistant_outlined,
                size: 30.0,
              ),
              label: 'เพิ่มโปรโมชั่น',
              activeIcon: Icon(
                Icons.assistant_rounded,
                size: 30.0,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.info_outline,
                size: 30.0,
              ),
              label: 'ข้อมูล',
              activeIcon: Icon(
                Icons.info,
                size: 30.0,
              )),
        ].asMap().values.toList(),
        selectedLabelStyle: MyFont().white12,
        unselectedLabelStyle: MyFont().white12,
      ),
    );
  }
}
