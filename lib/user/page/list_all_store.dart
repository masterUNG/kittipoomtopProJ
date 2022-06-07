import 'dart:convert';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'booking_page.dart';
import 'detailStore/detail_store.dart';
import 'promotion_store.dart';

class ListAllStore extends StatefulWidget {
  const ListAllStore({Key? key}) : super(key: key);

  @override
  _ListAllStoreState createState() => _ListAllStoreState();
}

class _ListAllStoreState extends State<ListAllStore> {
  
  UserModel? userModel;
  List<UserModel> userModels = [];
  int index = 0;

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

  Widget createCard(UserModel userModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
      child: Card(
        //color: HexColor('#e7e7e7'),
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 8.0,
        child: InkWell(
          onTap: () {
            print('You Click index $index');
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
                  Image.network(
                    createUrl1(context, index),
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      userModels[index].nameStore,
                      style: MyFont().white18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ที่อยู่ : ${userModels[index].address}',
                          style: MyFont().grey16,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                size: 40.0,
                              ),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddBooking(
                                              userModel: userModel,
                                            )));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.tag,
                                size: 40.0,
                              ),
                              color: Colors.black,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PromotionStore(
                                              userModel: userModel,
                                            )));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      userModels[index].bio,
                      overflow: TextOverflow.ellipsis,
                      style: MyFont().grey16,
                    ),
                    Text(
                      'เบอร์โทรศัพท์ : ${userModels[index].phone}',
                      style: MyFont().grey16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text(
          'ร้านทั้งหมด',
          style: MyFont().white18,
        ),
      ),
      backgroundColor: MyConstant.primary,
      body: userModels.length == 0
          ? ShowProgress()
          : ListView.builder(
              itemCount: userModels.length,
              padding: EdgeInsets.only(right: 12.0),
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print('You Click index $index');
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => DetailStore(
                              userModel: userModels[index],
                            ));
                    Navigator.push(context, route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0, bottom: 10.0),
                    child: Card(
                      color: MyConstant.primary,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      elevation: 8.0,
                      child: InkWell(
                        onTap: () {
                          print('You Click index $index');
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
                                Image.network(createUrl1(context, index)),
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Text(
                                    userModels[index].nameStore,
                                    style: MyFont().white18,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ที่อยู่ : ${userModels[index].city}',
                                        style: MyFont().grey18,
                                      ),
                                      Row(
                                        children: [Text('ให้โชว์ดาวตรงนี้')],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    userModels[index].bio,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyFont().grey18,
                                  ),
                                  Text(
                                    'เบอร์โทรศัพท์ : ${userModels[index].phone}',
                                    style: MyFont().grey18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
