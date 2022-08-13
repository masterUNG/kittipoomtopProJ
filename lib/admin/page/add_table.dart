import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTable extends StatefulWidget {
  const AddTable({Key? key}) : super(key: key);

  @override
  _AddTableState createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  UserModel? userModel;
  String? _timeBooking, nameStore, idStore, numberTable;
  TextEditingController numberController = TextEditingController();

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Widget _dateCalendar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        controller: _controller,
        //initialSelectedDate: DateTime.now(),
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
            String _dateTime = DateFormat('d MMMM y').format(_selectedValue);
            _timeBooking = _dateTime;
          });
          print(_timeBooking);
        },
      ),
    );
  }

  Widget info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '',
          style: MyFont().black18Bold,
        ),
        Text(
          '',
          style: MyFont().black18,
        ),
      ],
    );
  }

  Widget _content() {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: <Widget>[
            _dateCalendar(),
            SizedBox(
              height: 20.0,
            ),
            _timeBooking == null ? _noContent() : _data() 
          ],
        ),
      ),
    );
  }

  Widget _noContent() {
    return Center(
      child: Text('กรุณาเลือกวันที่',style: MyFont().black18,),
    );
  }

  Widget _data() {
    return Column(
      children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnChair(1, false),
                    btnChair(2, false),
                    btnChair(3, false),
                    btnChair(4, false),
                    btnChair(5, false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnChair(6, false),
                    btnChair(7, false),
                    btnChair(8, false),
                    btnChair(9, false),
                    btnChair(10, false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnChair(11, false),
                    btnChair(12, false),
                    btnChair(13, false),
                    btnChair(14, false),
                    btnChair(15, false),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnChair(16, false),
                    btnChair(17, false),
                    btnChair(18, false),
                    btnChair(19, false),
                    btnChair(20, false),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            _timeBooking == null
                ? Text(
                    'กรุณาเลือกวันที่',
                    style: MyFont().black18,
                  )
                : Text(
                    'วันที่ $_timeBooking',
                    style: MyFont().black18,
                  ),
            SizedBox(
              height: 10.0,
            ),
            //_confirmBth(size),
            info(),
      ],
    );
  }

  Future<Null> _addNumber(int table, bool status) async {
    String urlInsertData =
        '${MyConstant.domain}/hangout/addTable.php?isAdd=true&idStore=$idStore&NameStore=$nameStore&NumberTable=$table&BookingDate=$_timeBooking&Status=$status';
    await Dio().get(urlInsertData).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        MyDialog().successDialog(context, 'Successfully !!', 'เพิ่มโต๊ะสำเร็จ');
      } else {
        MyDialog().failDialog(context, 'Oops', 'กรุณาลองใหม่อีกครั้งค่ะ');
      }
    });
  }

  Future<Null> find() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getUserWhereId.php?isAdd=true&id=$id}';
    await Dio().get(apiGetInfo).then((value) {
      if (value.toString() == 'null') {
        //No Data

      } else {
        //Have Data
        for (var item in json.decode(value.data)) {
          setState(() {
            userModel = UserModel.fromMap(item);
            nameStore = userModel!.nameStore;
            idStore = userModel!.id;
          });
        }
      }
    });
    //print(nameStore);
    //print(idStore);
  }

  Widget btnChair(int number, bool status) {
    return AnimatedButton(
      height: 40,
      width: 60,
      text: '$number',
      isReverse: true,
      selectedBackgroundColor: MyConstant.focus,
      selectedTextColor: Colors.white,
      transitionType: TransitionType.LEFT_TO_RIGHT,
      textStyle: MyFont().white16,
      backgroundColor: MyConstant.primary,
      borderColor: MyConstant.light,
      borderRadius: 10,
      borderWidth: 2,
      onPress: () {
        MyDialog().loadingDialog(context);
        print('หมายเลขโต๊ะ : $number \n วันที่ $_timeBooking');
        setState(() {
          status = !status;
        });
        print(status);
        _addNumber(number, status);
      },
    );
  }

  @override
  void initState() {
    find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double size = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'เพิ่มโต๊ะ',
          style: MyFont().white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: _content()),
    );
  }
}
