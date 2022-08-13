import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hangout/admin/main/admin_main.dart';
import 'package:hangout/admin/page/add_event.dart';
import 'package:hangout/admin/page/add_info.dart';
import 'package:hangout/admin/page/add_promotion.dart';
import 'package:hangout/auth/sign_in.dart';
import 'package:hangout/auth/sign_up.dart';
//import 'package:hangout/mongoDB/mongodb.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/splash.dart';
import 'package:hangout/user/main/user_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin/page/add_table.dart';

final Map<String, WidgetBuilder> map = {
  '/sign_in': (BuildContext context) => SignIn(),
  '/sign_up': (BuildContext context) => SignUp(),
  '/adminMain': (BuildContext context) => AdminMain(),
  '/userMain': (BuildContext context) => UserMain(),
  '/addPromotion': (BuildContext context) => AddPromotion(),
  '/addInfo': (BuildContext context) => AddInfo(),
  '/addTable': (BuildContext context) => AddTable(),
  '/splash': (BuildContext context) => Splash(),
  '/addEvent': (BuildContext context) => AddEvent(),
};

String? initialRoute;

Future<void> main() async {

  //Splash Screen
  FlutterNativeSplash.remove();


  //Auto login ถ้าเคย login แล้ว

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type'); //ดึงค่า type  ออกมา
  //await MongoDatabase.connect();

  //print('type>> $type'); เช็ค type

  if (type?.isEmpty ?? true) {
    //เป็น null หรือ isEmpty
    initialRoute = MyConstant.rountSignIn;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'User':
        initialRoute = MyConstant.rountUserMain;
        runApp(MyApp());
        break;
      case 'Store':
        initialRoute = MyConstant.rountAdminMain;
        runApp(MyApp());
        break;
      default:
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: MyConstant.primary,
      ),
      debugShowCheckedModeBanner: false,
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
