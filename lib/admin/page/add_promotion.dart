import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddPromotion extends StatefulWidget {
  const AddPromotion({Key? key}) : super(key: key);

  @override
  _AddPromotionState createState() => _AddPromotionState();
}

class _AddPromotionState extends State<AddPromotion> {
  UserModel? userModel;

  File? image;
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  String? imagePromotion, idStore, nameStore;
  String? imageData, nameImage;

  TextEditingController promotionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<Null> findData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String apiGetInfo =
        '${MyConstant.domain}/hangout/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(apiGetInfo).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameStore = userModel!.nameStore;
          idStore = userModel!.id;
        });
      }
    });
    //print('id >> $idStore');
    //print('name >> $nameStore');
  }

  Widget _buildPromotion(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: promotionController,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มโปรโมชั่น';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'โปรโมชั่น :',
          hoverColor: Colors.black,
          prefixIcon: Icon(
            Icons.local_fire_department,
            color: Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: priceController,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มราคา';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'ราคา :',
          prefixIcon: Icon(
            Icons.money,
            color: Colors.black,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: detailController,
        maxLines: 4,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มรายละเอียด';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'รายละเอียด :',
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Icon(
              Icons.local_dining_outlined,
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(double size) {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36.0,
          ),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            width: size * 0.6,
            child: image == null
                ? Icon(
                    Icons.image,
                    size: 250.0,
                  )
                : Container(
                    height: 250, width: 250, child: Image.file(image!))),
        IconButton(
            onPressed: () => chooseImage(ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            )),
      ],
    );
  }

  Widget _confirmBth(double size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: size / 2,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            addPromotion();
          } else {}
        },
        child: Text(
          'ยืนยัน',
          style: MyFont().white,
        ),
        style: ElevatedButton.styleFrom(
            primary: MyConstant.focus,
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      XFile? _image = await _picker.pickImage(
          source: imageSource, maxHeight: 800.0, maxWidth: 800.0);

      setState(() {
        image = File(_image!.path);
        imageData = base64Encode(image!.readAsBytesSync());
        print('image ===> $_image');
      });
    } catch (e) {
      print('Failed ==> $e');
    }
  }

  Future<Null> addPromotion() async {
    MyDialog().loadingDialog(context);

    Random random = Random();
    int i = random.nextInt(1000000);
    setState(() {
      nameImage = '${idStore}_promotion$i.jpg';
    });
    String apiUpload = '${MyConstant.domain}/hangout/saveImagePromotion.php';

    try {
      var res = await http.post(Uri.parse(apiUpload), body: {
        "data": imageData,
        "nameImage": nameImage
      }).then((value) => saveAdd());
      var response = jsonDecode(res.body);

      if (response["success"] == "true") {
        print('Upload Success');
      } else {
        print('Upload failed');
      }
    } catch (e) {}
  }

  Future<Null> saveAdd() async {
    String promotion = promotionController.text;
    String price = priceController.text;
    String detail = detailController.text;

    String imagePromotion = "/hangout/promotion/$nameImage";

    String urlInsertData =
        '${MyConstant.domain}/hangout/addPromotion.php?isAdd=true&idStore=$idStore&NameStore=$nameStore&Promotion=$promotion&Price=$price&Detail=$detail&ImagePromotion=$imagePromotion';
    await Dio().get(urlInsertData).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        MyDialog()
            .successDialog(context, 'Successfully!', 'บันทึกข้อมูลสำเร็จ');
      } else {
        MyDialog().failDialog(
            context, 'Opps', 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้งค่ะ');
      }
    });
  }

  @override
  void initState() {
    findData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มโปรโมชั่น',
          style: MyFont().white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: MyConstant.primary,
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _buildPromotion(constraints),
                    _buildPrice(constraints),
                    _buildDetail(constraints),
                    _buildImage(size),
                    _confirmBth(size),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
