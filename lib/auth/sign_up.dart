import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/shared/font.dart';
import 'package:hexcolor/hexcolor.dart';

enum SingingCharacter { User, Store }

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late String email, password, username, phone, verify, chooseType;

  SingingCharacter? _character = SingingCharacter.User;


  final formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: TextFormField(
                validator: (val) => val!.isEmpty ? 'กรุณาใส่อีเมล' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                onSaved: (String? value) {
                  email.trim();
                },
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
        validator: (val) => val!.length < 6 ? 'รหัสผ่านต้องมี6ตัวขึ้นไป' : null,
        onChanged: (val) {
          setState(() => password = val);
        },
        onSaved: (String? value) {
                  password.trim();
                },
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
        validator: (val) => val!.isEmpty ? 'กรุณาใส่ username' : null,
        onChanged: (val) {
          setState(() => username = val);
        },
        onSaved: (String? value) {
                  username.trim();
                },
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
        validator: (val) => val!.isEmpty ? 'กรุณาใส่หมายเลขโทรศัพท์' : null,
        onChanged: (val) {
          setState(() => phone = val);
        },
        onSaved: (String? value) {
                  phone.trim();
                },
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
            //checkEmail();
            print('email : $email\n password : $password\n username : $username\n phone : $phone\n chooseType : $_character');
          }
        },
        child: Text('Registor',style: MyFont().white,),
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
          value: SingingCharacter.User,
          groupValue: _character,
          activeColor: HexColor('#0f0f0f'),
          onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                
              });
            },
          ),
        
        Text(
          'สำหรับจองโต๊ะ',
          style: MyFont().grey16
        ),
      ],
    );
  }

  Widget _storeRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: SingingCharacter.Store,
          groupValue: _character,
          activeColor: HexColor('#0f0f0f'),
          onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
                verify = 'ยังไม่ได้ยืนยัน';
              });
            },
          ),
        

        Text(
          'สำหรับร้านอาหาร',
          style: MyFont().grey16
        ),
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
            TextSpan(
              text: 'have an Account? ',
              style: MyFont().black16

            ),
            TextSpan(
              text: 'Sign In',
              style: MyFont().black16Bold
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
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
                      Text(
                        'Registion',
                        style: TextStyle(
                          color: HexColor('#0f0f0f'),
                          fontSize: 30,
                          fontFamily: 'Prompt',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
    );
  }
}