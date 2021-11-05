import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/notification_model.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_detail_photo.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:timeago/timeago.dart' as timeago;

class OurLikeCommentTile extends StatefulWidget {
  final NotificationModel notificationModel;
  const OurLikeCommentTile({Key? key, required this.notificationModel})
      : super(key: key);

  @override
  _OurLikeCommentTileState createState() => _OurLikeCommentTileState();
}

class _OurLikeCommentTileState extends State<OurLikeCommentTile> {
  @override
  Widget build(BuildContext context) {
    return widget.notificationModel.type == "like"
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OurDetailImageTile(
                  postId: widget.notificationModel.postId,
                );
              }));
            },
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: widget.notificationModel.senderProfile != ""
                            ? CachedNetworkImage(
                                imageUrl:
                                    widget.notificationModel.senderProfile,

                                // Image.network(
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/profile_holder.png",
                                  fit: BoxFit.cover,
                                ),
                                height: ScreenUtil().setSp(50),
                                width: ScreenUtil().setSp(50),
                                fit: BoxFit.contain,
                                //   )
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: ScreenUtil().setSp(25),
                                child: Text(
                                  widget.notificationModel.senderName[0],
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
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
                    Container(
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.notificationModel.senderName,
                              style: MediumText.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            height: ScreenUtil().setSp(5),
                          ),
                          Container(
                            child: Text(
                              "Liked your photo",
                              style: SmallText,
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setSp(5),
                          ),
                          Text(
                            timeago.format(
                              widget.notificationModel.timestamp.toDate(),
                            ),
                            style: TimeAgoText,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.notificationModel.post_pic,

                        // Image.network(
                        placeholder: (context, url) => Image.asset(
                          "assets/images/profile_holder.png",
                          fit: BoxFit.cover,
                        ),
                        height: ScreenUtil().setSp(60),
                        width: ScreenUtil().setSp(60),
                        fit: BoxFit.contain,
                        //   )
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OurDetailImageTile(
                  postId: widget.notificationModel.postId,
                );
              }));
            },
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: widget.notificationModel.senderProfile != ""
                            ? CachedNetworkImage(
                                imageUrl:
                                    widget.notificationModel.senderProfile,

                                // Image.network(
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/profile_holder.png",
                                  fit: BoxFit.cover,
                                ),
                                height: ScreenUtil().setSp(50),
                                width: ScreenUtil().setSp(50),
                                fit: BoxFit.contain,
                                //   )
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: ScreenUtil().setSp(25),
                                child: Text(
                                  widget.notificationModel.senderName[0],
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.notificationModel.senderName,
                              style: MediumText.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                          SizedBox(
                            height: ScreenUtil().setSp(5),
                          ),
                          Container(
                            child: Text(
                                "Commented: " +
                                    widget.notificationModel.comment,
                                style: SmallText),
                          ),
                          SizedBox(
                            height: ScreenUtil().setSp(5),
                          ),
                          Text(
                            timeago.format(
                              widget.notificationModel.timestamp.toDate(),
                            ),
                            style: TimeAgoText,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setSp(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.notificationModel.post_pic,

                        // Image.network(
                        placeholder: (context, url) => Image.asset(
                          "assets/images/profile_holder.png",
                          fit: BoxFit.cover,
                        ),
                        height: ScreenUtil().setSp(60),
                        width: ScreenUtil().setSp(60),
                        fit: BoxFit.contain,
                        //   )
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          );
  }
}
