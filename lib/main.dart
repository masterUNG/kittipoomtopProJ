import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/admin/admin_main.dart';
import 'package:hangout/auth/sign_in.dart';
import 'package:hangout/user/user_home.dart';
import 'package:hangout/user/user_main.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Hangout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: UserMain(),
    );
  }
}
