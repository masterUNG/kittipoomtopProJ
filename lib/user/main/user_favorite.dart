import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/favorite_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/my_process.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFavorite extends StatefulWidget {
  const UserFavorite({Key? key}) : super(key: key);

  @override
  _UserFavoriteState createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  bool load = true;
  bool? haveData;
  var userModelShops = <UserModel>[];

  @override
  void initState() {
    super.initState();
    readFavoritModel();
  }

  Future<void> readFavoritModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUserLogin = preferences.getString('id');

    String urlAPI =
        'http://hangoutwithyou.com/hangout/getUserWhereIdFormFav.php?isAdd=true&idBuyer=$idUserLogin';
    await Dio().get(urlAPI).then((value) async {
      if (value.toString() == 'null') {
        haveData = false;
      } else {
        haveData = true;

        for (var element in json.decode(value.data)) {
          FavoriteModel favoriteModel = FavoriteModel.fromMap(element);
          String string = favoriteModel.idStore;
          string = string.substring(1, string.length - 1);
          var idShops = string.split(',');
          for (var i = 0; i < idShops.length; i++) {
            idShops[i] = idShops[i].trim();

            UserModel? userModel =
                await MyProcess(context: context).findUserModel(id: idShops[i]);
            // print('##14aug userModel ===> ${userModel!.toMap()}');
            if (userModel != null) {
              userModelShops.add(userModel);
            }
          }

          print('##14aug idShops ===>> $idShops');
        }
      }

      load = false;
      setState(() {});
    });
  }

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
      body: load
          ? const ShowProgress()
          : haveData!
              ? ListView.builder(itemCount: userModelShops.length,
                  itemBuilder: (context, index) => Text(
                    userModelShops[index].nameStore,
                    style: MyFont().white,
                  ),
                )
              : Center(
                  child: Text(
                    'No Favority',
                    style: MyFont().white16,
                  ),
                ),
    );
  }
}
