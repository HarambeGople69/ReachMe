import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/injection/wrapper_injection.dart';
import 'package:myapp/pages/screens/dashboard.dart';
import 'package:myapp/pages/set_user_info/new_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  final dynamic x;

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
    if (widget.x == 0) {
      return DashBoard();
    } else {
      return UserInfoPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: checkname(),
    );
  }
}
