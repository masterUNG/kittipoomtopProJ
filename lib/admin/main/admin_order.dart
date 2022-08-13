import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:hangout/shared/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../models/table_user_model.dart';
import '../../shared/dialog.dart';
import '../../shared/font.dart';

class AdminOrder extends StatefulWidget {
  const AdminOrder({Key? key}) : super(key: key);

  @override
  _AdminOrderState createState() => _AdminOrderState();
}

class _AdminOrderState extends State<AdminOrder> {
  String? idUser, timeBooking, timeToday, today, table, username, numberTable;
  String? title, testNum, status, tableNumber;

  bool load = true; // load JSON
  bool? haveData; //have data

  List<String> myList = [];

  TableModelUser? tableModelUser;
  List<TableModelUser> tableModelUsers = [];

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Future<void> readTable() async {
    if (tableModelUsers.length != 0) {
      tableModelUsers.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    setState(() {
      status = 'true';
    });

    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdStore.php?isAdd=true&idStore=$idStore&BookingDate=$timeBooking';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          tableModelUser = TableModelUser.fromMap(item);
          if (tableModelUser?.bookingDate == timeBooking) {
            setState(() {
              tableModelUsers.add(tableModelUser!);
              myList.add(tableModelUser!.numberTable);
            });
          }
        }
      }
    });
    print('Status = $status');
  }

  Future<void> readTable2() async {
    if (tableModelUsers.length != 0) {
      tableModelUsers.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    setState(() {
      status = 'true';
    });

    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdStore.php?isAdd=true&idStore=$idStore&BookingDate=$timeBooking';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          tableModelUser = TableModelUser.fromMap(item);

          if (tableModelUser?.bookingDate == timeBooking) {
            setState(() {
              tableModelUsers.add(tableModelUser!);
              myList.add(tableModelUser!.numberTable);
            });
          }
        }
      }
    });
    print('จำนวนโต๊ะ : ${tableModelUsers.length}');
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
    return Scaffold(
      body: Container(
        //margin: EdgeInsets.all(10.0),
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
                : chooseTable(),
          ],
        ),
      ),
      backgroundColor: MyConstant.light,
    );
  }

  Widget _dateCeledar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        controller: _controller,
        //initialSelectedDate: DateTime.now(),
        selectionColor: Colors.white,
        selectedTextColor: MyConstant.focus,
        deactivatedColor: Colors.grey,
        onDateChange: (date) {
          readTable2();

          MyDialog().loadingDialog(context);
          setState(() {
            _selectedValue = date;
            title = 'ยังไม่มีจองในขณะนี้';
            String _dateTime = DateFormat('d MMMM y').format(_selectedValue);
            timeBooking = _dateTime;
          });

        },
      ),
    );
  }

  Widget chooseTable() {
    return Container(
      child: Column(
        children: <Widget>[
          chairPosition(),
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

  Widget chairPosition() {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              btnChair('1', false),
              btnChair('2', false),
              btnChair('3', false),
              btnChair('4', false),
              btnChair('5', false),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              btnChair('6', false),
              btnChair('7', false),
              btnChair('8', false),
              btnChair('9', false),
              btnChair('10', false),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              btnChair('11', false),
              btnChair('12', false),
              btnChair('13', false),
              btnChair('14', false),
              btnChair('15', false),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              btnChair('16', false),
              btnChair('17', false),
              btnChair('18', false),
              btnChair('19', false),
              btnChair('20', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget btnChair(String number, bool status) {
    return AnimatedButton(
      height: 40,
      width: 50,
      text: '$number',
      isReverse: true,
      selectedBackgroundColor:
          myList.contains('$number') ? MyConstant.focus : MyConstant.primary,
      selectedTextColor:
          myList.contains('$number') ? MyConstant.light : MyConstant.light,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      textStyle: MyFont().white16,
      backgroundColor:
          myList.contains('$number') ? MyConstant.focus : MyConstant.primary,
      borderColor: MyConstant.light,
      borderRadius: 10,
      borderWidth: 2,
      onPress: () {
        setState(() {
          tableNumber = number;
        });
        print('Number table => $number');
      },
    );
  }

  @override
  void initState() {
    readTable();
    title = 'กรุณาเลือกวันที่ต้องการเช็คข้อมูล';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: status == 'true' ? showData() : noData());
  }
}
