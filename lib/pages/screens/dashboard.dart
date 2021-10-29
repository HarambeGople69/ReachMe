import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/screens/addpost_page.dart';
import 'package:myapp/pages/screens/home_page.dart';
import 'package:myapp/pages/screens/notification.dart';
import 'package:myapp/pages/screens/profile_page.dart';
import 'package:myapp/pages/screens/search_page.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/services/authentication_service/google_login_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  PersistentTabController? _controller;
  bool? _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  Widget show_page = HomePage();

  Widget check_postion(int index) {
    switch (index) {
      case 0:
        return HomePage();
        break;
      case 1:
        return SearchPage();
        break;
      case 2:
        return AddPost();
        break;
      case 3:
        return NotificationPage();
        break;
      case 4:
        return ProfilePage();
        break;
      default:
        return HomePage();
    }
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: show_page,
      )),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixed,
        backgroundColor: Colors.purple[300],
        items: [
          TabItem(
            icon: Icons.home,
            title: 'Home',
          ),
          TabItem(
            icon: Icons.search,
            title: 'Search',
          ),
          TabItem(
            icon: Icons.add,
            title: 'Add',
          ),
          TabItem(
            icon: Icons.notification_important,
            title: 'Notification',
          ),
          TabItem(
            icon: Icons.people,
            title: 'Profile',
          ),
        ],
        onTap: (int i) {
          setState(() {
            index = i;
            show_page = check_postion(index);
          });
        },
      ),
    );
  }
}
