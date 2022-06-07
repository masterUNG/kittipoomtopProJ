import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  UserModel? userModel;

  String? imageTable, nameStore, address, phone, imageUrl, bio;

  final ImagePicker _picker = ImagePicker();

  var dio = Dio();

  File? _image;

  String? imageData;

  String layout = '';

  Future<void> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idStore = preferences.getString('id');

    String apiGetData =
        '${MyConstant.domain}/hangout/getUserWhereId.php?isAdd=true&id=$idStore}';

    await Dio().get(apiGetData).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameStore = userModel!.nameStore;
          address = userModel!.address;
          phone = userModel!.phone;
          imageUrl = userModel!.imageUrl;
          imageTable = userModel!.imageTable;
          bio = userModel!.bio;
        });
      }
    });
    //print('id >> $idStore');
    //print('name >> $nameStore');
  }

  Future<void> chooseImage(ImageSource imageSource) async {

    try {
      XFile? file = await _picker.pickImage(
          source: imageSource, maxHeight: 800.0, maxWidth: 800.0);
      setState(() {
        _image = File(file!.path);
        imageData = base64Encode(_image!.readAsBytesSync());

        print('image ===> $file');
      });
    } catch (e) {
      print('Failed ==> $e');
    }
  }

  Future<void> uploadImage() async {
    MyDialog().loadingDialog(context);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String apiUpload = '${MyConstant.domain}/hangout/saveImageTable.php';

    int i = Random().nextInt(100000);
    String nameLayout = 'layout$i.jpg';
    String pathUrl = "/hangout/layout/$nameLayout";
    
    try {
      var res = await http.post(Uri.parse(apiUpload),
          body: {"data": imageData, "nameImage": nameLayout});
      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        print('Upload Success');
      } else {
        print('Upload failed');
      }
    } catch (e) {
      print(e);
    }

    String url =
        '${MyConstant.domain}/hangout/editUserWhereId.php?isAdd=true&id=$id&NameStore=$nameStore&Address=$address&Bio=$bio&Phone=$phone&ImageUrl=$imageUrl&ImageTable=$pathUrl';
    Response response = await Dio().get(url);
    if (response.toString() == 'true') {
      Navigator.pop(context);
      MyDialog().successDialog(context, 'Success', 'อัพรูปสำเร็จ');
    } else {
      MyDialog().failDialog(context, 'Opps', 'กรุณาลองใหม่อีกครั้งค่ะ');
    }
  }

  Row addPhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          iconSize: 36.0,
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: _image == null
              ? Icon(
                  Icons.image_outlined,
                  size: 250.0,
                )
              : Image.file(
                  _image!,
                  fit: BoxFit.cover,
                ),
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate),
          iconSize: 36.0,
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 80, left: 80),
      child: MaterialButton(
        onPressed: () {
          if (_image == null) {
            MyDialog().failDialog(context, 'Oops', 'กรุณาเพิ่มรูปภาพ');
          } else {
            uploadImage();
          }
        },
        color: Color(0xFFE43F5A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'ยืนยัน',
          style: MyFont().white,
        ),
      ),
    );
  }

  Future<Null> addInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String imageUrl = layout;

    //print('idStore >> $id');
    //print('images >> $imageUrl');
    String url =
        '${MyConstant.domain}/hangout/editUserWhereIdAddImage.php?isAdd=true&id=$id&ImageTable=$imageUrl';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        MyDialog().successDialog(context, 'สำเร็จ', 'บันทึกข้อมูลสำเร็จ');
      } else {
        MyDialog()
            .failDialog(context, 'เกิดข้อผิดพลาด', 'กรุณาลองใหม่อีกครั้งค่ะ');
      }
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มผังร้าน',
          style: MyFont().white18,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            addPhoto(),
            saveButton(),
          ],
        ),
      ),
    );
  }
}
