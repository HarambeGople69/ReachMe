import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/widgets/our_profile_tile.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setSp(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                      icon: Icons.person,
                      controller: _search_controller,
                      validator: (value) {
                        if (value.trim().isNotEmpty) {
                          return null;
                        } else {
                          return "Can't be empty";
                        }
                      },
                      onchange: (value) {
                        // setState(() {
                        // _search_controller.text = value;
                        // });
                      },
                      title: "Search User",
                      type: TextInputType.name,
                      number: 1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setSp(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _search_controller.text.trim().isNotEmpty
                ? Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Users")
                            .where("user_name",
                                isEqualTo: _search_controller.text)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.length > 0) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    UserModel userModel = UserModel.fromJson(
                                        snapshot.data!.docs[index]);
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        // horizontal: ScreenUtil().setSp(20),
                                        vertical: ScreenUtil().setSp(20),
                                      ),
                                      child:
                                          OurProfileTile(userModel: userModel),
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text("Cannot find"),
                              );
                            }
                          }
                          return Expanded(
                            child: Center(
                              child: Lottie.asset(
                                  'assets/animations/search_animation.json',
                                  fit: BoxFit.cover,
                                  height: 150.h,
                                  width: 150.h),
                            ),
                          );
                        })
                        )
                : Expanded(
                    child: Center(
                      child: Lottie.asset(
                          'assets/animations/search_animation.json',
                          fit: BoxFit.cover,
                          height: 150.h,
                          width: 150.h),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
