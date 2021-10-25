import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

class LikeDetailFirebase {
  like_unlike(PostModel postModel, UserModel userModel) async {
    // List<String> LikeList = [];
    // await FirebaseFirestore.instance.collection("Posts").get().then((value) {
    //   value.docs.forEach((element) {
    //     LikeList.add(element.id);
    //     print(element.id);
    //   });
    // });

    // LikeList.forEach((element) {

    // });
    // PostModel mypost = PostModel.fromJson(await FirebaseFirestore.instance
    //     .collection("Posts")
    //     .doc(postModel.postId)
    //     .get());
    // List a = [];

    // if (a.contains("element")) {
    //   print("Contains contains");
    // } else {
    //   print("Doesn't contains");
    // }
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
}
