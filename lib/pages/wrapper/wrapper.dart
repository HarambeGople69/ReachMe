import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/injection/wrapper_injection.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/set_user_info/new_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  final int x;

  const Wrapper({
    Key? key,
    required this.x,
  }) : super(key: key);
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String name = "";

  Widget checkname() {
    print("$x is the state=============================");
    if (widget.x == 0) {
      return HomePage();
    } else {
      return UserInfoPage();
    }
  }

  getState() async {
    final box = GetStorage();
    setState(() {
      x = box.read("state");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getState();
  }

  late int x;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: checkname(),
    );
  }
}
