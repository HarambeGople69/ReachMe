import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String comment;
  final String commentId;
  final String ownerId;
  final String profile_pic;
  final String user_name;
  final Timestamp timestamp;

  CommentModel({
    required this.comment,
    required this.commentId,
    required this.ownerId,
    required this.profile_pic,
    required this.user_name,
    required this.timestamp,
  });

  factory CommentModel.fromJson(DocumentSnapshot querySnapshot) {
    return CommentModel(
      comment: querySnapshot["comment"],
      commentId: querySnapshot["commentId"],
      ownerId: querySnapshot["ownerId"],
      profile_pic: querySnapshot["profile_pic"],
      user_name: querySnapshot["user_name"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
