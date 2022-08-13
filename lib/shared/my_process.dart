// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hangout/shared/dialog.dart';

class MyProcess {
  final BuildContext context;
  MyProcess({
    required this.context,
  });

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String token}) async {
    String path =
        'http://hangoutwithyou.com/hangout/ungNoti.php?isAdd=true&token=$token&title=$title&body=$body';
    await Dio().get(path).then((value) {
      print('##13aug Send Noti Success');
    });
  }

  Future<void> setupMessaging({required String idUserLogin}) async {
    print('##13aug setupMessateing work');
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print('##13aug token ===< $token');

    String path =
        'http://hangoutwithyou.com/hangout/editTokenWhereId.php?isAdd=true&id=$idUserLogin&Token=$token';
    await Dio().get(path).then((value) {
      print('##13aug Edit Token Success');
    });

    //Open App
    FirebaseMessaging.onMessage.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      print('##13aug Open App ==> title = $title, body = $body');
      notiDialog(title: title!, body: body!);
    });

    //Close App
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title = event.notification!.title;
      String? body = event.notification!.body;
      print('##13aug Close App ==> title = $title, body = $body');
      notiDialog(title: title!, body: body!);
    });
  }

  Future<void> notiDialog({required String title, required String body}) async {
    await MyDialog().successDialog(context, title, body).then((value) => null);
  }
}
