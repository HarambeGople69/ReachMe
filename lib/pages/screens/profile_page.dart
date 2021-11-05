import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/services/firestore/follow_unfollow_info_detail.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_follow_column.dart';
import 'package:myapp/widgets/our_outline_button.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'edit_profile_page.dart';

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
        title: Text("ReachMe", style: AppBarText),
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
            horizontal: ScreenUtil().setSp(15),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(30),
                                          ),
                                          child: Container(
                                            color: Colors.white,
                                            child: userModel.profile_pic != ""
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        userModel.profile_pic,

                                                    // Image.network(
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "assets/images/profile_holder.png",
                                                    ),
                                                    height:
                                                        ScreenUtil().setSp(60),
                                                    width:
                                                        ScreenUtil().setSp(60),
                                                    fit: BoxFit.contain,
                                                    //   )
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius:
                                                        ScreenUtil().setSp(25),
                                                    child: Text(
                                                      userModel.user_name[0],
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenUtil().setSp(
                                                          25,
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
                                          child: Text(userModel.user_name,
                                              overflow: TextOverflow.ellipsis,
                                              style: MediumText.copyWith(
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(userModel.bio,
                                              overflow: TextOverflow.ellipsis,
                                              style: SmallText.copyWith(
                                                fontWeight: FontWeight.w700,
                                              )),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            OurFollowersColumn(
                                              function: () {},
                                              number: userModel.post,
                                              title: "Post",
                                            ),
                                            OurFollowersColumn(
                                              function: () {
                                                followingListSheet(context);
                                              },
                                              number: userModel.following,
                                              title: "Following",
                                            ),
                                            OurFollowersColumn(
                                              function: () {
                                                followersListSheet(context);
                                              },
                                              number: userModel.follower,
                                              title: "Followers",
                                            ),
                                          ],
                                        ),
                                        OurSizedBox(),
                                        userModel.uid ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
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
                                                      fullscreenDialog: true,
                                                    ),
                                                  );
                                                },
                                              )
                                            : userModel.followerList.contains(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                ? OurOutlineButton(
                                                    title: "Unfollow",
                                                    function: () async {},
                                                  )
                                                : OurOutlineButton(
                                                    title: "Follow",
                                                    function: () async {
                                                      await FollowUnfollowDetailFirebase()
                                                          .follow(userModel);
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
                              userModel.post != 0
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("Posts")
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
                                          return Center(
                                            child: Container(
                                              child: Lottie.asset(
                                                  'assets/animations/post.json',
                                                  fit: BoxFit.cover,
                                                  height: 250.h,
                                                  width: 350.h),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                    )
                                  : Container(
                                      child: Lottie.asset(
                                          'assets/animations/post.json',
                                          fit: BoxFit.cover,
                                          height: 250.h,
                                          width: 350.h),
                                    ),
                            ],
                          );
                        });
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  void followingListSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OurSizedBox(),
                Text(
                  "Following",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
                Divider(),
                OurSizedBox(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // LikeModel likeModel = LikeModel.fromJson(
                                //     snapshot.data!.docs[index]);
                                UserModel userModel = UserModel.fromJson(
                                    snapshot.data!.docs[index]);
                                return Column(
                                    children: userModel.followingList
                                        .map((e) => StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("Users")
                                                .where("uid", isEqualTo: e)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                UserModel userModel =
                                                    UserModel.fromJson(
                                                        snapshot.data!.docs[0]);

                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            ScreenUtil()
                                                                .setSp(30),
                                                          ),
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: userModel
                                                                        .profile_pic !=
                                                                    ""
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        userModel
                                                                            .profile_pic,

                                                                    // Image.network(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Image.asset(
                                                                      "assets/images/profile_holder.png",
                                                                    ),
                                                                    height: ScreenUtil()
                                                                        .setSp(
                                                                            50),
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                            50),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    //   )
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    radius: ScreenUtil()
                                                                        .setSp(
                                                                            25),
                                                                    child: Text(
                                                                      userModel
                                                                          .user_name[0],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                          25,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(20),
                                                        ),
                                                        Container(
                                                          width: ScreenUtil()
                                                              .setSp(250),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  userModel
                                                                      .user_name,
                                                                  style: MediumText
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  )),
                                                              OurSizedBox(),
                                                              Text(
                                                                  userModel.bio,
                                                                  style:
                                                                      SmallText),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    OurSizedBox(),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            }))
                                        .toList());
                              });
                        }
                        return Container();
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  void followersListSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(20),
              vertical: ScreenUtil().setSp(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OurSizedBox(),
                Text(
                  "Followers",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
                Divider(),
                OurSizedBox(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // LikeModel likeModel = LikeModel.fromJson(
                                //     snapshot.data!.docs[index]);
                                UserModel userModel = UserModel.fromJson(
                                    snapshot.data!.docs[index]);
                                return Column(
                                    children: userModel.followerList
                                        .map((e) => StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("Users")
                                                .where("uid", isEqualTo: e)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                UserModel userModel =
                                                    UserModel.fromJson(
                                                        snapshot.data!.docs[0]);

                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            ScreenUtil()
                                                                .setSp(30),
                                                          ),
                                                          child: Container(
                                                            color: Colors.white,
                                                            child: userModel
                                                                        .profile_pic !=
                                                                    ""
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        userModel
                                                                            .profile_pic,

                                                                    // Image.network(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Image.asset(
                                                                      "assets/images/profile_holder.png",
                                                                    ),
                                                                    height: ScreenUtil()
                                                                        .setSp(
                                                                            50),
                                                                    width: ScreenUtil()
                                                                        .setSp(
                                                                            50),
                                                                    fit: BoxFit
                                                                        .fitHeight,
                                                                    //   )
                                                                  )
                                                                : CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    radius: ScreenUtil()
                                                                        .setSp(
                                                                            25),
                                                                    child: Text(
                                                                      userModel
                                                                          .user_name[0],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(
                                                                          25,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setSp(20),
                                                        ),
                                                        Container(
                                                          width: ScreenUtil()
                                                              .setSp(250),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  userModel
                                                                      .user_name,
                                                                  style: MediumText
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                              OurSizedBox(),
                                                              Text(
                                                                  userModel.bio,
                                                                  style:
                                                                      SmallText),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(),
                                                    OurSizedBox(),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            }))
                                        .toList());
                              });
                        }
                        return Container();
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
