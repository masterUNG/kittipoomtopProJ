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

  String? username;

  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username')!;
    });
    print('Username == $username');
  }

  Widget showLogo() {
    return Container(
      width: 80,
      height: 80,
      child: CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage('assets/images/icon.png'),
      ),
    );
  }

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
    return Scaffold(
      backgroundColor: MyConstant.primary,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              showLogo(),
              SizedBox(
                height: 30.0,
              ),
              Text(
                username == null ? 'Hang Out' : 'ยินดีต้อนรับ $username',
                style: MyFont().white18,
              ),
              Text(
                'Facebook : @HangoutWithYouOfficial ',
                style: MyFont().white18,
              ),
              SizedBox(
                height: 40.0,
              ),
              _buildLogoutBtn(),
            ],
          ),
        ],
      ),
    );
  }
}
