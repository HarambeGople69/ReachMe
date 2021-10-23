import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/screens/addpost_page.dart';
import 'package:myapp/pages/screens/home_page.dart';
import 'package:myapp/pages/screens/message_page.dart';
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

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      SearchPage(),
      AddPost(),
      MessagePage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(12.5),
        ),
        icon: FaIcon(
          FontAwesomeIcons.home,
          size: ScreenUtil().setSp(20),
        ),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
        inactiveColorSecondary: Colors.purple,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(12.5),
        ),
        icon: FaIcon(
          FontAwesomeIcons.searchPlus,
          size: ScreenUtil().setSp(20),
        ),
        title: ("Search"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.add,
          size: ScreenUtil().setSp(20),
        ),
        title: ("Add"),
        activeColorPrimary: Colors.blueAccent,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(12.5),
        ),
        icon: FaIcon(
          FontAwesomeIcons.facebookMessenger,
          size: ScreenUtil().setSp(20),
        ),
        title: ("Messages"),
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(12.5),
        ),
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          // navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          //     ? 0.0
          //     : kBottomNavigationBarHeight,
          navBarHeight: ScreenUtil().setSp(50),
          hideNavigationBarWhenKeyboardShows: true,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.all,
          bottomScreenMargin: 0.0,

          hideNavigationBar: _hideNavBar,
          decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                ScreenUtil().setSp(20),
              ),
              topRight: Radius.circular(
                ScreenUtil().setSp(20),
              ),
            ),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style15, // Choose the nav bar style with this property
        ),
      ),
    );
  }
}
