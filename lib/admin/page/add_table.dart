import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:intl/intl.dart';

class AddTable extends StatefulWidget {
  const AddTable({Key? key}) : super(key: key);

  @override
  _AddTableState createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {
  
  String? _timeBooking;

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
        )
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
          String number = numberController.text;
          print('มหายเลขโต๊ะ : $number \n วันที่ $_timeBooking');
        },
        child: Text(
          'CONFIRM',
          style: MyFont().white,
        ),
        style: ElevatedButton.styleFrom(
            primary: MyConstant.focus,
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _content() {
    double size = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          _timeBooking == null
              ? Text(
                  'กรุณาเลือกวันที่',
                  style: MyFont().black18,
                )
              : Text(
                  'วันที่ $_timeBooking',
                  style: MyFont().black18,
                ),
          _confirmBth(size),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
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
