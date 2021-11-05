import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/pages/authentication/login_page.dart';
import 'package:myapp/pages/wrapper/wrapper.dart';

class OuterWrapper extends StatefulWidget {
  const OuterWrapper({Key? key}) : super(key: key);

  @override
  State<OuterWrapper> createState() => _OuterWrapperState();
}

class _OuterWrapperState extends State<OuterWrapper> {
  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrapper(x: GetStorage().read("state")??0 );
        } else {
          return LoginPage();
        }
      },
    );
  }
}
