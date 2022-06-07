import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/promotion_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPromotion extends StatefulWidget {
  const AdminPromotion({Key? key}) : super(key: key);

  @override
  _AdminPromotionState createState() => _AdminPromotionState();
}

class _AdminPromotionState extends State<AdminPromotion> {
  bool load = true; // load JSON
  bool? haveData; //have data
  List<PromotionModel> promotionModels = [];

  @override
  void initState() {
    readPromotion();
    super.initState();
  }

  Future<Null> readPromotion() async {
    if (promotionModels.length != 0) {
      promotionModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;
    String apiGetInfo =
        '${MyConstant.domain}/hangout/getPromotionWhereIdStore.php?isAdd=true&idStore=$idStore';
    await Dio().get(apiGetInfo).then((value) {
      //print(value);
      if (value.toString() == 'null') {
        //No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        //Have Data
        for (var item in json.decode(value.data)) {
          PromotionModel promotionModel = PromotionModel.fromMap(item);
          print('Promotion >> ${promotionModel.promotion}');
          setState(() {
            load = false;
            haveData = true;
            promotionModels.add(promotionModel);
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
              ListTile(
                leading: Container(
                  height: 70.0,
                  width: 70.0,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}${promotionModels[index].imagePromotion}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShowProgress(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/icon.png'),
                  ),
                ),
                title: Text(
                  '${promotionModels[index].promotion}',
                  style: MyFont().white18,
                ),
                subtitle: Text(
                  'รายละเอียด ${promotionModels[index].detail}',
                  style: MyFont().white16,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () =>
                      deletePromotionDialog(promotionModels[index]),
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

  Future<Null> deletePromotionDialog(PromotionModel promotionModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Icon(
            Icons.assignment_late_rounded,
            color: Colors.redAccent,
            size: 50.0,
          ),
          title: Text(
            'แจ้งเตือน',
            style: MyFont().black18Bold,
          ),
          subtitle: Text(
            'คุณต้องการลบ ${promotionModel.promotion} ใช่หรือไม่ ?',
            style: MyFont().black16,
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  String url =
                      '${MyConstant.domain}/hangout/deletePromotionWhereId.php?isAdd=true&id=${promotionModel.id}';
                  await Dio().get(url).then((value) => readPromotion());
                },
                child: Text(
                  'ตกลง',
                  style: MyFont().black16,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: MyFont().black16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _noInfo(double size) {
    return Container(
      child: Center(
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, MyConstant.rountAddPromotion)
                  .then((value) => readPromotion()),
          child: Text(
            'กรุณาเพิ่มโปรโมชั่น',
            style: MyFont().white18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? showListPromotion()
              : _noInfo(size),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.rountAddPromotion)
                .then((value) => readPromotion()),
        child: Text(
          'Add',
          style: MyFont().white,
        ),
        backgroundColor: MyConstant.focus,
      ),
      backgroundColor: MyConstant.primary,
    );
  }
}
