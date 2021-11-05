import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myapp/pages/screens/addpost_page.dart';
import 'package:myapp/pages/screens/home_page.dart';
import 'package:myapp/pages/screens/notification.dart';
import 'package:myapp/pages/screens/profile_page.dart';
import 'package:myapp/pages/screens/search_page.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  bool? _hideNavBar;

  @override
  void initState() {
    super.initState();
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
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          // curveSize: ScreenUtil().setSp(100),
          height: ScreenUtil().setSp(
            60,
          ),
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
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => ScreenUtil().setSp(45);

  @override
  double get activeIconMargin => ScreenUtil().setSp(0);

  @override
  double get iconSize => ScreenUtil().setSp(30);

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: ScreenUtil().setSp(13.5), color: color);
  }
}
