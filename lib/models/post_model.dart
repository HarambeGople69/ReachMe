import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String caption;
  final String location;
  final String OwnerId;
  final String postId;
  final String post_pic;
  final Timestamp timestamp;

  PostModel({
    required this.caption,
    required this.location,
    required this.OwnerId,
    required this.postId,
    required this.post_pic,
    required this.timestamp,
  });

  factory PostModel.fromJson(DocumentSnapshot querySnapshot) {
    return PostModel(
      caption: querySnapshot["caption"],
      location: querySnapshot["location"],
      OwnerId: querySnapshot["ownerId"],
      postId: querySnapshot["postId"],
      post_pic: querySnapshot["post_pic"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
