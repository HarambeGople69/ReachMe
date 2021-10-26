import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

class LikeDetailFirebase {
  like_unlike(PostModel postModel) async {
    if (postModel.likes.contains(FirebaseAuth.instance.currentUser!.uid) == true) {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        "likeNumber": postModel.likeNumber - 1,
      });
      print("Contains contains");
    } else {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        "likeNumber": postModel.likeNumber + 1,
      });
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
