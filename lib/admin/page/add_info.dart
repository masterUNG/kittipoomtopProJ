import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/font.dart';
import 'package:image_picker/image_picker.dart';

class AddInfo extends StatefulWidget {
  const AddInfo({ Key? key }) : super(key: key);

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {

  File? image;
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  Widget _buildNameStore(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
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

  Widget _buildDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.8, //ปรับขนาด
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
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
          } else {
            //MyDialog().failDialog(context, 'Heyy !!', 'กรุณาใส่ email และ password');

          }
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

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      XFile? _image = await _picker.pickImage(
          source: imageSource, maxHeight: 800.0, maxWidth: 800.0);

      setState(() {
        image = File(_image!.path);
        print('image ===> $_image');
      });
    } catch (e) {
      print('Failed ==> $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          'ข้อมูลร้าน',
          style: MyFont().white,
        ),
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

