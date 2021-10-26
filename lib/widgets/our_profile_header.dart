import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/edit_profile_page.dart';
import 'package:myapp/widgets/our_outline_button.dart';

import 'our_follow_column.dart';
import 'our_sizedbox.dart';

class UserProfileHeader extends StatelessWidget {
  final UserModel userModel;
  const UserProfileHeader({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          fit: BoxFit.contain,
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
              OurSizedBox(),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  userModel.user_name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  userModel.bio,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12.5),
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
          width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OurFollowersColumn(
                    number: userModel.post,
                    title: "Post",
                  ),
                  OurFollowersColumn(
                    number: 0,
                    title: "Following",
                  ),
                  OurFollowersColumn(
                    number: 0,
                    title: "Followers",
                  ),
                ],
              ),
              OurSizedBox(),
              userModel.uid == FirebaseAuth.instance.currentUser!.uid
                  ? OurOutlineButton(
                      title: "Upload Profile",
                      function: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditProfilePage(userModel: userModel);
                            },
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    )
                  : OurOutlineButton(
                      title: "Follow",
                      function: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return EditProfilePage(userModel: userModel);
                        //     },
                        //     fullscreenDialog: true,
                        //   ),
                        // );
                      },
                    ),
            ],
          ),
        )
      ],
    );
  }
}
