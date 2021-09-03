import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

   Widget _buildLogoutBtn() {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear().then(
              (value) => Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.rountSignIn, (route) => false),
            );
      },
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LOGOUT',
            style: MyFont().white,
          ),
          //Text(data)
        ],
      ),
      style: ElevatedButton.styleFrom(
          primary: MyConstant.focus,
          fixedSize: Size(300, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
          body: ListView(children: [
            _buildLogoutBtn(),
          ],)
    );
  }
}
