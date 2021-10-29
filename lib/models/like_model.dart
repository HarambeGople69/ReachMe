import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  final String uid;
  final Timestamp timestamp;

  LikeModel({
    required this.uid,
    required this.timestamp,
  });

  factory LikeModel.fromJson(DocumentSnapshot querySnapshot) {
    return LikeModel(
      uid: querySnapshot["uid"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
