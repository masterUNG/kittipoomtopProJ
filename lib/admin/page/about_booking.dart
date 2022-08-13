import 'dart:convert';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/models/table_user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutBooking extends StatefulWidget {
  const AboutBooking({Key? key}) : super(key: key);

  @override
  State<AboutBooking> createState() => _AboutBookingState();
}

class _AboutBookingState extends State<AboutBooking> {
  String? idUser, timeBooking, timeToday, today, table, username, numberTable;
  String? title, testNum, tableNumber, inPressed;

  TableModelUser? tableModelUser;
  List<TableModelUser> tableModelUsers = [];

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Future<Null> readTable() async {
    if (tableModelUsers.length != 0) {
      tableModelUsers.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdStore.php?isAdd=true&idStore=$idStore&BookingDate=$timeBooking';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          tableModelUser = TableModelUser.fromMap(item);
          if (tableModelUser?.bookingDate == timeBooking) {
            setState(() {
              tableModelUsers.add(tableModelUser!);
            });
          }
        }
      }
    });
  }

  Future<Null> readTable2() async {
    if (tableModelUsers.length != 0) {
      tableModelUsers.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdStore.php?isAdd=true&idStore=$idStore&BookingDate=$timeBooking';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          tableModelUser = TableModelUser.fromMap(item);
          if (tableModelUser?.bookingDate == timeBooking) {
            setState(() {
              tableModelUsers.add(tableModelUser!);
            });
          }
        }
      }
    });
    Navigator.of(context).pop();
  }

  Widget noData() {
    return Scaffold(
      body: Center(
          child: Text(
        'ยังไม่มีให้จองในขณะนี้',
        style: MyFont().white18,
      )),
      backgroundColor: MyConstant.primary,
    );
  }

  Widget showData() {
    return Column(
      children: [
        _dateCeledar(),
        SizedBox(
          height: 20.0,
        ),
        tableModelUsers.length == 0
            ? Center(
                child: Text(
                title!,
                style: MyFont().black18,
              ))
            : showListBooking()
      ],
    );
  }

  Widget _dateCeledar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        controller: _controller,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
            title = 'ยังไม่มีจองในขณะนี้';
            String _dateTime = DateFormat('d MMMM y').format(_selectedValue);
            timeBooking = _dateTime;
          });
          MyDialog().loadingDialog(context);
          readTable2();
        },
      ),
    );
  }

  Widget showListBooking() {
    return Flexible(
      child: ListView.builder(
        itemCount: tableModelUsers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.book),
                    onPressed: () {},
                  ),
                  title: Text(
                    'โต๊ะ ${tableModelUsers[index].numberTable} จองแล้ว ',
                    style: MyFont().black16Bold,
                  ),
                  subtitle: Text(
                    'ผู้จอง ${tableModelUsers[index].username}'
                    '\nเบอร์โทรศัพท์ ${tableModelUsers[index].phone}'
                    '\nเวลาที่จอง ${tableModelUsers[index].dateTime}',
                    style: MyFont().grey14,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.check_circle),
                      onPressed: () {
                        setState(() {
                          String id = tableModelUsers[index].id;

                          if (tableModelUsers[index].checkIn == 'false') {
                            inPressed = 'true';
                            String url =
                                '${MyConstant.domain}/hangout/editCheckInWhereId.php?isAdd=true&id=$id&checkIn=$inPressed';
                            Dio().get(url).then(
                                (value) => print('Update Check true Success1'));

                            MyDialog().loadingDialog(context);
                            readTable2();
                          } else {
                            inPressed = 'false';
                            String url =
                                '${MyConstant.domain}/hangout/editCheckInWhereId.php?isAdd=true&id=$id&checkIn=$inPressed';
                            Dio().get(url).then(
                                (value) => print('Update Check false Success'));

                            MyDialog().loadingDialog(context);
                            readTable2();
                          }
                        });
                      },
                      color: tableModelUsers[index].checkIn == 'false' ||
                              tableModelUsers[index].checkIn == ''
                          ? Colors.grey
                          : Colors.lightGreen)),
              Divider(
                height: 2,
                color: Colors.grey.shade300,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseTable() {
    return Container(
      child: Column(
        children: <Widget>[
          showListBooking(),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'ยินดีต้อนรับสู่ Hangout',
            style: MyFont().black16,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    title = 'กรุณาเลือกวันที่ต้องการเช็คข้อมูล';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'รายละเอียดการจอง',
            style: MyFont().white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: MyConstant.primary,
        ),
        body: showData());
  }
}
