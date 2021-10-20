import 'package:flutter/material.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/services/authentication_service/google_login_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              // final bool response = await GoogleSigninService().logout(context);
              // if (!response) {
              await EmailPasswordAuth().logout(context);
              // }
            },
            child: Text("Log out")),
      ),
    );
  }
}
