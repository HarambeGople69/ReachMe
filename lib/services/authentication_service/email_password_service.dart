import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/injection/wrapper_injection.dart';
import 'package:myapp/pages/wrapper/outer_wrapper.dart';
import 'package:myapp/services/firestore/user_info_detail.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

class EmailPasswordAuth {
  createAccount(String email, String password, BuildContext context) async {
    try {
      AlertWidget().showLoading(context);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await UserUploadInjection().registerInjection();
        await UserDetailFirestore().initializeDetail();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "User registered successfully",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message!,
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  loginAccount(String email, String password, BuildContext context) async {
    try {
      AlertWidget().showLoading(context);
      await UserUploadInjection().loginInjection();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "User logged in successfully",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message!,
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) async {
        await UserUploadInjection().logoutInjection();
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          print("can be popped 1");
        } else {
          print("cannot be popped 1");
        }
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          print("can be popped 2");
          print(FirebaseAuth.instance.currentUser!.uid);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OuterWrapper();
          }));
          print("cannot be popped 2");
        }
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("User logged out successfully"),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message!),
        ),
      );
    }
  }
}
