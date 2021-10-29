import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/view_profile.dart';

class OurProfileTile extends StatelessWidget {
  final UserModel userModel;
  const OurProfileTile({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ViewProfile(
            uid: userModel.uid,
            userModel: userModel
          );
        }));
      },
      child: Row(
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
                      ),
                      height: ScreenUtil().setSp(60),
                      width: ScreenUtil().setSp(60),
                      fit: BoxFit.fitHeight,
                      //   )
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: ScreenUtil().setSp(25),
                      child: Text(
                        userModel.user_name[0],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            30,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userModel.user_name,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(17.5),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(5),
              ),
              SizedBox(
                width: ScreenUtil().setSp(150),
                child: Container(
                  padding: new EdgeInsets.only(right: 13.0),
                  child: Text(
                    userModel.bio,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(13.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
