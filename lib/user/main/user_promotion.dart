import 'package:flutter/material.dart';

class UserPromotion extends StatefulWidget {
  const UserPromotion({ Key? key }) : super(key: key);

  @override
  _UserPromotionState createState() => _UserPromotionState();
}

class _UserPromotionState extends State<UserPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Promotion'),
      ),
    );
  }
}
