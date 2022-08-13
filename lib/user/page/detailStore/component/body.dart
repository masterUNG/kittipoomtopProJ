import 'package:hangout/mongoDB/models/favoriteModels.dart';
import 'package:hangout/mongoDB/mongodb.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/user/page/booking_page.dart';
import 'package:hangout/user/page/event_store.dart';
import 'package:hangout/user/page/promotion_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
//import 'package:mongo_dart/mongo_dart.dart' as M;

class Body extends StatefulWidget {
  final UserModel userModel;

  const Body({Key? key, required this.userModel}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

UserModel? userModel;
List<UserModel> userModels = [];
int activeIndex = 0;

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
  }

  Future<void> insertFav() async {
    final data = FavModels(
        idStore: '${widget.userModel.id}',
        listIdUser: '',
        nameStore: '${widget.userModel.nameStore}');

    var result = await MongoDatabase.insert(data);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
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
                          icon: Icon(Icons.favorite_border),
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
