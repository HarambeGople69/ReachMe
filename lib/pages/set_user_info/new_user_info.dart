import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/services/authentication_service/email_password_service.dart';
import 'package:myapp/services/authentication_service/google_login_service.dart';
import 'package:myapp/services/check%20peserved%20name/check_reserved_name.dart';
import 'package:myapp/services/firebase%20storage/user_info_storage.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final bioNode = FocusNode();
  File? file;

  pickImage() async {
    Permission _permission = Permission.storage;
    PermissionStatus _status = await _permission.request();

    if (!_status.isGranted) {
      await Permission.location.request();
    }
    if (_status.isPermanentlyDenied) {
      AppSettings.openAppSettings();
      print("=========================");
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {});
        file = File(result.files.single.path!);
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setSp(20),
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Set you profile",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              OurSizedBox(),
              
              Center(
                child: file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setSp(25),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Image.file(
                            file!,
                            height: ScreenUtil().setSp(150),
                            width: ScreenUtil().setSp(
                              150,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setSp(25),
                        ),
                        child: Image.asset(
                          "assets/images/profile.png",
                          height: ScreenUtil().setSp(150),
                          width: ScreenUtil().setSp(
                            150,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              OurSizedBox(),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text("Upload profile picture"),
                ),
              ),
              Text(
                "Ente your name:",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    17.5,
                  ),
                ),
              ),
              OurSizedBox(),
              CustomTextField(
                icon: Icons.person,
                start: nameNode,
                end: bioNode,
                controller: _nameController,
                validator: (value) {
                  if (value.trim().isNotEmpty || value.trim().length > 6) {
                    return null;
                  } else {
                    return "Must be atleast 6 character long";
                  }
                },
                title: "Enter name",
                type: TextInputType.name,
                number: 0,
              ),
              OurSizedBox(),
              Text(
                "Ente your bio:",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    17.5,
                  ),
                ),
              ),
              OurSizedBox(),
              CustomTextField(
                start: bioNode,
                controller: _bioController,
                validator: (value) {},
                title: "Enter bio",
                type: TextInputType.name,
                number: 1,
              ),
              OurSizedBox(),
              OurElevatedButton(
                title: "Save",
                function: () async {
                  if (formKey.currentState!.validate()) {
                    final bool response = await CheckReservedName()
                        .checkThisUserAlreadyPresentOrNot(
                      _nameController.text.trim(),
                      context,
                    );
                    if (response == true) {
                      UserProfileUpload().uploadProfile(
                        _nameController.text.trim(),
                        _bioController.text.trim(),
                        file,
                        context,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Username already reserved",
                            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
