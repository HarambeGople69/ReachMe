import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/pages/authentication/signup_page.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/services/authentication_service/google_login_service.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_password_field.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool see = true;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              // ignore: prefer_const_constructors
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(20),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: ScreenUtil().setSp(200),
                    width: ScreenUtil().setSp(200),
                  ),
                  OurSizedBox(),
                  Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(25),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  OurSizedBox(),
                  CustomTextField(
                    start: emailNode,
                    end: passwordNode,
                    icon: Icons.email,
                    controller: _email_controller,
                    validator: (value) {
                      if (value.isNotEmpty && value.contains("@")) {
                        return null;
                      } else {
                        return "Please enter valid email";
                      }
                    },
                    title: "Email",
                    type: TextInputType.emailAddress,
                    number: 0,
                  ),
                  OurSizedBox(),
                  PasswordForm(
                    start: passwordNode,
                    title: "Password",
                    see: see,
                    controller: _password_controller,
                    validator: (value) {
                      if (value.trim().length < 6) {
                        return "Must be aleast 6 character long";
                      } else {
                        return null;
                      }
                    },
                    number: 1,
                    changesee: () {
                      setState(() {
                        see = !see;
                      });
                    },
                  ),
                  // OurSizedBox(),
                  SizedBox(
                    height: ScreenUtil().setSp(
                      30,
                    ),
                  ),
                  OurElevatedButton(
                    title: "Login",
                    function: () {
                      if (formKey.currentState!.validate()) {
                        EmailPasswordAuth().loginAccount(
                            _email_controller.text.trim(),
                            _password_controller.text.trim(),
                            context);
                      }
                    },
                  ),
                  OurSizedBox(),
                  Text(
                    "Or continue with",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        17,
                      ),
                    ),
                  ),
                  OurSizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          // signInWithGoogle();
                          GoogleSigninService().signIn(context);
                        },
                        child: Image.asset(
                          "assets/images/google.png",
                          height: ScreenUtil().setSp(55),
                          width: ScreenUtil().setSp(55),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Image.asset(
                        "assets/images/fbook.png",
                        height: ScreenUtil().setSp(55),
                        width: ScreenUtil().setSp(55),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  OurSizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            17.5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SignUpPage();
                          }));
                        },
                        child: Text(
                          "Sign up.",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              17.5,
                            ),
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
