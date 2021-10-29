import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/firestore/notification_indo_detail.dart';
import 'package:uuid/uuid.dart';

class CommentDetailFirebase {
  uploadDetail(String comment, PostModel postModel) async {
    try {
      String uid = Uuid().v4();
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "commentNumber": postModel.commentNumber + 1,
      });
      UserModel userModel = UserModel.fromJson(await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());

      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .collection("Comments")
          .doc(uid)
          .set({
        "ownerId": userModel.uid,
        "user_name": userModel.user_name,
        "profile_pic": userModel.profile_pic,
        "comment": comment,
        "commentId": uid,
        "timestamp": Timestamp.now(),
      });
      if (FirebaseAuth.instance.currentUser!.uid != postModel.OwnerId) {
        await NotificationDetailFirebase()
            .commentUpload(comment, postModel, uid);
      }
    } catch (e) {}
  }

  commentDelete(PostModel postModel, CommentModel commentModel,
      BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postModel.postId)
        .collection("Comments")
        .doc(commentModel.commentId)
        .delete()
        .then((value) async {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "commentNumber": postModel.commentNumber - 1,
      });
      if (commentModel.ownerId != postModel.OwnerId) {
        await FirebaseFirestore.instance
            .collection("Notification")
            .doc(postModel.OwnerId)
            .collection("Notify")
            .doc(commentModel.commentId)
            .delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Comment deleted successfully",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    });
  }
}
