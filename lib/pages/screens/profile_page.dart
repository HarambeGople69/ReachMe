import 'package:flutter/material.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              EmailPasswordAuth().logout(context);
            },
            child: Text("Logout")),
      ),
    );
  }
}
