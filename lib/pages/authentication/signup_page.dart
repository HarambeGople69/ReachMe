import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_password_field.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email_controller = TextEditingController();
  TextEditingController _password_controller = TextEditingController();
  TextEditingController _confirm_password_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool see = true;
  bool csee = true;
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final confirmpasswordNode = FocusNode();
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
                  OurSizedBox(),
                  Image.asset(
                    "assets/images/logo.png",
                    height: ScreenUtil().setSp(200),
                    width: ScreenUtil().setSp(200),
                  ),
                  OurSizedBox(),
                  Center(
                    child: Text(
                      "Signup",
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
                    end: confirmpasswordNode,
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
                    number: 0,
                    changesee: () {
                      setState(() {
                        see = !see;
                      });
                    },
                  ),
                  OurSizedBox(),
                  PasswordForm(
                    start: confirmpasswordNode,
                    title: "Confirm Password",
                    see: csee,
                    controller: _confirm_password_controller,
                    validator: (value) {
                      if (_password_controller.text.trim() ==
                          _confirm_password_controller.text.trim()) {
                        return null;
                      } else {
                        return "Password didn't match";
                      }
                    },
                    number: 1,
                    changesee: () {
                      setState(() {
                        csee = !csee;
                      });
                    },
                  ),
                  SizedBox(
                    height: ScreenUtil().setSp(
                      30,
                    ),
                  ),
                  OurElevatedButton(
                    title: "Sign Up",
                    function: () async {
                      if (formKey.currentState!.validate()) {
                        await EmailPasswordAuth().createAccount(
                            _email_controller.text.trim(),
                            _password_controller.text.trim(),
                            context);
                      }
                    },
                  ),
                  OurSizedBox(),
                  SizedBox(
                    height: ScreenUtil().setSp(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            17.5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login.",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              17.5,
                            ),
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
