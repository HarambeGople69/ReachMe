import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/pages/screens/messager_home.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:myapp/widgets/our_sizedbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAni = true;
  a() {
    showAni = false;
    print(showAni.toString() + " heeeer etaaaaaaaaaaaaaaaaaa");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Feeds", style: AppBarText),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MessangerHome();
              }));
            },
            icon: FaIcon(
              FontAwesomeIcons.facebookMessenger,
              size: ScreenUtil().setSp(
                25,
              ),
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
                              OurSizedBox(),
                              userModel.following == 0
                                  ? Container(
                                      child: Lottie.asset(
                                          'assets/animations/post.json',
                                          fit: BoxFit.cover,
                                          height: 250.h,
                                          width: 350.h),
                                    )
                                  : StreamBuilder(
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

                                                  return userModel.followingList
                                                          .contains(
                                                              postModel.OwnerId)
                                                      ? OurPostTile(
                                                          postModel: postModel,
                                                          // userModel: userModel,
                                                        )
                                                      : Container();
                                                });
                                          } else {
                                            return Expanded(
                                              child: Container(),
                                            );
                                          }
                                        } else {
                                          return Container(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
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
    );
  }
}
