import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/admin/page/add_info.dart';
import 'package:hangout/admin/page/edit_info.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdminInfo extends StatefulWidget {
  const AdminInfo({Key? key}) : super(key: key);

  @override
  _AdminInfoState createState() => _AdminInfoState();
}

class _AdminInfoState extends State<AdminInfo> {
  bool _load = true;
  UserModel? userModel;
  String? nameStore;

  int activeIndex = 0;

  Future<Null> findInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetInfo).then((value) {
      //print(value);
      for (var item in json.decode(value.data)) {
        setState(() {
          _load = false;
          userModel = UserModel.fromMap(item);
          nameStore = userModel!.nameStore;
        });
      }
    });
    print('NameStore >> $nameStore');
  }

  List<String> createUrl1() {
    //แยกStringในArray
    String result =
        userModel!.imageUrl.substring(1, userModel!.imageUrl.length - 1);
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

  Widget _buildLogoutBtn(double size) {
    return Container(
      width: size / 2,
      child: ElevatedButton(
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.clear().then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.rountSignIn, (route) => false),
              );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGOUT',
              style: MyFont().white,
            ),
            //Text(data)
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: MyConstant.dark,
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _noInfo(double size) {
    return Container(
      child: Center(
        child: Text(
          'กดเพื่อเพิ่มข้อมูล',
          style: MyFont().white18,
        ),
      ),
    );
  }

  Widget _haveInfo() {
    double size = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          height: 250.0,
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
        Center(
          child: buildIndicator(),
        ),
        Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: MyConstant.light,
                    size: 30.0,
                  ),
                  Text(
                    '  ${userModel!.nameStore}',
                    style: MyFont().white32,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: MyConstant.light,
                    size: 30.0,
                  ),
                  Text(
                    '  ${userModel!.city}',
                    style: MyFont().white18,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: MyConstant.light,
                    size: 30.0,
                  ),
                  Text(
                    '  ${userModel!.phone}',
                    style: MyFont().white18,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.info,
                    color: MyConstant.light,
                    size: 30.0,
                  ),
                  Text(
                    '  ${userModel!.bio}',
                    style: MyFont().white18,
                  ),
                ],
              ),
              SizedBox(
                height: 100.0,
              ),
              _buildLogoutBtn(size),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: createUrl1().length,
        effect: ScrollingDotsEffect(
          dotHeight: 10.0,
          dotWidth: 10.0,
          activeDotColor: MyConstant.focus,
          activeDotScale: 1.5,
        ),
      );

  void routeToAddInfo() {
    Widget widget;
    if (nameStore == null) {
      widget = AddInfo();
    } else {
      widget = EditInfo(userModel: userModel!);
    }
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute)
        .then((value) => findInfo()); //อัปเดตหน้านี้ เวลามีการแก้ไข
  }

  @override
  void initState() {
    findInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _load
          ? ShowProgress()
          : nameStore == ''
              ? _noInfo(size)
              : _haveInfo(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => routeToAddInfo(), //routeToAddInfo(),
        child: Text(
          'Edit',
          style: MyFont().white,
        ),
        backgroundColor: MyConstant.focus,
      ),
      backgroundColor: MyConstant.primary,
    );
  }
}
