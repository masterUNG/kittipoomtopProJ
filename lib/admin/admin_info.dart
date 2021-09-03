import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  _AdminInfoState createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {

  Widget _buildLogoutBtn(double size) {
    return Container(
      width: size/2,
      child: ElevatedButton(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Text('Infomation'),
          _buildLogoutBtn(size),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.rountAddInfo),
            child: Text('Add/Edit',style: TextStyle(fontSize: 10.0),),
            backgroundColor: MyConstant.focus,
      ),
    );
  }
}
