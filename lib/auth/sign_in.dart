import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hangout/models/user_model.dart';
import 'package:hangout/shared/constant.dart';
import 'package:hangout/shared/dialog.dart';
import 'package:hangout/shared/font.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email, password;

  Widget _buildEmail() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Email',
              style: MyFont().white,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,  
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(143, 148, 251, .3),
                    blurRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              height: 50,
              child: TextField(
                onChanged: (val) {
                  setState(() => email = val.trim());
                },
                keyboardType: TextInputType.emailAddress,
                style:
                    TextStyle(color: Color(0xFF162447), fontFamily: 'Prompt'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Your Email',
                  hintStyle: MyFont().grey,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(Icons.alternate_email_outlined,color: Colors.black,),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: MyFont().white,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(143, 148, 251, .3),
                blurRadius: 5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          height: 50,
          child: TextField(
            
            onChanged: (val) {
              setState(() => password = val.trim());
            },
            obscureText: true,
            style: TextStyle(
              color: Color(0xFF162447),
            ),
            decoration: InputDecoration(
              
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: MyFont().grey,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (email.isNotEmpty || password.isNotEmpty) {
            checkAuth(email, password);
          } else {
            MyDialog().failDialog(context, 'Heyy !!', 'กรุณาใส่ email และ password');
            
          }
        },
        child: Text('LOGIN',style: MyFont().white,),
        style: ElevatedButton.styleFrom(
            primary: MyConstant.focus,
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildSignUp() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MyConstant.rountSignUp);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: MyFont().white16
            ),
            TextSpan(
              text: 'Sign Up',
              style: MyFont().white16Bold
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> checkAuth (String? email, String? password) async {

    String path = '${MyConstant.domain}/hangout/getUserWhereEmail.php?isAdd=true&email=$email';
    await Dio().get(path).then((value) {

      //print('value >>> $value');
      
      if (value.toString() == 'null') {
        MyDialog().failDialog(context, 'Oops !', 'กรุณาสมัครสมาชิคค่ะ');

      } else {

        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          
          if ( model.password == password ) {
            //Success
            String type = model.chooseType;
            checkType(type);
            
          } else {
            //Fail
            MyDialog().failDialog(context, 'Opps !', 'Password ไม่ถูกต้อง กรุณาลองใหม่อีกครั้งค่ะ');
          }
        }
        
      }
    });
  }

  Future<Null> checkType (String? type) async {
    switch (type) {
      case 'User':
      Navigator.pushNamedAndRemoveUntil(context, MyConstant.rountUserMain, (route) => false);
        
      break;

      case'Store':
      Navigator.pushNamedAndRemoveUntil(context, MyConstant.rountAdminMain, (route) => false);

      break;

      default:
    }
  }
  

  @override
  Widget build(BuildContext context) {

    double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyConstant.primary,
      body: GestureDetector( //แทบตรงไหนก็ได้คีย์บอร์ดจะลง
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()), 
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      /*image:
                              DecorationImage(image: AssetImage('') //ใส้พื้นหลัง
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
                          'hangout',
                          style: MyFont().white40
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildEmail(),
                        SizedBox(
                          height: 10,
                        ),
                        _buildPassword(),
                        //* _buildForgotPasswordBtn(),
                        //* _buildRememberMe(),
                        SizedBox(
                          height: 20,
                        ),
                        _buildLoginBtn(),
                        //*_buildSignInWithText(),
                        SizedBox(
                          height: 20,
                        ),
                        //* _buildFacebookLogIn(),
                        SizedBox(
                          height: 30,
                        ),
                        _buildSignUp(),
                        SizedBox(
                          height: 30,
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
