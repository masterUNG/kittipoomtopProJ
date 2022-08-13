import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/models/event_model.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';

class EventStore extends StatefulWidget {
  final UserModel userModel;
  const EventStore({Key? key, required this.userModel, EventModel? eventModel})
      : super(key: key);

  @override
  State<EventStore> createState() => _EventStoreState();
}

class _EventStoreState extends State<EventStore> {
  bool loadStatus = true;
  bool haveData = false;
  List<UserModel> userModels = [];
  List<EventModel> eventModels = [];
  String? idStore;

  UserModel? userModel;
  EventModel? eventModel;

  Future<Null> findEvent() async {
    idStore = widget.userModel.id;

    if (eventModels.length != 0) {
      loadStatus = true;
      haveData = true;
      eventModels.clear();
    }

    String url =
        '${MyConstant.domain}/hangout/getEventWhereIdStore.php?isAdd=true&idStore=$idStore';
    await Dio().get(url).then((value) {
      if (value.toString() == 'null') {
        setState(() {
          haveData = false;
          loadStatus = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          setState(() {
            eventModel = EventModel.fromMap(item);
            eventModels.add(eventModel!);
            haveData = true;
            loadStatus = false;
          });
        }
      }
    });
  }

  Widget showListEvent() => ListView.builder(
        itemCount: eventModels.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  height: 100.0,
                  width: 100.0,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${MyConstant.domain}${eventModels[index].imageEvent}',
                    fit: BoxFit.fill,
                    placeholder: (context, url) => ShowProgress(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/icon.png'),
                  ),
                ),
                title: Text(
                  '${eventModels[index].event}'
                  '\n${eventModels[index].date}'
                  '\n${eventModels[index].price} ฿',
                  style: MyFont().white18,
                ),
                subtitle: Text(
                  'รายละเอียด ${eventModels[index].detail}',
                  style: MyFont().white16,
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
          'ยังไม่มีกิจกรรมในขณะนี้',
          style: MyFont().white18,
        ),
      ),
    );
  }

  @override
  void initState() {
    findEvent();
    userModel = widget.userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyConstant.primary,
      appBar: AppBar(
        title: Text(
          'กิจกรรม',
          style: MyFont().white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      body: loadStatus
          ? ShowProgress()
          : haveData == true
              ? showListEvent()
              : _noInfo(size),
    );
  }
}
