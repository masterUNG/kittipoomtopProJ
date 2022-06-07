import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:hangout/shared/chair.dart';
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
  Widget chairList() {
    Size size = MediaQuery.of(context).size;
    // 1 = free
    // 2 = select
    // 3 = reserved
    var _chairStatus = [
      [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
      ],
      [
        1,
        1,
        1,
        1,
        3,
        1,
        1,
      ],
      [
        1,
        1,
        1,
        1,
        1,
        3,
        3,
      ],
      [
        2,
        2,
        2,
        1,
        3,
        1,
        1,
      ],
      [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
      ],
      [
        1,
        1,
        1,
        1,
        1,
        1,
        1,
      ],
    ];

    return Container(
      child: Column(
        children: [
          for (int i = 0; i < 6; i++)
            Container(
              margin: EdgeInsets.only(top: i == 3 ? size.height * 0.02 : 0),
              child: Row(
                children: [
                  for (int x = 0; x < 9; x++)
                    Expanded(
                        flex: x == 0 || x == 8 ? 2 : 1,
                        child: x == 0 ||
                                x == 8 ||
                                (i == 0 && x == 0) ||
                                (i == 0 && x == 8) ||
                                (x == 4)
                            ? Container()
                            : Container(
                                height: size.width / 11 - 10,
                                margin: EdgeInsets.all(5.0),
                                child: _chairStatus[i][x - 1] == 1
                                    ? MyChairs.availbleChair()
                                    : _chairStatus[i][x - 1] == 2
                                        ? MyChairs.selectedChair()
                                        : MyChairs.reservedChair())),
                ],
              ),
            )
        ],
      ),
    );
  }

  String? idUser, timeBooking, timeToday, today, table, username, numberTable;
  String? title, testNum, status, tableNumber;

  List<String> myList = [];

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
    String? statusStore = preferences.getString('status');
    setState(() {
      status = statusStore;
    });

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
              myList.add(tableModelUser!.numberTable);
            });
          }
        }
      }
    });
    print('Status = $statusStore');
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
              myList.add(tableModelUser!.numberTable);
            });
          }
        }
      }
    });
    print(myList.contains(10));
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
        margin: EdgeInsets.all(10.0),
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
    setState(() {
      String _dateTime = DateFormat('yyyy-MM-dd').format(_selectedValue);
      timeBooking = _dateTime;
    });
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
          MyDialog().loadingDialog(context);
          setState(() {
            _selectedValue = date;
            title = 'ยังไม่มีจองในขณะนี้';
          });
          readTable2();
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
        findInfoUser();
        print('Number table => $number');
      },
    );
  }

  Future<void> findInfoUser() async {
    print('Number table Find => $tableNumber');
    if (tableModelUser!.numberTable == tableNumber) {
      openDialogHaveInfo();
    } else {
      openDialogNoInfo();
    }
  }

  Future openDialogHaveInfo() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              'ข้อมูลลูกค้าที่จอง',
              style: MyFont().black16,
            ),
            content: Container(
              height: 80.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ชื่อผู้ใช้ = ${tableModelUser?.username}',
                    style: MyFont().black16,
                  ),
                  Text(
                    'เวลาที่จอง = ${tableModelUser?.bookingDate}',
                    style: MyFont().black16,
                  ),
                ],
              ),
            )),
      );

  Future openDialogNoInfo() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              'ข้อมูลลูกค้าที่จอง',
              style: MyFont().black16,
            ),
            content: Container(
              height: 80.0,
              child: Center(
                child: Text(
                  'โต๊ะนี้ยังไม่ถูกจอง',
                  style: MyFont().black16,
                ),
              ),
            )),
      );

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
