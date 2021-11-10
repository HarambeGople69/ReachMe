import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/messanger_home_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/message.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_sizedbox.dart';

class MessangerHome extends StatefulWidget {
  const MessangerHome({Key? key}) : super(key: key);

  @override
  _MessangerHomeState createState() => _MessangerHomeState();
}

class _MessangerHomeState extends State<MessangerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Inbox", style: AppBarText),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setSp(10),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ChatRoom")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("Chat")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      MessangeHomeModel messangeHomeModel =
                          MessangeHomeModel.fromJson(
                              snapshot.data!.docs[index]);
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where("uid", isEqualTo: messangeHomeModel.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.length > 0) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      UserModel userModel = UserModel.fromJson(
                                          snapshot.data!.docs[index]);
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Message(
                                                userModel: userModel);
                                          }));
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    ScreenUtil().setSp(30),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: userModel
                                                                .profile_pic !=
                                                            ""
                                                        ? CachedNetworkImage(
                                                            imageUrl: userModel
                                                                .profile_pic,

                                                            // Image.network(
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              "assets/images/profile_holder.png",
                                                            ),
                                                            height: ScreenUtil()
                                                                .setSp(50),
                                                            width: ScreenUtil()
                                                                .setSp(50),
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            //   )
                                                          )
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: ScreenUtil()
                                                                .setSp(25),
                                                            child: Text(
                                                              userModel
                                                                  .user_name[0],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                  25,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: ScreenUtil().setSp(
                                                    25,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(userModel.user_name,
                                                        style:
                                                            MediumText.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700)),
                                                    SizedBox(
                                                      height:
                                                          ScreenUtil().setSp(5),
                                                    ),
                                                    SizedBox(
                                                      width: ScreenUtil()
                                                          .setSp(150),
                                                      child: Container(
                                                        padding:
                                                            new EdgeInsets.only(
                                                                right: 13.0),
                                                        child: Text(
                                                          userModel.bio,
                                                          style: SmallText,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Divider(),
                                            OurSizedBox(),
                                          ],
                                        ),
                                      );
                                    });
                              }
                            }
                            return Container();
                          });
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
    );
  }
}
