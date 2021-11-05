import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/message_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/firebase%20storage/chat_photo_storage.dart';
import 'package:myapp/services/firestore/chat_info_detail.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

class Message extends StatefulWidget {
  final UserModel userModel;
  const Message({Key? key, required this.userModel}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController _message_controller = TextEditingController();
  ColorLizer colorlizer = ColorLizer();
  final formKey = GlobalKey<FormState>();
  File? file;
  bool progress = false;

  pickImage() async {
    Permission _permission = Permission.storage;
    PermissionStatus _status = await _permission.request();

    if (!_status.isGranted) {
      await Permission.location.request();
    }
    if (_status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
      print("=========================");
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {});
        file = File(result.files.single.path!);
        await ChatImageUpload().uploadImage(widget.userModel, file!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setSp(30),
                ),
                child: Container(
                    color: Colors.white,
                    child: widget.userModel.profile_pic != ""
                        ? CachedNetworkImage(
                            imageUrl: widget.userModel.profile_pic,

                            // Image.network(
                            placeholder: (context, url) => Image.asset(
                              "assets/images/profile_holder.png",
                            ),
                            height: ScreenUtil().setSp(40),
                            width: ScreenUtil().setSp(40),
                            fit: BoxFit.fitHeight,
                            //   )
                          )
                        : Container()),
              ),
              SizedBox(
                width: ScreenUtil().setSp(10),
              ),
              Text(
                widget.userModel.user_name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                ),
              ),
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: progress,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(10),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("ChatRoom")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("Chat")
                          .doc(widget.userModel.uid)
                          .collection("Messages")
                          .orderBy("timestamp", descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                reverse: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel messageModel =
                                      MessageModel.fromJson(
                                    snapshot.data!.docs[index],
                                  );
                                  return messageModel.type == "text"
                                      ? Row(
                                          mainAxisAlignment:
                                              messageModel.ownerId ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(15),
                                                vertical:
                                                    ScreenUtil().setSp(15),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(5),
                                                vertical: ScreenUtil().setSp(5),
                                              ),
                                              // alignment: Alignment.center,
                                              // height: ScreenUtil().setSp(30),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                  colorlizer
                                                      .getRandomColors()!
                                                      .withOpacity(0.8),
                                                  colorlizer
                                                      .getRandomColors()!
                                                      .withOpacity(0.8),
                                                ]),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(20),
                                                ),
                                              ),
                                              child: Text(
                                                messageModel.message,
                                                style: SmallText,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              messageModel.ownerId ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  ScreenUtil().setSp(30),
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(5),
                                                vertical: ScreenUtil().setSp(5),
                                              ),
                                              child: CachedNetworkImage(
                                                width: 200,
                                                height: 200,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  "assets/images/image_place_holder.png",
                                                  fit: BoxFit.cover,
                                                ),
                                                imageUrl: messageModel.message,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            )
                                          ],
                                        );
                                });
                          }
                        }
                        return Container(
                          child: Center(
                            child: Lottie.asset(
                              'assets/animations/message.json',
                              fit: BoxFit.fitWidth,
                              height: 250.h,
                              width: 350.h,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            progress = true;
                          });
                          await pickImage();
                          setState(() {
                            progress = false;
                          });
                        },
                        child: Icon(
                          Icons.image,
                          size: ScreenUtil().setSp(
                            30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(
                          15,
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: _message_controller,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              return null;
                            } else {
                              return "Message can't be empty";
                            }
                          },
                          title: "Send message",
                          type: TextInputType.name,
                          number: 1,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setSp(
                          15,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            ChatDetailFirebase().messageDetail(
                              _message_controller.text.trim(),
                              widget.userModel,
                            );
                            _message_controller.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: Icon(
                          Icons.send,
                          size: ScreenUtil().setSp(
                            30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
