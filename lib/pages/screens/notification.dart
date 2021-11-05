import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/notification_model.dart';
import 'package:myapp/pages/screens/view_profile.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_like_comment_notification_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notification",
          style: AppBarText,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(15),
            vertical: ScreenUtil().setSp(5),
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Notification")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("Notify")
                  .orderBy("timestamp", descending: true)
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
                          NotificationModel notificationModel =
                              NotificationModel.fromJson(
                                  snapshot.data!.docs[index]);
                          return notificationModel.type == "follow"
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(30),
                                          ),
                                          child: Container(
                                            color: Colors.white,
                                            child: notificationModel
                                                        .senderProfile !=
                                                    ""
                                                ? CachedNetworkImage(
                                                    imageUrl: notificationModel
                                                        .senderProfile,

                                                    // Image.network(
                                                    placeholder:
                                                        (context, url) =>
                                                            Image.asset(
                                                      "assets/images/profile_holder.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                    height:
                                                        ScreenUtil().setSp(50),
                                                    width:
                                                        ScreenUtil().setSp(50),
                                                    fit: BoxFit.contain,
                                                    //   )
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius:
                                                        ScreenUtil().setSp(25),
                                                    child: Text(
                                                      notificationModel
                                                          .senderName[0],
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
                                        SizedBox(
                                          width: ScreenUtil().setSp(15),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(notificationModel.senderName,
                                                style: MediumText.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            SizedBox(
                                              height: ScreenUtil().setSp(5),
                                            ),
                                            Container(
                                              width: ScreenUtil().setSp(230),
                                              child: Text(
                                                "followed you",
                                                style: SmallText,
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setSp(5),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                timeago.format(
                                                  notificationModel.timestamp
                                                      .toDate(),
                                                ),
                                                style: TimeAgoText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                )
                              : OurLikeCommentTile(
                                  notificationModel: notificationModel);
                        });
                  } else {
                    return Center(
                      child: Lottie.asset('assets/animations/notification.json',
                          fit: BoxFit.cover, height: 250.h, width: 250.h),
                    );
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
}
