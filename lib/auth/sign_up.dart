import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String verify;

  String? type;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: emailController,
                validator: (val) => val!.isEmpty ? 'กรุณาใส่อีเมล' : null,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Email',
                  labelStyle: MyFont().grey,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.alternate_email_outlined,
                    color: HexColor('#0f0f0f'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Container(
      child: TextFormField(
        controller: passwordController,
        validator: (val) => val!.length < 6 ? 'รหัสผ่านต้องมี6ตัวขึ้นไป' : null,
        obscureText: true,
        style: TextStyle(
          fontSize: 18,
          color: HexColor('#0f0f0f'),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Password',
          labelStyle: MyFont().grey,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.lock,
            color: HexColor('#0f0f0f'),
          ),
        ),
      ),
    );
  }

  Widget _buildUsername() {
    return Container(
      child: TextFormField(
        controller: usernNameController,
        validator: (val) => val!.isEmpty ? 'กรุณาใส่ username' : null,
        style: TextStyle(
          fontSize: 18,
          color: HexColor('#0f0f0f'),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Username',
          labelStyle: MyFont().grey,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.person,
            color: HexColor('#0f0f0f'),
          ),
        ),
      ),
    );
  }

  Widget _buildPhone() {
    return Container(
      child: TextFormField(
        controller: phoneController,
        validator: (val) => val!.isEmpty ? 'กรุณาใส่หมายเลขโทรศัพท์' : null,
        style: TextStyle(
          fontSize: 18,
          color: HexColor('#0f0f0f'),
        ),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Phone',
          labelStyle: MyFont().grey,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.phone,
            color: HexColor('#0f0f0f'),
          ),
        ),
      ),
    );
  }

  Widget _buildReGisBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            
            checkEmail();
          }
        },
        child: Text(
          'Registor',
          style: MyFont().white,
        ),
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFE43F5A),
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _userRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'User',
          groupValue: type,
          activeColor: HexColor('#0f0f0f'),
          onChanged: (value) {
            setState(() {
              type = value as String?;
              verify = '';
            });
          },
        ),
        Text('สำหรับจองโต๊ะ', style: MyFont().grey16),
      ],
    );
  }

  Widget _storeRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'Store',
          groupValue: type,
          activeColor: HexColor('#0f0f0f'),
          onChanged: (value) {
            setState(() {
              type = value as String?;
              verify = 'ยังไม่ได้ยืนยัน';
            });
          },
        ),
        Text('สำหรับร้านอาหาร', style: MyFont().grey16),
      ],
    );
  }

  Widget _buildSignIn() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: 'have an Account? ', style: MyFont().black16),
            TextSpan(text: 'Sign in', style: MyFont().black16Bold),
          ],
        ),
      ),
    );
  }

  Future<Null> checkEmail() async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernNameController.text;
    String phone = phoneController.text;
    String chooseType = type.toString();
    String path =
        '${MyConstant.domain}/hangout/getUserWhereEmail.php?isAdd=true&email=$email';
    try {
      Response response = await Dio().get(path);
      if (response.toString() == 'null') {
        registerThread(email:email,password: password,username: username,phone: phone,chooseType:chooseType);
      } else {
        MyDialog()
            .failDialog(context, 'ไม่สำเร็จ', '$email นี้มีผู้อื่นใช้ไปแล้ว');
      }
    } catch (e) {}
  }

  Future<Null> registerThread({
    String? email,
    String? password,
    String? username,
    String? phone,
    String? chooseType,
  }) async {
    String path =
        '${MyConstant.domain}/hangout/addUser.php?isAdd=true&email=$email&password=$password&username=$username&phone=$phone&chooseType=$chooseType&verify=$verify';
    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
      Navigator.pop(context);
      MyDialog().successDialog(context, 'ยินดีด้วย', 'คุณสมัครสมาชิคสำเร็จ');
      } else {
        MyDialog()
            .failDialog(context, 'ไม่สำเร็จ', 'กรุณาลองใหม่อีกครั้งค่ะ');
      }
    });
   

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyConstant.light,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      /*image: DecorationImage(image: AssetImage('') //ใส้พื้นหลัง
                        ),*/
                      ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 100.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ลงทะเบียน', style: MyFont().black40),
                        SizedBox(
                          height: 30,
                        ),
                        _buildEmail(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPassword(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildUsername(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPhone(),
                        SizedBox(
                          height: 10,
                        ),
                        _userRadio(),
                        _storeRadio(),
                        _buildReGisBtn(),
                        _buildSignIn(),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
