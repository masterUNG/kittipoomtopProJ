import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hangout/models/promotion_model.dart';
import 'package:hangout/models/table_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PromotionStore extends StatefulWidget {
  final UserModel userModel;
  const PromotionStore(
      {Key? key, required this.userModel, PromotionModel? promotionModel})
      : super(key: key);

  @override
  _PromotionStoreState createState() => _PromotionStoreState();
}

class _PromotionStoreState extends State<PromotionStore> {
  bool loadStatus = true;
  bool haveData = false;
  List<UserModel> userModels = [];
  List<PromotionModel> promotionModels = [];
  String? idStore;

  UserModel? userModel;
  TableModel? tableModel;
  PromotionModel? promotionModel;

  Future<Null> readPromotion() async {
    idStore = widget.userModel.id;
    print('idStore == $idStore');

    if (promotionModels.length != 0) {
      loadStatus = true;
      haveData = true;
      promotionModels.clear();
    }

    String url =
        '${MyConstant.domain}/hangout/getPromotionWhereIdStore.php?isAdd=true&idStore=$idStore';
    await Dio().get(url).then((value) {
      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
          loadStatus = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          setState(() {
            promotionModel = PromotionModel.fromMap(item);
            promotionModels.add(promotionModel!);
            haveData = true;
            loadStatus = false;
          });
        }
      }
    });
  }

  Widget showListPromotion() => ListView.builder(
        itemCount: promotionModels.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  //showDetailPromotion(index);
                  print(
                      'namePromotion =>> ${promotionModels[index].promotion}');
                },
                child: ListTile(
                  leading: Container(
                    height: 60,
                    width: 80,
                    margin: EdgeInsets.only(right: 16.8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '${MyConstant.domain}${promotionModels[index].imagePromotion}'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${promotionModels[index].promotion} ',
                    style: MyFont().white16,
                  ),
                  subtitle: Text(
                    'รายละเอียด \n${promotionModels[index].detail}',
                    style: MyFont().white16,
                  ),
                  trailing: Text(
                    'ราคา ${promotionModels[index].price} ฿',
                    style: MyFont().white16,
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey.shade300,
              )
            ],
          ),
        ),
      );

  Widget _noInfo(double size) {
    return Container(
      child: Center(
        child: Text(
          'ยังไม่มีโปรโมชั่นในขณะนี้',
          style: MyFont().white18,
        ),
      ),
    );
  }

  @override
  void initState() {
    readPromotion();
    userModel = widget.userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.primary,
      appBar: AppBar(
        title: Text('โปรโมชั่น',style: MyFont().white,),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      body: loadStatus
          ? ShowProgress()
          : haveData == true
              ? showListPromotion()
              : _noInfo(size),
    );
  }
}
