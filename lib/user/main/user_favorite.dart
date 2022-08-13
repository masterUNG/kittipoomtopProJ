import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';

class UserFavorite extends StatefulWidget {
  const UserFavorite({Key? key}) : super(key: key);

  @override
  _UserFavoriteState createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text(
          'Favorite',
          style: MyFont().white,
        ),
      ),
      backgroundColor: MyConstant.primary,
      body: Center(
        child: Text('Comming Soon 123',style: MyFont().white16,),
      ),
    );
  }
}
