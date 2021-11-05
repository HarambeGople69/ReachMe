import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/user_model.dart';

class ChatDetailFirebase {
  messageDetail(String message, UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": message,
        "type": "text",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });

      print("Doneee sending message");
    } catch (e) {}
  }

  imageDetail(String downloadUrl,UserModel userModel)async{
    try {

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .set({"timestamp": Timestamp.now(), "uid": userModel.uid});

      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Chat")
          .doc(userModel.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "timestamp": Timestamp.now(),
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(userModel.uid)
          .collection("Chat")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Messages")
          .add({
        "message": downloadUrl,
        "type": "image",
        "ownerId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": userModel.uid,
        "imageUrl": "",
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
    }
  }

}
