import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({ Key? key }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Info'),
      ),
    );
  }
}
