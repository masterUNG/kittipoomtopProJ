import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/table_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTable extends StatefulWidget {
  const AdminTable({Key? key}) : super(key: key);

  @override
  _AdminTableState createState() => _AdminTableState();
}

class _AdminTableState extends State<AdminTable> {
  bool load = true;
  bool haveData = false;
  List<TableModel> tableModels = [];
  TableModel? tableModel;
  //List<String> numberTable = [];

  Future<Null> readTable() async {
    if (tableModels.length != 0) {
      tableModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;
    //print(idStore);

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getTableWhereId.php?isAdd=true&idStore=$idStore';
    await Dio().get(apiGetInfo).then((value) {
      //print(value);

      if (value.toString() == 'null') {
        //No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        //Have Data
        for (var item in json.decode(value.data)) {
          setState(() {
            tableModel = TableModel.fromMap(item);
            tableModels.add(tableModel!);
            load = false;
            haveData = true;
            //numberTable = createUrl1();
          });
        }
      }
    });
  }

  List<String> createUrl1() {
    //แยกStringในArray
    String result = tableModel!.numberTable
        .substring(1, tableModel!.numberTable.length - 1);
    List<String> numbers = result.split(', ');

    return numbers;
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
                  String url =
                      '${MyConstant.domain}/hangout/deleteTableWhereId.php?isAdd=true&id=$id';
                  await Dio().get(url).then((value) => readTable());
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

  Widget _noInfo(double size) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, MyConstant.rountAddTable)
              .then((value) => readTable()),
          child: Text(
            'กรุณาเพิ่มโต๊ะสำหรับให้ลูกค้าจอง',
            style: MyFont().white18,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    readTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData == true
              ? _listNumberTable()
              : _noInfo(size),
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
