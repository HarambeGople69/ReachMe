import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/models/post_model.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/widgets/our_post_tile.dart';
import 'package:myapp/widgets/our_profile_header.dart';

class ViewProfile extends StatefulWidget {
  final UserModel userModel;
  const ViewProfile({
    Key? key,
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
              child: Column(
                children: [
                  UserProfileHeader(
                    userModel: widget.userModel,
                  ),
                  Divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Posts")
                          .where("ownerId", isEqualTo: widget.userModel.uid)
                          // .orderBy("timestamp", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.length > 0) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  PostModel postModel = PostModel.fromJson(
                                      snapshot.data!.docs[index]);
                                  return OurPostTile(
                                    postModel: postModel,
                                    userModel: widget.userModel,
                                  );
                                });
                          }
                        }
                        return Container();
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
