import 'package:flutter/material.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  _AdminInfoState createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Info'),
      ),
    );
  }
}
