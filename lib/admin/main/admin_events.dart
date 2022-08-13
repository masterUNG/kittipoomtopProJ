import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/event_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:hangout/shared/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminEvent extends StatefulWidget {
  AdminEvent({Key? key}) : super(key: key);

  @override
  State<AdminEvent> createState() => _AdminEventState();
}

class _AdminEventState extends State<AdminEvent> {
  bool load = true; // load JSON
  bool? haveData; //have data

  List<EventModel> eventModels = [];

  Widget body() {
    return Center(
      child: Text(
        'Event',
        style: MyFont().black18,
      ),
    );
  }

  Future<Null> findEvent() async {
    if (eventModels.length != 0) {
      eventModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idStore = preferences.getString('id')!;
    String apiGetInfo =
        '${MyConstant.domain}/hangout/getEventWhereIdStore.php?isAdd=true&idStore=$idStore';
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
          EventModel eventModel = EventModel.fromMap(item);
          setState(() {
            load = false;
            haveData = true;
            eventModels.add(eventModel);
          });
        }
      }
    });
  }

  Future<Null> deletePromotionDialog(EventModel eventModel) async {
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
            'คุณต้องการลบ ${eventModel.event} ใช่หรือไม่ ?',
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
                      '${MyConstant.domain}/hangout/deleteEventWhereId.php?isAdd=true&id=${eventModel.id}';
                  await Dio().get(url).then((value) => findEvent());
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

  Widget showListEvent() => ListView.builder(
        itemCount: eventModels.length,
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
                        '${MyConstant.domain}${eventModels[index].imageEvent}',
                    fit: BoxFit.cover,
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () => deletePromotionDialog(eventModels[index]),
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
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, MyConstant.rountAddPromotion)
                  .then((value) => findEvent()),
          child: Text(
            'กรุณาเพิ่มกิจกรรม',
            style: MyFont().white18,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    findEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? showListEvent()
              : _noInfo(size),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, MyConstant.rountAddEvent)
            .then((value) => findEvent()),
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
