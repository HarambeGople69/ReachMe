import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/dashboard.dart';
import 'package:myapp/services/firestore/user_info_detail.dart';
import 'package:uuid/uuid.dart';

class PostDetailFirebase {
  uploadDetail(String desc, String location, String imageUrl,
      BuildContext context) async {
    try {
      String uid = Uuid().v4();
      UserModel userModel = UserModel.fromJson(
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
      );
      await FirebaseFirestore.instance.collection("Posts").doc(uid).set({
        "user_name": userModel.user_name,
        "profile_pic": userModel.profile_pic,
        "ownerId": userModel.uid,
        "postId": uid,
        "post_pic": imageUrl,
        "location": location,
        "caption": desc,
        "timestamp": Timestamp.now(),
        "likes": [],
        "likeNumber": 0,
        "commentNumber": 0,
      }).then((value) {
        uid = "";
        UserDetailFirestore().postAdded(userModel);
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

  deletePost(PostModel postModel) async {
    UserModel userModel = UserModel.fromJson(
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
    );

    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postModel.postId)
        .delete()
        .then((value) {
      UserDetailFirestore().postDeleteded(userModel);
    });
  }
}
