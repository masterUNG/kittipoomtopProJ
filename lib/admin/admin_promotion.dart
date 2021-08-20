import 'package:flutter/material.dart';

class AdminPromotion extends StatefulWidget {
  const AdminPromotion({ Key? key }) : super(key: key);

  @override
  _AdminPromotionState createState() => _AdminPromotionState();
}

class _AdminPromotionState extends State<AdminPromotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Promotion'),
      ),
    );
  }
}

