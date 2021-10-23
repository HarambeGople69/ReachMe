import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/pages/screens/dashboard.dart';
import 'package:uuid/uuid.dart';

class PostDetailFirebase {
  uploadDetail(String desc, String location, String imageUrl,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("User Posts")
          .add({
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "postId": Uuid().v4(),
        "post_pic": imageUrl,
        "location": location,
        "caption": desc,
        "timestamp": Timestamp.now(),
        "likes": {}
      }).then((value) {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // backgroundColor: Colors.red,
            content: Text(
              "Post uploaded successfully",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
        print("Doneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee in post");
        if (Navigator.canPop(context)) {
          print("Can pop");
        } else {
          print("Cannot pop");
        }
      });
    } catch (e) {
      print("Error occured");
    }
  }
}
