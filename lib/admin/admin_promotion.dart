import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';

class AdminPromotion extends StatefulWidget {
  const AdminPromotion({Key? key}) : super(key: key);

  @override
  _AdminPromotionState createState() => _AdminPromotionState();
}

class _AdminPromotionState extends State<AdminPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Promotion'),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.rountAddPromotion),
            child: Text('Add'),
            backgroundColor: MyConstant.focus,
      ),
    );
  }
}
