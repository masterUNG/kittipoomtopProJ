import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:hangout/user/page/list_all_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/user/page/detailStore/detail_store.dart';
import 'package:hangout/user/page/show_all_store.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  UserModel? userModel;
  List<UserModel> userModels = [];
  List<UserModel> userModelAll = [];
  String? imageStore;

  final _pageController =
      PageController(initialPage: 0, viewportFraction: 0.877);
  int _currentPage = 0;
  int index = 0;
  String? nameUser;
  Widget? currentWidget;
  List<Widget> storeCards = [];

  Future<Null> readStore() async {
    //ดึงช้อมูลที่เป็นร้านอย่างเดียว
    String url =
        '${MyConstant.domain}/hangout/getUserWhereChooseType.php?isAdd=true&chooseType=Store';
    await Dio().get(url).then((value) {
      for (var item in json.decode(value.data)) {
        userModel = UserModel.fromMap(item);
        String nameStore = userModel!.nameStore;
        String verify = userModel!.verify;
        String recommend = userModel!.recommend;
        if (nameStore.isNotEmpty &&
            verify == 'ยืนยัน' &&
            recommend == 'Recommend') {
          setState(() {
            index++;
            userModels.add(userModel!);
           

            //index++;
          });
        }
      }
    });
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey,
      height: 1.0,
    );
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
  void initState() {
    super.initState();

    readStore();

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < userModels.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MyConstant.focus,
      onRefresh: () async {
        setState(() {
          readStore();
          if (userModels.length != 0) {
            userModels.clear();
          }
        });
      },
      child: Container(
        color: MyConstant.primary,
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            _divider(),
            //* Text Widget for Title
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'ร้านแนะนำ',
                style: MyFont().white30,
              ),
            ),

            //* Custom Tab bar
            Container(
              height: 30,
              margin: EdgeInsets.only(top: 20.0),
              child: DefaultTabController(
                length: 1,
                child: TabBar(
                  labelPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                  indicatorPadding: EdgeInsets.only(left: 14.4, right: 14.4),
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.amber,
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Prompt'),
                  indicatorColor: Colors.white,
                  indicatorWeight: 2.4,
                  tabs: [
                    Tab(
                      child: Container(
                        child: Text(
                          'Recommended',
                          style: MyFont().white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //* ListView widget with PageView
            Container(
              height: 218.4,
              margin: EdgeInsets.only(top: 16),
              child: PageView(
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: _onPageChanged,
                children: List.generate(
                    userModels.length,
                    (int index) => InkWell(
                          onTap: () {
                            print('You Click index $index');
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => DetailStore(
                                      userModel: userModels[index],
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 28.8),
                            width: 333.6,
                            height: 218.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9.6),
                              image: DecorationImage(
                                //Bug
                                fit: BoxFit.cover,
                                image: NetworkImage(createUrl1(context, index)),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 19.2,
                                  left: 19.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.8),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 19.2, sigmaY: 19.2),
                                      child: Container(
                                        height: 36.0,
                                        padding: EdgeInsets.only(
                                            left: 16.72, right: 14.4),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.home,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 9.52,
                                            ),
                                            Text(userModels[index].nameStore,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.8,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Prompt')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              ),
            ),

            //* Using SmoothPageIndicator
            Padding(
              padding: EdgeInsets.only(left: 28.8, top: 28.8),
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: userModels.length,
                effect: ScrollingDotsEffect(
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  activeDotColor: MyConstant.focus,
                  activeDotScale: 1.5,
                ),
              ),
            ),

            SizedBox(
              height: 30.0,
            ),
            _divider(),

            //* Text Widget for StoreAll
            Container(
              margin: EdgeInsets.only(top: 20.0),
              height: 45.6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ร้านทั้งหมด',
                    style: MyFont().white25,
                  ),
                  TextButton(
                    child: Text(
                      'Show all',
                      style: MyFont().white16,
                    ),
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => ListAllStore());
                      Navigator.push(context, route);
                    },
                  )
                ],
              ),
            ),

            //*ListView for StoreAll
            ShowAllStore(),
          ],
        ),
      ),
    );
  }
}
