import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/models/user_model.dart';
import 'package:myapp/services/check%20peserved%20name/check_reserved_name.dart';
import 'package:myapp/services/firebase%20storage/user_info_storage.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_outline_button.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel userModel;
  const EditProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _name_controller = TextEditingController();
  TextEditingController _bio_controller = TextEditingController();
  final FocusNode nameNode = FocusNode();
  final FocusNode bioNode = FocusNode();
  File? file;
  String imageUrl = "";
  bool changed = false;
  bool uploading = false;

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
        setState(() {
          file = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("$e =========");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _name_controller.text = widget.userModel.user_name;
      _bio_controller.text = widget.userModel.bio;
      imageUrl = widget.userModel.profile_pic;
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Edit profile",
            style: AppBarText,
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: uploading,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setSp(5),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      OurSizedBox(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ScreenUtil().setSp(30),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: file != null
                              ? Image.file(
                                  file!,
                                  height: ScreenUtil().setSp(200),
                                  width: ScreenUtil().setSp(200),
                                  fit: BoxFit.contain,
                                )
                              : widget.userModel.profile_pic != ""
                                  ? CachedNetworkImage(
                                      imageUrl: widget.userModel.profile_pic,

                                      // Image.network(
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        "assets/images/profile_holder.png",
                                      ),
                                      height: ScreenUtil().setSp(200),
                                      width: ScreenUtil().setSp(200),
                                      fit: BoxFit.contain,
                                      //   )
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: ScreenUtil().setSp(65),
                                      child: Text(
                                        widget.userModel.user_name[0],
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(
                                            50,
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      OurSizedBox(),
                      OutlinedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text("Change profile",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(17.5),
                            )),
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        controller: _name_controller,
                        validator: (value) {
                          if (value.trim().isNotEmpty) {
                            return null;
                          } else {
                            return "Can't be empty";
                          }
                        },
                        title: "Change name",
                        type: TextInputType.name,
                        number: 1,
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        controller: _bio_controller,
                        validator: (value) {},
                        title: "Change Bio",
                        type: TextInputType.name,
                        number: 1,
                      ),
                      OurSizedBox(),
                      uploading == false
                          ? OurElevatedButton(
                              title: "Save",
                              function: () async {
                                if (formKey.currentState!.validate()) {
                                  if (widget.userModel.user_name !=
                                      _name_controller.text.trim()) {
                                    setState(() {
                                      uploading = true;
                                    });
                                    final bool response =
                                        await CheckReservedName()
                                            .checkThisUserAlreadyPresentOrNot(
                                      _name_controller.text.trim(),
                                      context,
                                    );
                                    print(response);
                                    print("==================");
                                    if (response == true) {
                                      await UserProfileUpload().EditProfile(
                                        _name_controller.text,
                                        widget.userModel,
                                        _bio_controller.text,
                                        file,
                                        context,
                                        imageUrl,
                                      );
                                      setState(() {
                                        uploading = false;
                                      });
                                    } else {
                                      setState(() {
                                        uploading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            "Username already reserved",
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(15)),
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    setState(() {
                                      uploading = true;
                                    });
                                    await UserProfileUpload().EditProfile(
                                      _name_controller.text,
                                      widget.userModel,
                                      _bio_controller.text,
                                      file,
                                      context,
                                      imageUrl,
                                    );
                                    setState(() {
                                      uploading = false;
                                    });
                                  }
                                }
                              },
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(30),
                              ),
                              child: Container(
                                height: ScreenUtil().setSp(50),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: ScreenUtil().setSp(
                                            20,
                                          ),
                                          height: ScreenUtil().setSp(20),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setSp(
                                            10,
                                          ),
                                        ),
                                        Text(
                                          "Uploading",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(
                                              24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
