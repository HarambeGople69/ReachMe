import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

class LikeDetailFirebase {
  like_unlike(PostModel postModel, UserModel userModel) async {
    if (postModel.likes.contains(userModel.uid) == true) {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes": FieldValue.arrayRemove([userModel.uid]),
        "likeNumber": postModel.likeNumber - 1,
      });
      print("Contains contains");
    } else {
      await FirebaseFirestore.instance
          .collection("Posts")
          .doc(postModel.postId)
          .update({
        "likes": FieldValue.arrayUnion([userModel.uid]),
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
