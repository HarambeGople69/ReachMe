import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/services/firestore/user_info_detail.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

// Future<UserCredential> signInWithGoogle() async {
// Trigger the authentication flow
// final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

class GoogleSigninService {
  signIn(BuildContext context) async {
    try {
      AlertWidget().showLoading(context);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final DocumentSnapshot<Map<String, dynamic>> findResult =
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.uid)
              .get();
      if (!findResult.exists) {
        UserDetailFirestore().initializeDetail();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "User logged in successfully",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message!,
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  Future<bool> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().disconnect();
      await GoogleSignIn().signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "User logged in successfully",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      print("Error in google log out");
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message!,
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
    return false;
  }
}
