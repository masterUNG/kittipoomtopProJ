import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:hangout/models/table_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBooking extends StatefulWidget {
  final UserModel userModel;
  const AddBooking({Key? key, required this.userModel, TableModel? tableModels})
      : super(key: key);

  @override
  _AddBookingState createState() => _AddBookingState();
}

class _AddBookingState extends State<AddBooking> {
  String? idUser,
      timeBooking,
      timeToday,
      today,
      table,
      username,
      numberTable,
      phone,
      imageTable;
  String? title, testNum;

  TableModel? tableModel;

  List<String> myList = [];

  List<TableModel> tableModels = [];

  UserModel? userModel;

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Future<Null> findUser() async {
    //ข้อมูลลูกค้า
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString('id');
      username = preferences.getString('username');
      phone = preferences.getString('phone');
    });

    print('IdUser is ==> $username');
    print('Phone is ==> $phone');
  }

  Future<Null> readTable() async {
    if (tableModels.length != 0) {
      tableModels.clear();
      myList.clear();
    }
    String url =
        '${MyConstant.domain}/hangout/getTableWhereId.php?isAdd=true&idStore=${widget.userModel.id}';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          tableModel = TableModel.fromMap(item);
          if (tableModel?.bookingDate == timeBooking) {
            setState(() {
              tableModels.add(tableModel!);
              myList.add(tableModel!.numberTable);
            });
          }
        }
      }
    });
    print('จำนวนโต๊ะ : ${tableModels.length}');
  }

  Future<Null> readTable2() async {
    if (tableModels.length != 0) {
      tableModels.clear();
      myList.clear();
    }

    String url =
        '${MyConstant.domain}/hangout/getTableWhereId.php?isAdd=true&idStore=${widget.userModel.id}';

    await Dio().get(url).then((value) {
      //*ป้องกันค่า null แล้วเกิด bug
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          tableModel = TableModel.fromMap(item);
          if (tableModel?.bookingDate == timeBooking) {
            setState(() {
              tableModels.add(tableModel!);
              myList.add(tableModel!.numberTable);
            });
          }
        }
      }
    });
    //print('วันที่ => ${tableModel?.bookingDate}  == $timeBooking');
    print('จำนวนโต๊ะ : ${tableModels.length}');
    //print(myList.contains(10));
    Navigator.of(context).pop();
  }

  Widget noData() {
    return Scaffold(
      body: Center(
          child: Text(
        'ยังเปิดให้จองในขณะนี้',
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
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            _dateCeledar(),
            SizedBox(
              height: 20.0,
            ),
            tableModels.length == 0
                ? Center(
                    child: Text(
                    title!,
                    style: MyFont().white18,
                  ))
                : chooseTable(),
          ],
        ),
      ),
      backgroundColor: MyConstant.primary,
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
            title = 'ยังไม่มีให้จองในขณะนี้';
            String _dateTime = DateFormat('d MMMM y').format(_selectedValue);
            timeBooking = _dateTime;
          });
          MyDialog().loadingDialog(context);
          readTable2();
        },
      ),
    );
  }

  Future<Null> addTableUser() async {
    DateTime dateTime = DateTime.now();
    String orderDateTime = DateFormat('d MMMM y HH:mm').format(dateTime);
    bool checkIn = false;
    bool status = true;

    try {
      String urlInsertData =
          '${MyConstant.domain}/hangout/addTableHistory.php?isAdd=true&NumberTable=$numberTable&idStore=${widget.userModel.id}&idUser=$idUser&Username=$username&NameStore=${widget.userModel.nameStore}&DateTime=$orderDateTime&CheckIn=$checkIn&BookingDate=${tableModel!.bookingDate}&Status=$status&Phone=$phone';
      Response response = await Dio().get(urlInsertData);
      if (response.toString() == 'true') {
        print('Success');
      } else {
        print('Fail');
      }
    } catch (e) {}

    try {
      String urlInsertData =
          '${MyConstant.domain}/hangout/addNumberTableUser.php?isAdd=true&NumberTable=$numberTable&idStore=${widget.userModel.id}&idUser=$idUser&Username=$username&NameStore=${widget.userModel.nameStore}&DateTime=$orderDateTime&CheckIn=$checkIn&BookingDate=${tableModel!.bookingDate}&Status=$status&Phone=$phone';
      Response response = await Dio().get(urlInsertData);
      if (response.toString() == 'true') {
        Navigator.pop(context);
        //notificationToStore(idStore);
        MyDialog().successDialog(
            context, 'Successfully !!', 'จองโต๊ะ $numberTable สำเร็จ');
        deleteNumber();
      } else {
        MyDialog().failDialog(context, 'Oops', 'กรุณาลองใหม่อีกครั้งค่ะ');
      }
    } catch (e) {}
  }

  Future<Null> deleteNumber() async {
    String url =
        '${MyConstant.domain}/hangout/deleteTableWhereIdStoreAndNumberTable.php?isAdd=true&idStore=${widget.userModel.id}&NumberTable=$numberTable&BookingDate=${tableModel!.bookingDate}';
    await Dio().get(url).then((value) => {});
  }

  Widget chooseTable() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0, left: 10.0),
            height: 250.0,
            child: Image(
                image: NetworkImage(
                    '${MyConstant.domain}${widget.userModel.imageTable}')),
          ),
          SizedBox(
            height: 20.0,
          ),
          numberTable == null
              ? Text(
                  'ยังไม่ได้เลือกที่นั่ง',
                  style: MyFont().white16,
                )
              : Text(
                  'โต๊ะที่คุณเลือกคือ $numberTable',
                  style: MyFont().white16,
                ),
          SizedBox(
            height: 10.0,
          ),
          chairPosition(),
          SizedBox(
            height: 10.0,
          ),
          btnConfirm(),
        ],
      ),
    );
  }

  Widget btnConfirm() {
    return ElevatedButton.icon(
      onPressed: () {
        if (numberTable == null) {
          MyDialog().failDialog(context, 'Oops', 'กรุณาเลือกที่นั่ง');
        } else {
          addTableUser();
        }
      },
      icon: Icon(
        Icons.add_shopping_cart,
        size: 25.0,
        color: Colors.black,
      ),
      label: Text(
        'จองร้านอาหาร',
        style: MyFont().black16,
      ),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.light,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //textStyle: TextStyle(
        //fontSize: 30,
        //fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<Null> checkId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUser = preferences.getString('id');
    });
    String url =
        '${MyConstant.domain}/hangout/getTableWhereIdUserBeforeBooking.php?isAdd=true&idUser=$idUser';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);

    if (result.toString() == 'null') {
    } else {
      Navigator.pop(context);
      MyDialog().failDialog(context, 'Sorry', 'จองได้ 1 โต๊ะต่อ 1 วัน');
    }
    //print('result ==> $result');
    //print('idUser2 ==> $idUser');
  }

  Widget btnChair(String number, bool status) {
    return AnimatedButton(
      height: 40,
      width: 50,
      text: '$number',
      isReverse: true,
      selectedBackgroundColor:
          myList.contains('$number') ? Colors.white : MyConstant.primary,
      selectedTextColor: Colors.black,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      textStyle: MyFont().white16,
      backgroundColor:
          myList.contains('$number') ? MyConstant.focus : MyConstant.primary,
      borderColor: MyConstant.light,
      borderRadius: 10,
      borderWidth: 2,
      onPress: () {
        if (myList.contains('$number')) {
          //MyDialog().loadingDialog(context);
          print('หมายเลขโต๊ะ : $number \n วันที่ $timeBooking');
          setState(() {
            status = !status;
            numberTable = number;
          });
        }
      },
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

  @override
  void initState() {
    userModel = widget.userModel;
    findUser();
    readTable();
    checkId();
    title = 'กรุณาเลือกวันที่ต้องการจอง';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Booking',
            style: MyFont().white,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: MyConstant.primary,
        ),
        body: widget.userModel.status == 'true' ? showData() : noData());
  }
}
