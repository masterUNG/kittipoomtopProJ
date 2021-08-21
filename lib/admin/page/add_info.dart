import 'package:flutter/material.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({ Key? key }) : super(key: key);

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('AddInfo'),
      ),
    );
  }
}
