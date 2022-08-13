import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import '../../models/user_model.dart';
import 'detailStore/detail_store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  UserModel? userModel;
  List<UserModel> userModels = [];
  List<UserModel> onSearch = [];
  int index = 0;

  TextEditingController? _textEditingController = TextEditingController();

  Future<void> readData() async {
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

  Widget buildSearch() {
    return Container(
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: MyConstant.light,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            onSearch = userModels
                .where((element) => element.nameStore
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList();
          });
        },
        controller: _textEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(15.0),
          hintText: 'ค้นหาร้านที่ต้องการ',
          hintStyle: MyFont().black16,
        ),
      ),
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

  String createUrlOnSearch(BuildContext context, int index) {
    //แยกStringในArray
    String result = onSearch[index]
        .imageUrl
        .substring(1, onSearch[index].imageUrl.length - 1);
    List<String> strings = result.split(', ');

    String urls = '${strings[0]}';

    return urls;
  }

  Widget divider() {
    return Divider(
      color: Colors.grey,
      height: 1.0,
    );
  }

  @override
  void initState() {
    readData();
    onSearch = userModels;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildSearch(),
        backgroundColor: MyConstant.primary,
      ),
      backgroundColor: MyConstant.primary,
      body:  ListView.builder(
          itemCount: _textEditingController!.text.isNotEmpty
              ? onSearch.length
              : userModels.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: InkWell(
                    onTap: () {
                      print(index);
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => DetailStore(
                                userModel: onSearch[index],
                              ));
                      Navigator.push(context, route);
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 80.0,
                          width: 80.0,
                          child: _textEditingController!.text.isNotEmpty
                              ? Image.network(
                                  createUrlOnSearch(context, index),
                                  fit: BoxFit.fitWidth,
                                )
                              : Image.network(
                                  createUrl1(context, index),
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: _textEditingController!.text.isNotEmpty
                              ? Text(
                                  onSearch[index].nameStore,
                                  style: MyFont().white18,
                                )
                              : Text(
                                  userModels[index].nameStore,
                                  style: MyFont().white18,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                divider(),
              ],
            );
          }),
    );
  }
}
