import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/admin/main/admin_events.dart';
import 'package:hangout/admin/main/admin_info.dart';
import 'package:hangout/admin/main/admin_order.dart';
import 'package:hangout/admin/main/admin_promotion.dart';
import 'package:hangout/admin/main/admin_table.dart';
import 'package:hangout/admin/page/about_booking.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/my_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({Key? key}) : super(key: key);

  @override
  _AdminMainState createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  bool isSwitched = false;
  UserModel? userModel;
  String? nameStore, imageTable, idStore, switchStatus;

  final List _screens = [
    AdminOrder(),
    AdminTable(),
    AdminEvent(),
    AdminPromotion(),
    AdminInfo(),
  ];
  int _currentIndex = 0;

  Widget currentWidget = AdminOrder();

  Future<Null> findInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetInfo).then((value) {
      //print(value);
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameStore = userModel!.nameStore;
          imageTable = userModel!.imageTable;
          idStore = userModel!.id;
          switchStatus = userModel!.status;
          if (switchStatus == 'true') {
            setState(() {
              isSwitched = true;
            });
          } else {
            setState(() {
              isSwitched = false;
            });
          }
        });
      }
    });
  }

  Widget statusSwich() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'สถานะการจองของร้าน',
            style: MyFont().black18,
          ),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = !isSwitched;

                if (isSwitched) {
                  print('$isSwitched');
                  String url =
                      '${MyConstant.domain}/hangout/editStatusWhereId.php?isAdd=true&id=$idStore&Status=$isSwitched';
                  Dio()
                      .get(url)
                      .then((value) => print('Update Status true Success'));
                  MyDialog().successDialog(context, 'สถานะ', 'เปิดให้จอง');
                } else {
                  print('$isSwitched');
                  String url =
                      '${MyConstant.domain}/hangout/editStatusWhereId.php?isAdd=true&id=$idStore&Status=$isSwitched';
                  Dio()
                      .get(url)
                      .then((value) => print('Update Status false Success'));
                  MyDialog()
                      .successDialog(context, 'สถานะ', 'ปิดการจองชั่วคราว');
                }
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 80,
      height: 80,
      child: CircleAvatar(
          radius: 100, backgroundImage: AssetImage('assets/images/icon.png')),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogo(),
          SizedBox(
            height: 10,
          ),
          Text(
            'hangout',
            style: MyFont().black16,
          ),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          showHead(),
          statusSwich(),
          //homeMenu(),
          //homeEdit(),
          //homePromotion(),
          //homeInfo(),

          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(right: 80, left: 80, bottom: 40),
                child: MaterialButton(
                  onPressed: () async {
                    MyDialog().loadingDialog(context);
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear().then(
                          (value) => Navigator.pushNamedAndRemoveUntil(context,
                              MyConstant.rountSignIn, (route) => false),
                        );
                  },
                  color: MyConstant.focus,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'LOGOUT',
                    style: MyFont().white12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    findInfo();
    super.initState();
    callSetupMessage();
  }

  Future<void> callSetupMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? idUserLogin = sharedPreferences.getString('id');

    if (idUserLogin != null) {
      await MyProcess(context: context).setupMessaging(idUserLogin: idUserLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'hangout',
          style: MyFont().white32,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutBooking()),
                );
              },
              icon: Icon(Icons.info))
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      drawer: showDrawer(),
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
                Icons.local_fire_department_outlined,
                size: 30.0,
              ),
              label: 'กิจกรรม',
              activeIcon: Icon(
                Icons.local_fire_department,
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
