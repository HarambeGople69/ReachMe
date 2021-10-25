import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String user_name;
  final String profile_pic;
  final String phone_number;
  final Timestamp created_on;
  final int post;
  final String bio;
  final String uid;

  UserModel({
    required this.post,
    required this.user_name,
    required this.profile_pic,
    required this.phone_number,
    required this.created_on,
    required this.bio,
    required this.uid,
  });

  factory UserModel.fromJson(DocumentSnapshot querySnapshot) {
    return UserModel(
      post: querySnapshot["post"],
      uid: querySnapshot["uid"],
      user_name: querySnapshot["user_name"],
      profile_pic: querySnapshot["profile_pic"],
      phone_number: querySnapshot["phone_number"],
      created_on: querySnapshot["created_on"],
      bio: querySnapshot["bio"],
    );
  }
}
