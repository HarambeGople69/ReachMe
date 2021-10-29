import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/firestore/notification_indo_detail.dart';

class LikeDetailFirebase {
  like_unlike(PostModel postModel) async {
    if (postModel.likes.contains(FirebaseAuth.instance.currentUser!.uid) ==
        true) {
      UserModel userModel = UserModel.fromJson(await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        "likeNumber": postModel.likeNumber - 1,
      });
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .collection("Likes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      if (postModel.OwnerId != userModel.uid) {
        await FirebaseFirestore.instance
            .collection("Notification")
            .doc(postModel.OwnerId)
            .collection("Notify")
            .doc(postModel.postId)
            .delete();
      }

      print("Contains contains");
    } else {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        "likeNumber": postModel.likeNumber + 1,
      });
      FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .collection("Likes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "timestamp": Timestamp.now(),
      });
      if (postModel.OwnerId != FirebaseAuth.instance.currentUser!.uid) {
        NotificationDetailFirebase().likeUpload(postModel);
      }
      print("Doesn't contains");
    }
  }

  like_unlike_profile(PostModel postModel) {
    List x = [];
    // x.map((e) => null)
    // x.forEach((element) { })
    postModel.likes.forEach((e) {
      print(e);
    });
  }
}
