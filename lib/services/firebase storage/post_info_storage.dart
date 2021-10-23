import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/screens/dashboard.dart';
import 'package:myapp/services/compress%20image/compress_image.dart';
import 'package:myapp/services/firestore/post_info_detail.dart';
import 'package:myapp/widgets/custom_animated_alertdialog.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostUpload {
  uploadPost(String description, File? file, BuildContext context,
      String location) async {
    // AlertWidget().showLoading(context);
    File compressedFile = await compressImage(file!);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    String filename = compressedFile.path.split('/').last;
    String downloadUrl = "";
    final uploadFile = await firebaseStorage
        .ref(
            "${FirebaseAuth.instance.currentUser!.uid}/post_images/${filename}")
        .putFile(compressedFile);
    if (uploadFile.state == TaskState.success) {
      downloadUrl = await firebaseStorage
          .ref(
              "${FirebaseAuth.instance.currentUser!.uid}/post_images/${filename}")
          .getDownloadURL();
      print("$downloadUrl is the download link");
      await PostDetailFirebase()
          .uploadDetail(description, location, downloadUrl, context);
      // Navigator.pop(context);

      if (Navigator.canPop(context)) {
        print("Can pop 2");
      } else {
        print("Cannot pop 2");
      }
    }
  }
}
