import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/post_model.dart';

class NotificationModel {
  final String senderId;
  final String post_pic;
  final String postId;
  final Timestamp timestamp;
  final String senderProfile;
  final String comment;
  final String type;
  final String senderName;
  // final PostModel postModel;

  NotificationModel({
    required this.senderId,
    required this.post_pic,
    required this.postId,
    required this.timestamp,
    required this.senderProfile,
    required this.comment,
    required this.type,
    required this.senderName,
    // required this.postModel,
  });

  factory NotificationModel.fromJson(DocumentSnapshot querySnapshot) {
    return NotificationModel(
      senderId: querySnapshot["senderId"],
      post_pic: querySnapshot["post_pic"],
      postId: querySnapshot["postId"],
      timestamp: querySnapshot["timestamp"],
      senderProfile: querySnapshot["senderProfile"],
      comment: querySnapshot["comment"],
      type: querySnapshot["type"],
      senderName: querySnapshot["senderName"],
      // postModel: querySnapshot["postModel"],
    );
  }
}
