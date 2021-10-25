import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/widgets/our_follow_column.dart';
import 'package:myapp/widgets/our_outline_button.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:myapp/widgets/our_profile_header.dart';
import 'package:myapp/widgets/our_profile_tile.dart';
import 'package:myapp/widgets/our_sizedbox.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "ReachMe",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
          centerTitle: true,
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () {
                EmailPasswordAuth().logout(context);
              },
              child: Icon(
                EvaIcons.logOut,
                color: Colors.red,
                size: ScreenUtil().setSp(30),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(5),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("uid",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length > 0) {
                      return ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            UserModel userModel =
                                UserModel.fromJson(snapshot.data!.docs[index]);

                            return Column(
                              children: [
                                UserProfileHeader(userModel: userModel),
                                Divider(),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Posts")
                                        // .orderBy("timestamp", descending: true)
                                        .where("ownerId",
                                            isEqualTo: userModel.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.docs.length > 0) {
                                          return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                PostModel postModel =
                                                    PostModel.fromJson(snapshot
                                                        .data!.docs[index]);
                                                return OurPostTile(
                                                  postModel: postModel,
                                                  userModel: userModel,
                                                );
                                              });
                                        }
                                      }
                                      return Container();
                                    })
                              ],
                            );
                          });
                    } else {
                      return Center(
                        child: Text("Cannot find"),
                      );
                    }
                  }
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          ),
        ));
  }
}
