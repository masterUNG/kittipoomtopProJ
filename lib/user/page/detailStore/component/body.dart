import 'package:hangout/user/page/booking_page.dart';
import 'package:hangout/user/page/promotion_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';

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
                        /*  IconButton(
                          icon: widget.userModel.favorite == 'false'
                              ? Icon(Icons.favorite_border)
                              : Icon(Icons.favorite),
                          color: widget.userModel.favorite == 'false'
                              ? Colors.white
                              : Colors.red,
                          iconSize: 28.0,
                          onPressed: () async {
                            //print(favoriteBloc.count);
                            if (widget.userModel.favorite == 'false') {
                              UserModel userModel = new UserModel(
                                nameStore: widget.userModel.nameStore,
                                phone: widget.userModel.phone,
                                address: widget.userModel.city,
                                bio: widget.userModel.bio,
                                imageUrl: widget.userModel.imageUrl,
                              );
                              setState(() {
                                favoriteBloc.addCount();
                                favoriteBloc.addItems(userModel);
                                widget.userModel.favorite = 'true';
                              });
                            } else {
                              setState(() {
                                favoriteBloc.removeCount();
                                favoriteBloc.removeItems();
                                widget.userModel.favorite = 'false';
                              });
                            }
                          },
                        ), */
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
                              icon: Icon(Icons.tag),
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
                SizedBox(
                  height: 25.0,
                ),
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBooking(
                          userModel: widget.userModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 55.0,
                    width: 180.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shopping_cart),
                          color: Colors.black,
                          iconSize: 40.0,
                          onPressed: () {},
                        ),
                        Text(
                          'จองร้านอาหาร',
                          style: MyFont().black18,
                        ),
                      ],
                    ),
                  ),
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
