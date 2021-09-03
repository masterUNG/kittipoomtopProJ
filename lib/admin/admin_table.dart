import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';

class AdminTable extends StatefulWidget {
  const AdminTable({Key? key}) : super(key: key);

  @override
  _AdminTableState createState() => _AdminTableState();
}

class _AdminTableState extends State<AdminTable> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Text('Table Store'),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.rountAddTable),
            child: Text('Add',style: MyFont().white16,),
            backgroundColor: MyConstant.focus,
      ),
    );
  }
}
