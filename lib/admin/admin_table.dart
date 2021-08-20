import 'package:flutter/material.dart';

class AdminTable extends StatefulWidget {
  const AdminTable({Key? key}) : super(key: key);

  @override
  _AdminTableState createState() => _AdminTableState();
}

class _AdminTableState extends State<AdminTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Table'),
      ),
    );
  }
}
