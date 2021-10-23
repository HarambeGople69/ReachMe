import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';

import 'our_sizedbox.dart';

class OurPostTile extends StatelessWidget {
  final UserModel userModel;
  final PostModel postModel;
  const OurPostTile({
    Key? key,
    required this.userModel,
    required this.postModel,
  }) : super(key: key);

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
                child: userModel.profile_pic != ""
                    ? CachedNetworkImage(
                        imageUrl: userModel.profile_pic,

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
                          userModel.user_name[0],
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
                  userModel.user_name,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(5),
                ),
                Text(
                  postModel.location,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.more_vert,
              size: ScreenUtil().setSp(
                25,
              ),
            ),
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
              imageUrl: postModel.post_pic,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              placeholder: (context, url) => Image.asset(
                "assets/images/image_place_holder.png",
              ),
            ),
          ),
        ),
        OurSizedBox(),
        Text(
          postModel.caption,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(15),
          ),
        ),
        // OurSizedBox(),
        OurSizedBox(),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.heart,
              color: Colors.red,
              size: ScreenUtil().setSp(
                20,
              ),
            ),
            SizedBox(
              width: ScreenUtil().setSp(10),
            ),
            Icon(
              FontAwesomeIcons.comment,
              color: Colors.blue,
              size: ScreenUtil().setSp(
                20,
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
}
