import 'dart:convert';

import 'package:hangout/models/table_user_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  bool loadStatus = true;
  bool haveData = false;

  List<TableModelUser> tableModelUsers = [];
  TableModelUser? tableModelUser;
  List<UserModel> userModels = [];
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    readTable();
  }

  Future<Null> readTable() async {
    if (tableModelUsers.length != 0) {
      loadStatus = true;
      haveData = true;
      tableModelUsers.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id')!;
    //print('id >> $idUser');

    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdUser.php?isAdd=true&idUser=$idUser';
    await Dio().get(url).then((value) {
      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
          loadStatus = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          setState(() {
            tableModelUser = TableModelUser.fromMap(item);
            tableModelUsers.add(tableModelUser!);
            haveData = true;
            loadStatus = false;
          });
        }
      }
    });
  }

  Widget showListBooking() => ListView.builder(
        itemCount: tableModelUsers.length,
        itemBuilder: (context, index) {
          int reverseIndex = tableModelUsers.length - 1 - index;  //* เรียงข้อมูลกลับด้าน
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.audiotrack_outlined),
                    color: Colors.amber,
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  title: Text(
                    'โต๊ะที่ ${tableModelUsers[reverseIndex].numberTable}',
                    style: MyFont().white16Bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //ทำให้ชิดริม
                    children: [
                      Text(
                        'ร้าน ${tableModelUsers[reverseIndex].nameStore}'
                        '\nวันที่ ${tableModelUsers[reverseIndex].bookingDate}',
                        style: MyFont().white16,
                      ),
                      Text(
                        'กรุณามาก่อนเวลา 20:00 นะคะ',
                        style: MyFont().red16,
                      )
                    ],
                  ),
                  /*trailing: IconButton(
                  icon: Icon(Icons.check_circle),
                  color: tableModelUsers[index].checkIn == 'false'
                      ? Colors.grey
                      : Colors.green,
                  onPressed: () {},
                ), */ //* Status
                ),
                Divider(
                  height: 2,
                  color: Colors.grey.shade300,
                )
              ],
            ),
          );
        },
      );

  Widget _noInfo(double size) {
    return Container(
      child: Center(
        child: Text(
          'ยังไม่มีการจองโต๊ะ',
          style: MyFont().white18,
        ),
      ),
    );
  }

  Widget divider() {
    return Divider(
      color: Colors.grey,
      height: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text(
          'Notification',
          style: MyFont().white,
        ),
      ),
      backgroundColor: MyConstant.primary,
      body: loadStatus
          ? ShowProgress()
          : haveData == true
              ? showListBooking()
              : _noInfo(size),
    );
  }
}
