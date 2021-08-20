import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hangout/auth/sign_up.dart';
import 'package:hangout/shared/font.dart';
import 'package:hexcolor/hexcolor.dart';

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
                  hintStyle: TextStyle(color: Colors.grey),
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
              hintStyle: TextStyle(color: Colors.grey),
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
          if (email.isEmpty || password.isEmpty) {
            //myAlert('แจ้งเตือน', 'กรุณาใส่ email และ password');
          } else {
            //checkAuthen();
            print(email);
          }
        },
        child: Text('LOGIN',style: MyFont().white,),
        style: ElevatedButton.styleFrom(
            primary: Color(0xFFE43F5A),
            fixedSize: Size(300, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildSignUp() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#181818'),
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
                        style: MyFont().white35
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
    );
  }
}
