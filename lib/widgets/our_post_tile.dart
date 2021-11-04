import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/models/comment_model.dart';
import 'package:myapp/models/like_model.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/firestore/comment_info_detail.dart';
import 'package:myapp/services/firestore/likeunlike_info_detail.dart';
import 'package:myapp/services/firestore/notification_indo_detail.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'our_sizedbox.dart';

class OurPostTile extends StatefulWidget {
  final PostModel postModel;
  // final UserModel userModel;
  const OurPostTile({
    Key? key,
    required this.postModel,
    // required this.userModel,
  }) : super(key: key);

  @override
  State<OurPostTile> createState() => _OurPostTileState();
}

class _OurPostTileState extends State<OurPostTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ScreenUtil().setSp(30),
              ),
              child: Container(
                color: Colors.white,
                child: widget.postModel.profile_pic != ""
                    ? CachedNetworkImage(
                        imageUrl: widget.postModel.profile_pic,

                        // Image.network(
                        placeholder: (context, url) => Image.asset(
                          "assets/images/profile_holder.png",
                          fit: BoxFit.cover,
                        ),
                        height: ScreenUtil().setSp(40),
                        width: ScreenUtil().setSp(40),
                        fit: BoxFit.contain,
                        //   )
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: ScreenUtil().setSp(20),
                        child: Text(
                          widget.postModel.user_name[0],
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              20,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(15),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.postModel.user_name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(5),
                ),
                Text(
                  widget.postModel.location,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacer(),
            widget.postModel.OwnerId == FirebaseAuth.instance.currentUser!.uid
                ? Icon(
                    Icons.more_vert,
                    size: ScreenUtil().setSp(
                      25,
                    ),
                  )
                : Container(),
          ],
        ),
        OurSizedBox(),

        ClipRRect(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setSp(10),
          ),
          child: Container(
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl: widget.postModel.post_pic,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              placeholder: (context, url) => Image.asset(
                "assets/images/image_place_holder.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        OurSizedBox(),
        Text(
          widget.postModel.caption,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(15),
          ),
        ),
        // OurSizedBox(),
        // OurSizedBox(),
        Container(
          width: double.infinity,
          child: Row(
            children: [
              // IconButton(
              // onPressed: () {
              //   LikeDetailFirebase()
              //       .like_unlike(widget.postModel, widget.userModel);
              // },

              // icon: Icon(

              //   widget.postModel.likes.contains(widget.userModel.uid) == true
              //       ? FontAwesomeIcons.heartbeat
              //       : FontAwesomeIcons.heart,
              //   color: Colors.red,
              //   size: ScreenUtil().setSp(
              //     25,
              //   ),
              // ),
              // ),
              InkWell(
                onLongPress: () {
                  LikeBottomSheet(context);
                },
                onTap: () {
                  // LikeDetailFirebase().like_unlike_profile(widget.postModel);
                  LikeDetailFirebase().like_unlike(widget.postModel);
                },
                child: Icon(
                  widget.postModel.likes.contains(
                              FirebaseAuth.instance.currentUser!.uid) ==
                          true
                      ? FontAwesomeIcons.heartbeat
                      : FontAwesomeIcons.heart,
                  color: Colors.red,
                  size: ScreenUtil().setSp(
                    25,
                  ),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setSp(15),
              ),
              Text(
                widget.postModel.likeNumber.toString(),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              SizedBox(
                width: ScreenUtil().setSp(10),
              ),
              IconButton(
                onPressed: () {
                  // CommentDetailFirebase().uploadDetail("comment", postModel);
                  CommentBottomSheet(context);
                },
                icon: Icon(
                  FontAwesomeIcons.comment,
                  color: Colors.blue,
                  size: ScreenUtil().setSp(
                    25,
                  ),
                ),
              ),
              Text(
                widget.postModel.commentNumber.toString(),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              Spacer(),
              Text(
                timeago.format(
                  widget.postModel.timestamp.toDate(),
                ),
                style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: ScreenUtil().setSp(
                      12.5,
                    )),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  void CommentBottomSheet(context) {
    TextEditingController _comment_controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setSp(15),
                ),
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  children: [
                    OurSizedBox(),
                    Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(25),
                      ),
                    ),
                    Divider(),
                    OurSizedBox(),
                    Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(widget.postModel.postId)
                              .collection("Comments")
                              .orderBy("timestamp", descending: false)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs.length > 0) {
                                return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      CommentModel commentModel =
                                          CommentModel.fromJson(
                                              snapshot.data!.docs[index]);
                                      return InkWell(
                                        onLongPress: () async {
                                          if (commentModel.ownerId ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid) {
                                            await CommentDetailFirebase()
                                                .commentDelete(
                                              widget.postModel,
                                              commentModel,
                                              context,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            children: [
                                              OurSizedBox(),
                                              Row(
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
                                                      child: commentModel
                                                                  .profile_pic !=
                                                              ""
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  commentModel
                                                                      .profile_pic,

                                                              // Image.network(
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Image
                                                                          .asset(
                                                                "assets/images/profile_holder.png",
                                                              ),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          40),
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              //   )
                                                            )
                                                          : CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          25),
                                                              child: Text(
                                                                commentModel
                                                                    .user_name[0],
                                                                style:
                                                                    TextStyle(
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
                                                  SizedBox(
                                                    width:
                                                        ScreenUtil().setSp(15),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        commentModel.user_name,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: ScreenUtil()
                                                            .setSp(5),
                                                      ),
                                                      Container(
                                                        // color: Colors.red,
                                                        width: ScreenUtil()
                                                            .setSp(150),
                                                        child: Text(
                                                          commentModel.comment,
                                                          style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        12.5),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    width:
                                                        ScreenUtil().setSp(100),
                                                    child: Text(
                                                      timeago.format(
                                                        commentModel.timestamp
                                                            .toDate(),
                                                      ),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[200],
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                            12.5,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              OurSizedBox(),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }
                            return Center(
                              child: Text(
                                "No comments",
                              ),
                            );
                          }),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _comment_controller,
                            validator: (value) {
                              if (value.trim().isNotEmpty) {
                                return null;
                              } else {
                                return "Can't be empty";
                              }
                            },
                            title: "Add comment",
                            type: TextInputType.name,
                            number: 1,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setSp(15),
                        ),
                        InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              CommentDetailFirebase().uploadDetail(
                                _comment_controller.text,
                                widget.postModel,
                              );

                              setState(() {
                                _comment_controller.clear();
                              });
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
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void LikeBottomSheet(context) {
    
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
              children: [
                OurSizedBox(),
                Text(
                  "Likes",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                  ),
                ),
                Divider(),
                OurSizedBox(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Posts")
                        .doc(widget.postModel.postId)
                        .collection("Likes")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                LikeModel likeModel = LikeModel.fromJson(
                                    snapshot.data!.docs[index]);

                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Users")
                                        .where("uid", isEqualTo: likeModel.uid)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                                                .setSp(40),
                                                            width: ScreenUtil()
                                                                .setSp(40),
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            //   )
                                                          )
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: ScreenUtil()
                                                                .setSp(20),
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
                                                SizedBox(
                                                  width: ScreenUtil().setSp(20),
                                                ),
                                                Container(
                                                  width:
                                                      ScreenUtil().setSp(250),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userModel.user_name,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      OurSizedBox(),
                                                      Text(
                                                        userModel.bio,
                                                        style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(12.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OurSizedBox(),
                                            Divider(),
                                            OurSizedBox(),
                                          ],
                                        );
                                      }
                                      return Container();
                                    });
                              });
                        }
                        return Container();
                      }
                      return Container();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
