import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/message_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/firestore/chat_info_detail.dart';
import 'package:myapp/widgets/our_text_field.dart';

class Message extends StatefulWidget {
  final UserModel userModel;
  const Message({Key? key, required this.userModel}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController _message_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
            Text(widget.userModel.user_name),
          ],
        ),
      ),
      body: Container(
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
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel messageModel = MessageModel.fromJson(
                                snapshot.data!.docs[index],
                              );
                              return Row(
                                mainAxisAlignment: messageModel.ownerId ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(15),
                                        vertical: ScreenUtil().setSp(15),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setSp(5),
                                        vertical: ScreenUtil().setSp(5),
                                      ),
                                      // alignment: Alignment.center,
                                      // height: ScreenUtil().setSp(30),
                                      decoration: BoxDecoration(
                                        color: messageModel.ownerId ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Colors.pink
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(
                                          ScreenUtil().setSp(20),
                                        ),
                                      ),
                                      child: Text(messageModel.message)),
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
                    onTap: () {
                      print("Image");
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
    );
  }
}
