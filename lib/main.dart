import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/admin/admin_main.dart';
import 'package:hangout/auth/authentication.dart';
import 'package:hangout/auth/sign_in.dart';
import 'package:hangout/auth/sign_up.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/user/user_main.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authentication(),
  '/sign_in': (BuildContext context) => SignIn(),
  '/sign_up': (BuildContext context) => SignUp(),
  '/adminMain': (BuildContext context) => AdminMain(),
  '/userMain': (BuildContext context) => UserMain(),
};

String? initialRoute;

void main() {
  initialRoute = MyConstant.rountSignIn;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: MyConstant.primary
      ),
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
