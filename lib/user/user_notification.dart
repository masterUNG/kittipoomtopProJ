import 'package:flutter/material.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({ Key? key }) : super(key: key);

  @override
  _UserNotificationState createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Notification'),
      ),
    );
  }
}
