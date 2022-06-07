import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';

class UserFavorite extends StatefulWidget {
  const UserFavorite({Key? key}) : super(key: key);

  @override
  _UserFavoriteState createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.primary,
      body: Center(
        child: Text('Favorite'),
      ),
    );
  }
}
