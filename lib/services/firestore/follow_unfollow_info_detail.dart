import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user_model.dart';

class FollowUnfollowDetailFirebase {
  follow(UserModel userModel) async {
    UserModel followeruserModel = UserModel.fromJson(await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get());

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.uid)
        .update({
      "followerList": FieldValue.arrayUnion([followeruserModel.uid]),
      "follower": userModel.follower + 1,
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(followeruserModel.uid)
        .update({
      "followingList": FieldValue.arrayUnion([userModel.uid]),
      "following": followeruserModel.following + 1,
    });
    print("Geda Done=================");
  }

  unfollow(UserModel userModel) async {
    UserModel followeruserModel = UserModel.fromJson(await FirebaseFirestore
        .instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get());

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userModel.uid)
        .update({
      "followerList": FieldValue.arrayRemove([followeruserModel.uid]),
      "follower": userModel.follower - 1,
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(followeruserModel.uid)
        .update({
      "followingList": FieldValue.arrayRemove([userModel.uid]),
      "following": followeruserModel.following - 1,
    });
    print("Geda Done=================");
  }
}
