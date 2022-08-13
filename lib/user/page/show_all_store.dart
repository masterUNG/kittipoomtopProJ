import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/user/page/detailStore/detail_store.dart';

class ShowAllStore extends StatefulWidget {
  const ShowAllStore({Key? key}) : super(key: key);

  @override
  _ShowAllStoreState createState() => _ShowAllStoreState();
}

class _ShowAllStoreState extends State<ShowAllStore> {
  UserModel? userModel;
  List<UserModel> userModels = [];
  int index = 0;
  String? imageStore;

  @override
  void initState() {
    super.initState();
    readStore();
  }

  Future<Null> readStore() async {
    //ดึงช้อมูลที่เป็นร้านอย่างเดียว
    String url =
        '${MyConstant.domain}/hangout/getUserWhereChooseType.php?isAdd=true&chooseType=Store';
    await Dio().get(url).then((value) {
      for (var item in json.decode(value.data)) {
        userModel = UserModel.fromMap(item);
        String nameStore = userModel!.nameStore;
        String verify = userModel!.verify;
        if (nameStore.isNotEmpty && verify == 'ยืนยัน') {
          setState(() {
            index++;
            userModels.shuffle();
            userModels.add(userModel!);
            
          });
        }
      }
    });
  }

  String createUrl1(BuildContext context, int index) {
    //แยกStringในArray
    String result = userModels[index]
        .imageUrl
        .substring(1, userModels[index].imageUrl.length - 1);
    List<String> strings = result.split(', ');

    String urls = '${strings[0]}';

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 16.8),
      height: 124.8,
      child: ListView.builder(
        itemCount: userModels.length,
        padding: EdgeInsets.only(right: 12.0),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => DetailStore(
                        userModel: userModels[index],
                      ));
              Navigator.push(context, route);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 124.8,
                      width: 188.4,
                      margin: EdgeInsets.only(right: 16.8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(createUrl1(context, index)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 12),
                      child: Column(
                        children: [
                          Text(
                            userModels[index].nameStore,
                            style: MyFont().white16,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
