import 'package:flutter/material.dart';
import 'package:hangout/models/promotion_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';

import 'component/body.dart';

class DetailStore extends StatefulWidget {
  final UserModel userModel;
  const DetailStore(
      {Key? key,
      required this.userModel,
      PromotionModel? promotionModel})
      : super(key: key);

  @override
  _DetailStoreState createState() => _DetailStoreState();
}

class _DetailStoreState extends State<DetailStore> {
  UserModel? userModel;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.primary,
      body: Body(userModel: userModel!),
    );
  }
}


