import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  final UserModel userModel;
  const EditInfo({Key? key,required this.userModel}) : super(key: key);

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {

  UserModel? userModel;

  File? image;

  List<File?> images = [];

  List<String> paths = [];

  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Widget _buildNameStore(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameController,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาใส่ชื่อร้าน';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'ชื่อร้าน :',
          hoverColor: Colors.black,
          prefixIcon: Icon(
            Icons.store,
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

  Widget _buildCity(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: cityController,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มจังหวัด';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'จังหวัด :',
          prefixIcon: Icon(
            Icons.location_pin,
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

  Widget _buildPhone(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: phoneController,
        style: MyFont().black18,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มเบอร์โทรศัพท์';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'โทรศัพท์ :',
          prefixIcon: Icon(
            Icons.phone,
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
            return 'กรุณาเพิ่มรายละเอียดร้าน';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: MyConstant.light,
          hintStyle: MyFont().grey16,
          hintText: 'รายละเอียดร้าน :',
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
    return Column(
      children: [
        Row(
          //crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => chooseImageIndex(ImageSource.camera, 0),
              icon: Icon(
                Icons.add_a_photo,
                size: 36.0,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              width: size * 0.6,
              child: images[0] == null
                  ? Icon(
                      Icons.image,
                      size: 250.0,
                    )
                  : Container(
                      margin: EdgeInsets.all(20.0),
                      height: 180,
                      width: 150,
                      child: Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            IconButton(
                onPressed: () => chooseImageIndex(ImageSource.gallery, 0),
                icon: Icon(
                  Icons.add_photo_alternate,
                  size: 36.0,
                )),
          ],
        ),
        Container(
          width: size * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                child: InkWell(
                  onTap: () => chooseImageIndex(ImageSource.gallery, 0),
                  child: images[0] == null
                      ? Icon(
                          Icons.image_outlined,
                          size: 60.0,
                        )
                      : Image.file(
                          images[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                child: InkWell(
                  onTap: () => chooseImageIndex(ImageSource.gallery, 1),
                  child: images[1] == null
                      ? Icon(
                          Icons.image_outlined,
                          size: 60.0,
                        )
                      : Image.file(
                          images[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                child: InkWell(
                  onTap: () => chooseImageIndex(ImageSource.gallery, 2),
                  child: images[2] == null
                      ? Icon(
                          Icons.image_outlined,
                          size: 60.0,
                        )
                      : Image.file(
                          images[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 60.0,
                height: 60.0,
                child: InkWell(
                  onTap: () => chooseImageIndex(ImageSource.gallery, 3),
                  child: images[3] == null
                      ? Icon(
                          Icons.image_outlined,
                          size: 60.0,
                        )
                      : Image.file(
                          images[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _confirmBth(double size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: size / 2,
      child: ElevatedButton(
        onPressed: () async {
          processAddImage();
        },
        child: Text(
          'CONFIRM',
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

  Future<Null> chooseImageIndex(ImageSource imageSource, int index) async {
    print('index =>> $index');
    try {
      XFile? _image = await _picker.pickImage(
          source: imageSource, maxHeight: 800.0, maxWidth: 800.0);

      setState(() {
        image = File(_image!.path);
        //print('image ===> $_image');
        images[index] = image;
      });
    } catch (e) {
      print('Failed ==> $e');
    }
  }

  Future<Null> processAddImage() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;

      for (var item in images) {
        if (item == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        MyDialog().loadingDialog(context);

        String apiSaveImages =
            '${MyConstant.domain}/hangout/saveImageStore.php';

        int loop = 0;
        for (var item in images) {
          int i = Random().nextInt(10000000);
          String nameImage = 'store$i.jpg';

          paths.add('${MyConstant.domain}/hangout/store/$nameImage');

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameImage);

          FormData data = FormData.fromMap(map);

          await Dio().post(apiSaveImages, data: data).then((value) async {
            print('Upload Success');
            loop++;
            if (loop >= images.length) {
              //editUserStore();
              addInfo();
              Navigator.pop(context);
            }
          });
        }
      } else {
        MyDialog().failDialog(context, 'Opps', 'กรุณาเพิ่มรูปภาพให้ครบ');
      }
    }
  }

  Future<Null> addInfo() async {
    String nameStore = nameController.text;
    String city = cityController.text;
    String bio = detailController.text;
    String phone = phoneController.text;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;

    String imageUrl = paths.toString();

    print('idStore >> $id');
    print('images >> $imageUrl');

    String url =
        '${MyConstant.domain}/hangout/editUserWhereId.php?isAdd=true&id=$id&NameStore=$nameStore&City=$city&Phone=$phone&Bio=$bio&ImageUrl=$imageUrl';

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
    userModel = widget.userModel;
    initailFile();

    nameController.text = widget.userModel.nameStore;
    cityController.text = widget.userModel.city;
    phoneController.text = widget.userModel.phone;
    detailController.text = widget.userModel.bio;

    super.initState();
  }

  void initailFile() {
    for (var i = 0; i < 4; i++) {
      images.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('แก้ไขข้อมูลร้าน',style: MyFont().white18,),
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
                    _buildImage(size),
                    _buildNameStore(constraints),
                    _buildCity(constraints),
                    _buildPhone(constraints),
                    _buildDetail(constraints),
                    _confirmBth(size),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
