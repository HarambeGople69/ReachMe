import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:uuid/uuid.dart';

class NotificationDetailFirebase {
  commentUpload(String comment, PostModel postModel, String uid) async {
    try {
      UserModel userModel = UserModel.fromJson(await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());
      await FirebaseFirestore.instance
          .collection("Notification")
          .doc(postModel.OwnerId)
          .collection("Notify")
          .doc(uid)
          .set({
        "senderId": userModel.uid,
        "post_pic": postModel.post_pic,
        "postId": postModel.postId,
        "timestamp": Timestamp.now(),
        "senderProfile": userModel.profile_pic,
        "comment": comment,
        "type": "comment",
        "senderName": userModel.user_name,
        // "postModel":postModel
      });
    } catch (e) {}
  }

  likeUpload(PostModel postModel) async {
    try {
      UserModel userModel = UserModel.fromJson(await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());
      await FirebaseFirestore.instance
          .collection("Notification")
          .doc(postModel.OwnerId)
          .collection("Notify")
          .doc(postModel.postId)
          .set({
        "senderId": userModel.uid,
        "post_pic": postModel.post_pic,
        "postId": postModel.postId,
        "timestamp": Timestamp.now(),
        "senderProfile": userModel.profile_pic,
        "comment": "",
        "type": "like",
        "senderName": userModel.user_name,
        // "postModel":postModel
      });
    } catch (e) {}
  }
}
