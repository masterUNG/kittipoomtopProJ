import 'package:flutter/material.dart';
import 'package:hangout/shared/font.dart';

class MyDialog {

  Future<Null> successDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.auto_awesome_outlined,
            color: Colors.teal,
          ),
          title: Text(
            title,
            style: MyFont().black16Bold,
          ),
          subtitle: Text(
            message,
            style: MyFont().black16,
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',style: MyFont().black16,),
          ),
        ],
      ),
    );
  }

  Future<Null> failDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.assignment_late_rounded ,
            color: Colors.redAccent,
          ),
          title: Text(
            title,
            style: MyFont().black16Bold,
          ),
          subtitle: Text(
            message,
            style: MyFont().black16,
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK',style: MyFont().black16,),
          ),
        ],
      ),
    );
  }
}
