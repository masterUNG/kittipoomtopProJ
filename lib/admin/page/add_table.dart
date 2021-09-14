import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  List<String> numberTable = [];

  String? _timeBooking, nameStore, idStore;

  TextEditingController numberController = TextEditingController();

  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Widget _tableForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 280.0,
          child: TextFormField(
            controller: numberController,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyConstant.light,
              hintStyle: MyFont().grey16,
              hintText: 'หมายเลขโต๊ะ :',
              hoverColor: Colors.black,
              prefixIcon: Icon(
                Icons.add_shopping_cart,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(20.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateCeledar() {
    String _dateTime = DateFormat('yyyy-MM-dd').format(_selectedValue);
    _timeBooking = _dateTime;
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 80,
        controller: _controller,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        inactiveDates: [
          //DateTime.now().add(Duration(days: 3)),
          //DateTime.now().add(Duration(days: 4)),
          //DateTime.now().add(Duration(days: 7))
        ],
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
          });
        },
      ),
    );
  }

  Widget _confirmBth(double size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: size / 2,
      child: ElevatedButton(
        onPressed: () {
          //String number = numberController.text;
          print('มหายเลขโต๊ะ : $numberTable \n วันที่ $_timeBooking');
          _addNumber();
        },
        child: Text(
          'ยืนยัน',
          style: MyFont().white16,
        ),
        style: ElevatedButton.styleFrom(
            primary: MyConstant.focus,
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget info() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'วิธีการเพิ่มโต๊ะ',
            style: MyFont().black18Bold,
          ),
          Text(
            '1.เลือกวันที่\n2.พิมพ์หมายเลขโต๊ะ\n3.กด + เพื่อเพิ่มโต๊ะ หรือ กด - เพื่อลบโต๊ะที่ไม่ต้องการ\n4.กดยืนยัน',
            style: MyFont().black18,
          ),
        ],
      ),
    );
  }

  Widget _content() {
    double size = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: <Widget>[
            _dateCeledar(),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _tableForm(),
            ),
            addOrRemove(),
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
            numberTable.isEmpty
                ? Text(
                    'กรุณาเพิ่มโต๊ะสำหรับให้ลูกค้าจอง',
                    style: MyFont().black16,
                  )
                : Text(
                    'โต๊ะที่เพิ่ม $numberTable',
                    style: MyFont().black18,
                  ),
            _confirmBth(size),
            info(),
          ],
        ),
      ),
    );
  }

  Widget addOrRemove() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                String number = numberController.text;
                numberTable.add(number);
              });
              print(numberTable);
            },
            icon: Icon(Icons.add_circle)),
        IconButton(
          onPressed: () {
            setState(() {
              String number = numberController.text;
              numberTable.remove(number);
            });
            print(numberTable);
          },
          icon: Icon(Icons.remove_circle),
        ),
      ],
    );
  }

  Future<Null> _addNumber() async {
    if (numberTable.isNotEmpty) {
      String urlInsertData =
          '${MyConstant.domain}/hangout/addTable.php?isAdd=true&idStore=$idStore&NameStore=$nameStore&NumberTable=$numberTable&BookingDate=$_timeBooking';
      await Dio().get(urlInsertData).then((value) {
        _content();
        if (value.toString() == 'true') {
          Navigator.pop(context);
          MyDialog()
              .successDialog(context, 'Successfully !!', 'เพิ่มโต๊ะสำเร็จ');
          //showToast('เพิ่มโต๊ะสำเร็จ โต๊ะ$numberTable');
        } else {
          MyDialog().failDialog(context, 'Oops', 'กรุณาลองใหม่อีกครั้งค่ะ');
        }
      });
    } else {
      MyDialog().failDialog(context, 'Sorry', 'กรุณาใส่ข้อมูล');
    }
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
        brightness: Brightness.dark,
        title: Text(
          'เพิ่มโต๊ะ',
          style: MyFont().white,
        ),
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: _content()),
    );
  }
}
