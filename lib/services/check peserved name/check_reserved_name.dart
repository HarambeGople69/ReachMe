import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

class CheckReservedName {
  Future<bool> checkThisUserAlreadyPresentOrNot(
      String name, BuildContext context) async {
    try {
      AlertWidget().showLoading(context);
      // final QuerySnapshot<Map<String, dynamic>> findResult =
      //     await FirebaseFirestore.instance
      //         .collection("Users")
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .collection("User Detail")
      //         .where("user_name", isEqualTo: name)
      //         .get();
      var findResult =
          await FirebaseFirestore.instance.collection("Users").get();
      for (var i = 0; i < findResult.docs.length; i++) {
        var each_user = findResult.docs[i];
        if (findResult.docs[i].data()["user_name" == name]) {
          return false;
        }
      }
      Navigator.pop(context);
      print("hello worlds");
      return true;
    } on FirebaseException catch (e) {
      // Navigator.pop(context);
      print("Error User already present");
      print(e.message);
      return false;
    }
  }
}
