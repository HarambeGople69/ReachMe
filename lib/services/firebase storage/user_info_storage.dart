import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/services/compress%20image/compress_image.dart';
import 'package:myapp/services/firestore/user_info_detail.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';

class UserProfileUpload {
  uploadProfile(
      String name, String bio, File? file, BuildContext context) async {
    print("Inside uploadProfile");
    AlertWidget().showLoading(context);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String downloadUrl = "";
    try {
      if (file != null) {
        File compressedFile = await compressImage(file);
        String filename = compressedFile.path.split('/').last;
        final uploadFile = await firebaseStorage
            .ref(
                "${FirebaseAuth.instance.currentUser!.uid}/post_images/${filename}")
            .putFile(compressedFile);
        if (uploadFile.state == TaskState.success) {
          downloadUrl = await firebaseStorage
              .ref(
                  "${FirebaseAuth.instance.currentUser!.uid}/post_images/${filename}")
              .getDownloadURL();
          UserDetailFirestore().uploadDetail(name, bio, downloadUrl, context);
        }
        print("Uploaded=======================");
      } else {
        UserDetailFirestore().uploadDetail(name, bio, "", context);
        print("Uploaded=======================");
      }
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
}
