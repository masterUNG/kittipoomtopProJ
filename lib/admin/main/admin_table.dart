import 'dart:convert';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/table_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AdminTable extends StatefulWidget {
  const AdminTable({Key? key}) : super(key: key);

  @override
  _AdminTableState createState() => _AdminTableState();
}

class _AdminTableState extends State<AdminTable> {
  
  String? timeBooking, title;
  bool load = true;
  bool haveData = false;
  List<TableModel> tableModels = [];
  TableModel? tableModel;
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();

  Widget dateCalendar() {
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
        //initialSelectedDate: DateTime.now(),
        selectionColor: Colors.white,
        selectedTextColor: MyConstant.focus,
        deactivatedColor: Colors.grey,
        
        onDateChange: (date) {
          setState(() {
            haveData = true;
            _selectedValue = date;
            title = 'ยังไม่ได้เพิ่มโต๊ะ';
          });
          MyDialog().loadingDialog(context);
          readTable2();
        },
      ),
    );
  }

  Future<Null> readTable() async {
    if (tableModels.length != 0) {
      tableModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getTableWhereId.php?isAdd=true&idStore=$idStore';
    await Dio().get(apiGetInfo).then((value) {
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          load = false;
          haveData = true;
          tableModel = TableModel.fromMap(item);
          if (tableModel?.bookingDate == timeBooking) {
            setState(() {
              tableModels.add(tableModel!);
            });
          }
        }
      } else {
        haveData = false;
      }
    });

    print(tableModels.length);
  }

  Future<Null> readTable2() async {
    if (tableModels.length != 0) {
      tableModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getTableWhereId.php?isAdd=true&idStore=$idStore';
    await Dio().get(apiGetInfo).then((value) {
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          load = false;
          haveData = true;
          tableModel = TableModel.fromMap(item);
          if (tableModel?.bookingDate == timeBooking) {
            setState(() {
              tableModels.add(tableModel!);
            });
          }
        }
      } else {
        haveData = false;
      }
    });
    Navigator.of(context).pop();
    print(tableModels.length);
  }

  Future<Null> deleteTableDialog(String id) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.assignment_late_rounded,
            color: Colors.redAccent,
          ),
          title: Text(
            'คุณแน่ใจนะ ?',
            style: MyFont().black16Bold,
          ),
          subtitle: Text(
            'ลบโต๊ะที่คุณเลือก',
            style: MyFont().black16,
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  MyDialog().loadingDialog(context);
                  String url =
                      '${MyConstant.domain}/hangout/deleteTableWhereId.php?isAdd=true&id=$id';
                  await Dio().get(url).then((value) {
                    readTable2();
                  });
                },
                child: Text(
                  'ตกลง',
                  style: MyFont().black16,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: MyFont().black16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _listNumberTable() => ListView.builder(
        itemCount: tableModels.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.chair),
                  color: Colors.amber,
                  iconSize: 35.0,
                  onPressed: () {},
                ),
                title: Text('โต๊ะที่ ${tableModels[index].numberTable}',
                    style: MyFont().white18),
                subtitle: Text('วันที่ ${tableModels[index].bookingDate}',
                    style: MyFont().white18),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () async {
                      String id = tableModels[index].id;
                      //String nameStore = tableModelStores[index].nameStore;
                      //print('You click id = $id');
                      //print('You click id = $nameStore');
                      deleteTableDialog(id);
                    }),
              ),
              Divider(
                height: 2,
                color: Colors.grey.shade300,
              )
            ],
          ),
        ),
      );

  @override
  void initState() {
    //readTable();
    title = 'กรุณาเลือกวันที่';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            dateCalendar(),
            SizedBox(
              height: 20.0,
            ),
            tableModels.length == 0
                ? Center(
                    child: Text(
                      title!,
                      style: MyFont().white18,
                    ),
                  )
                : haveData == true
                    ? _listNumberTable()
                    : ShowProgress()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, MyConstant.rountAddTable)
            .then((value) => readTable()),
        child: Text(
          'Add',
          style: MyFont().white,
        ),
        backgroundColor: MyConstant.focus,
      ),
      backgroundColor: MyConstant.primary,
    );
  }
}
