import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/edit_profile_page.dart';
import 'package:myapp/services/firestore/follow_unfollow_info_detail.dart';
import 'package:myapp/widgets/our_follow_column.dart';
import 'package:myapp/widgets/our_outline_button.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:myapp/widgets/our_profile_header.dart';
import 'package:myapp/widgets/our_sizedbox.dart';

class ViewProfile extends StatefulWidget {
  final String uid;
  final UserModel userModel;
  const ViewProfile({
    Key? key,
    required this.uid,
    required this.userModel,
  }) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.userModel.user_name,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
                vertical: ScreenUtil().setSp(5),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .where("uid", isEqualTo: widget.uid)
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
                              UserModel userModel = UserModel.fromJson(
                                  snapshot.data!.docs[index]);

                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(30),
                                              ),
                                              child: Container(
                                                color: Colors.white,
                                                child: userModel.profile_pic !=
                                                        ""
                                                    ? CachedNetworkImage(
                                                        imageUrl: userModel
                                                            .profile_pic,

                                                        // Image.network(
                                                        placeholder:
                                                            (context, url) =>
                                                                Image.asset(
                                                          "assets/images/profile_holder.png",
                                                        ),
                                                        height: ScreenUtil()
                                                            .setSp(60),
                                                        width: ScreenUtil()
                                                            .setSp(60),
                                                        fit: BoxFit.contain,
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
                                                              20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            OurSizedBox(),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Text(
                                                userModel.user_name,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(15),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: Text(
                                                userModel.bio,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(12.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setSp(
                                          15,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                OurFollowersColumn(
                                                  number: userModel.post,
                                                  title: "Post",
                                                ),
                                                OurFollowersColumn(
                                                  number: userModel.following,
                                                  title: "Following",
                                                ),
                                                OurFollowersColumn(
                                                  number: userModel.follower,
                                                  title: "Followers",
                                                ),
                                              ],
                                            ),
                                            OurSizedBox(),
                                            userModel.uid ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? OurOutlineButton(
                                                    title: "Upload Profile",
                                                    function: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return EditProfilePage(
                                                                userModel:
                                                                    userModel);
                                                          },
                                                          fullscreenDialog:
                                                              true,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : userModel.followerList
                                                        .contains(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    ? OurOutlineButton(
                                                        title: "Unfollow",
                                                        function: () async {
                                                          await FollowUnfollowDetailFirebase()
                                                              .unfollow(
                                                                  userModel);
                                                        },
                                                      )
                                                    : OurOutlineButton(
                                                        title: "Follow",
                                                        function: () async {
                                                          await FollowUnfollowDetailFirebase()
                                                              .follow(
                                                                  userModel);
                                                          setState(() {});
                                                        },
                                                      ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  OurSizedBox(),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("Posts")
                                          // .where("ownerId",
                                          //     isEqualTo: userModel.uid)
                                          .orderBy("timestamp",
                                              descending: true)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
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
                                                      PostModel.fromJson(
                                                          snapshot.data!
                                                              .docs[index]);
                                                  return postModel.OwnerId ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? OurPostTile(
                                                          postModel: postModel,
                                                          // userModel: userModel,
                                                        )
                                                      : Container();
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ),
        ));
  }
}
