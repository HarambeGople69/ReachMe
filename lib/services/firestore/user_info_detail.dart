import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/injection/wrapper_injection.dart';
import 'package:myapp/pages/screens/dashboard.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

class UserDetailFirestore {
  uploadDetail(
      String name, String bio, String imageUrl, BuildContext context) async {
    try {
      final String? _getToken = await FirebaseMessaging.instance.getToken();

      final String currDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final String currTime = "${DateFormat('hh:mm a').format(DateTime.now())}";
      print("Inside uploadDetail function");
      var response = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // var x = response.docs[0];

      AlertWidget().showLoading(context);
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        // "about": bio,
        // "activity": [],
        // "connection_request": [],
        // "connections": {},
        // "creation_date": currDate,
        // "creation_time": currTime,
        // "phone_number": "",
        // "profile_pic": "",
        // "token": _getToken.toString(),
        // "total_connections": "",
        // "user_name": name,
        "uid":FirebaseAuth.instance.currentUser!.uid,
        "bio": bio,
        // "activity": [],
        // "connection_request": [],
        // "connections": {},
        // "creation_date": currDate,
        // "creation_time": currTime,
        "created_on": Timestamp.now(),
        "phone_number": "",
        "profile_pic": imageUrl,
        // "token": _getToken.toString(),
        // "total_connections": "",
        "user_name": name,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DashBoard();
        }));
        UserUploadInjection().loginInjection();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile Uploaded",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
        // Get.off(HomePage());
        // Navigator.popAndPushNamed(context, '/screen4');
        // Navigator.popAndPushNamed(context, routeName)
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

  initializeDetail() async {
    final String currDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final String? _getToken = await FirebaseMessaging.instance.getToken();
    final String currTime = "${DateFormat('hh:mm a').format(DateTime.now())}";
    print("Inside uploadDetail function");
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "bio": "",
      // "activity": [],
      // "connection_request": [],
      // "connections": {},
      // "creation_date": currDate,
      // "creation_time": currTime,
      "created_on": Timestamp.now(),
      "phone_number": "",
      "profile_pic": "",
      // "token": _getToken.toString(),
      // "total_connections": "",
      "user_name": "",
    }).then((value) {});
  }
}
