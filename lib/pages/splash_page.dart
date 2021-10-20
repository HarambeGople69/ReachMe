import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/pages/authentication/login_page.dart';
import 'package:myapp/pages/wrapper/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'set_user_info/new_user_info.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), completed);
  }

  Widget checkLoggedin() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrapper(
            x: GetStorage().read("state") ?? 0,
          );
        } else {
          return LoginPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.cover,
          height: ScreenUtil().setSp(250),
          width: ScreenUtil().setSp(250),
        ),
      ),
    );
  }

  void completed() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => checkLoggedin()));
  }
}
