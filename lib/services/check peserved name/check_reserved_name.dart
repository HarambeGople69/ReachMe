import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

class CheckReservedName {
  Future<bool> checkThisUserAlreadyPresentOrNot(
      String name, BuildContext context) async {
    try {
      // AlertWidget().showLoading(context);

      QuerySnapshot findResult = await FirebaseFirestore.instance
          .collection("Users")
          .where("user_name", isEqualTo: name)
          .get();
      // ignore: unnecessary_null_comparison
      if (findResult.docs.isEmpty) {
        // Navigator.pop(context);
        // Navigator.pop(context);

        return true;
      } else {
        // Navigator.pop(context);
        // Navigator.pop(context);

        return false;
      }
    } on FirebaseException catch (e) {
      // Navigator.pop(context);

      return false;
    }
  }
}
