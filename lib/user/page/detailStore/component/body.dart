import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hangout/models/favorite_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/my_process.dart';
import 'package:hangout/user/page/booking_page.dart';
import 'package:hangout/user/page/event_store.dart';
import 'package:hangout/user/page/promotion_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:mongo_dart/mongo_dart.dart' as M;

class Body extends StatefulWidget {
  final UserModel userModel;

  const Body({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

UserModel? userModel;
List<UserModel> userModels = [];
int activeIndex = 0;
bool? showFavority; // false ==> unFavority
String? idUserLogin;
var favorityIdBuyers = <String>[];

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    print('##14aug userModel ของร้าน at body.dart ==> ${userModel!.toMap()}');
    checkFavority();
  }

  Future<void> checkFavority() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUserLogin = preferences.getString('id');

    showFavority = false;

    String result = userModel!.favIdBuyer;
    print('##14aug result ====> $result, showFavority ก่อน ==> $showFavority');
    if (result != '0') {
      result = result.substring(1, result.length - 1);
      favorityIdBuyers = result.split(',');
      for (var i = 0; i < favorityIdBuyers.length; i++) {
        favorityIdBuyers[i] = favorityIdBuyers[i].trim();
        if (idUserLogin == favorityIdBuyers[i]) {
          showFavority = true;
        }
      }
      print('##14aug showFavority หลัง ===>> $showFavority');
      setState(() {});
    }
    setState(() {});
  }

  Future<void> findUserModelShop({required String idShop}) async {
    String path =
        'http://hangoutwithyou.com/hangout/getUserWhereId.php?isAdd=true&id=$idShop';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        userModel = UserModel.fromMap(element);
      }
    });
  }

  Future<void> insertFav() async {
    print(
        '##14aug insertFav Wrok 123 idShop ==> ${userModel!.id}, showFavority ==> $showFavority, favorityIdBuyers ==> $favorityIdBuyers');

    if (showFavority!) {
      // delete iduserlogin from Database
      print('##14aug  ก่อน favorityIdBuyers ==> $favorityIdBuyers');
      favorityIdBuyers.remove(idUserLogin);
      print('##14aug  หลัง favorityIdBuyers ==> $favorityIdBuyers');
      await MyProcess(context: context)
          .processEditFavorityIdBuyer(
              idShop: userModel!.id, favIdBuyer: favorityIdBuyers.toString())
          .then((value) async {
        await findUserModelShop(idShop: userModel!.id).then((value) {
          checkFavority();
        });
      });
    } else {
      //เช็คว่า จะ Insert หรือ Edit ที่ FavoriteTable
      String urlCheckInserOrEdit =
          'http://hangoutwithyou.com/hangout/getUserWhereIdFormFav.php?isAdd=true&idBuyer=$idUserLogin';
      await Dio().get(urlCheckInserOrEdit).then((value) async {
        if (value.toString() == 'null') {
          // ใหม่เอียม ยังไม่เคย Favorite ใคร จะใช้ Insert

          var idShops = <String>[];
          idShops.add(userModel!.id);

          String urlInsertFavorite =
              'http://hangoutwithyou.com/hangout/addFav.php?isAdd=true&idBuyer=$idUserLogin&idStore=${idShops.toString()}';
          await Dio().get(urlInsertFavorite).then((value) {
            print('##14aug insert Favorite Success');
          });
        } else {
          // มีข้อมูลอยู่แล้ว ให้ Edit แทน
          print('##14aug มีข้อมูลอยู่แล้ว ให้ Edit แทน');

          for (var element in json.decode(value.data)) {
            FavoriteModel favoriteModel = FavoriteModel.fromMap(element);
            String string = favoriteModel.idStore;
            string = string.substring(1, string.length - 1);
            var strings = string.split(',');
            for (var i = 0; i < strings.length; i++) {
              strings[i] = strings[i].trim();
            }
            strings.add(userModel!.id);

            String urlEditFavorite =
                'http://hangoutwithyou.com/hangout/editFavWhereId.php?isAdd=true&idBuyer=$idUserLogin&idStore=${strings.toString()}';
            await Dio().get(urlEditFavorite).then((value) {
              print('##14aug insert Favorite Success');
            });
          }
        }
      });

      if (favorityIdBuyers.isEmpty) {
        // form 0

        favorityIdBuyers.add(idUserLogin!);
        await MyProcess(context: context)
            .processEditFavorityIdBuyer(
                idShop: userModel!.id, favIdBuyer: favorityIdBuyers.toString())
            .then((value) async {
          await findUserModelShop(idShop: userModel!.id).then((value) {
            checkFavority();
          });
        });
      } else {
        // มีค่าของคนอื่นอยู่แล้ว
        print('##14aug favorityIdBuyer ปัจุบัน ==> $favorityIdBuyers');
        favorityIdBuyers.add(idUserLogin!);
        await MyProcess(context: context)
            .processEditFavorityIdBuyer(
                idShop: userModel!.id, favIdBuyer: favorityIdBuyers.toString())
            .then((value) async {
          await findUserModelShop(idShop: userModel!.id).then((value) {
            checkFavority();
          });
        });
      }
    }
  }

  List<String> createUrl1() {
    //แยกStringในArray
    String result = widget.userModel.imageUrl
        .substring(1, widget.userModel.imageUrl.length - 1);
    List<String> strings = result.split(', ');

    final urls = [
      '${strings[0]}',
      '${strings[1]}',
      '${strings[2]}',
      '${strings[3]}',
    ];

    return urls;
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: CachedNetworkImage(
        imageUrl: createUrl1()[index],
        fit: BoxFit.cover,
        placeholder: (context, url) => ShowProgress(),
        errorWidget: (context, url, error) =>
            Image.asset('assets/image/icon.png'),
      ),
    );
  }

  Container backDrop(Size size) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: size.height * 0.4 - 50,
            child: CarouselSlider.builder(
              itemCount: createUrl1().length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = userModel!.imageUrl[index];
                return buildImage(urlImage, index);
              },
              options: CarouselOptions(
                height: 400,
                initialPage: 0,
                autoPlay: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: Duration(seconds: 2),
                onPageChanged: (index, reason) =>
                    setState(() => activeIndex = index),
              ),
            ),
          ),
          SafeArea(
            child: BackButton(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget statusDepart() {
    return widget.userModel.status == 'true'
        ? Row(
            children: [
              Icon(
                Icons.audiotrack_sharp,
                size: 30.0,
                color: Colors.lightGreen,
              ),
              Text(
                'Available',
                style: MyFont().white18,
              ),
            ],
          )
        : Row(
            children: [
              Icon(
                Icons.audiotrack_sharp,
                size: 30.0,
                color: Colors.red,
              ),
              Text(
                'Unavailable',
                style: MyFont().white18,
              ),
            ],
          );
  }

  Widget btnBooking() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBooking(
              userModel: widget.userModel,
            ),
          ),
        );
      },
      icon: Icon(
        Icons.add_shopping_cart,
        size: 25.0,
        color: Colors.black,
      ),
      label: Text(
        'จองร้านอาหาร',
        style: MyFont().black18,
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //textStyle: TextStyle(
        //fontSize: 30,
        //fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget btnEvent() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventStore(
              userModel: widget.userModel,
            ),
          ),
        );
      },
      icon: Icon(
        Icons.local_fire_department,
        size: 25.0,
        color: Colors.white,
      ),
      label: Text(
        'กิจกรรมของร้าน',
        style: MyFont().white18,
      ),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.focus,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //textStyle: TextStyle(
        //fontSize: 30,
        //fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget detailsStore(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.userModel.nameStore,
                      style: MyFont().white32,
                    ),
                    Row(
                      //*Favorite
                      children: [
                        IconButton(
                          icon: Icon(showFavority ?? false
                              ? Icons.favorite
                              : Icons.favorite_border),
                          iconSize: 40.0,
                          color: MyConstant.light,
                          onPressed: () async {
                            insertFav();
                          },
                        ),

                        //*Text(widget.userModel.favorite,style: MyStyle().white16,),
                      ],
                    ),
                  ],
                ),
                //*_ratingBar(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.map,
                          color: Colors.white,
                        ),
                        Text(
                          '  ${widget.userModel.city}',
                          style: MyFont().white18,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromotionStore(
                                      userModel: widget.userModel,
                                    )));
                      },
                      child: Container(
                        height: 40.0,
                        width: 130.0,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.nightlife),
                              color: Colors.white,
                              iconSize: 28.0,
                              onPressed: () {},
                            ),
                            Text(
                              'โปรโมชั่น',
                              style: MyFont().white18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        Text(
                          '  ${widget.userModel.phone}',
                          style: MyFont().white18,
                        ),
                      ],
                    ),
                    btnEvent(),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        Text(
                          '  ข้อมูลร้าน',
                          style: MyFont().white18,
                        ),
                      ],
                    ),
                    statusDepart(),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  widget.userModel.bio,
                  style: MyFont().white18,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: btnBooking(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        backDrop(size),
        SizedBox(
          height: 10.0,
        ),
        detailsStore(context),
      ],
    );
  }
}
