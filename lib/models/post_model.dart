import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String caption;
  final String location;
  final String OwnerId;
  final String postId;
  final String post_pic;
  final dynamic likes;
  final Timestamp timestamp;
  final String user_name;
  final String profile_pic;
  final int commentNumber;
  final int likeNumber;

  PostModel({
    required this.likeNumber,
    required this.commentNumber,
    required this.caption,
    required this.location,
    required this.OwnerId,
    required this.postId,
    required this.post_pic,
    required this.timestamp,
    required this.likes,
    required this.user_name,
    required this.profile_pic,
  });

  factory PostModel.fromJson(DocumentSnapshot querySnapshot) {
    return PostModel(
      commentNumber: querySnapshot["commentNumber"],
      caption: querySnapshot["caption"],
      location: querySnapshot["location"],
      OwnerId: querySnapshot["ownerId"],
      postId: querySnapshot["postId"],
      post_pic: querySnapshot["post_pic"],
      timestamp: querySnapshot["timestamp"],
      likes: querySnapshot["likes"],
      profile_pic: querySnapshot["profile_pic"],
      user_name: querySnapshot["user_name"],
      likeNumber: querySnapshot["likeNumber"],
    );
  }
}
