import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/services/firebase%20storage/post_info_storage.dart';
import 'package:myapp/utils/styles.dart';
import 'package:myapp/widgets/our_elevated_button.dart';
import 'package:myapp/widgets/our_sizedbox.dart';
import 'package:myapp/widgets/our_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _caption_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? file;
  bool uploading = false;
  String currentAddress = '';
  // bool progress = false;

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

  getUserLocation() async {
    var status = await Permission.location.status;

    if (!status.isGranted) {
      await Permission.location.request();
    }
    if (await Permission.location.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    }

    try {
      // if (permission == LocationPermission.deniedForever) {
      //  getUserLocation();
      // }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // print(placemarks);
      // print("============================");
      Placemark placemark = placemarks[0];
      print(placemark.country);

      Placemark placemark2 = placemarks[2];

      setState(() {
        currentAddress = "${placemark2.name}, ${placemark.country}";
      });
      print(currentAddress);
      print("===================");
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Add Post",
            style: AppBarText,
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
            inAsyncCall: uploading,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setSp(20),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
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
                                    height: ScreenUtil().setSp(250),
                                    width: ScreenUtil().setSp(
                                      250,
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(25),
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Image.asset(
                                    "assets/images/image_place_holder.png",
                                    height: ScreenUtil().setSp(250),
                                    width: ScreenUtil().setSp(
                                      250,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      OurSizedBox(),
                      OutlinedButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setSp(20),
                            vertical: ScreenUtil().setSp(10),
                          ),
                        )),
                        onPressed: () {
                          pickImage();
                        },
                        child: Text(
                          "Pick image",
                          style: MediumText,
                        ),
                      ),
                      OurSizedBox(),
                      CustomTextField(
                        controller: _caption_controller,
                        validator: (value) {
                          if (value.isNotEmpty) {
                            return null;
                          } else {
                            return "Can't be empty";
                          }
                        },
                        title: "Add description",
                        type: TextInputType.name,
                        number: 1,
                      ),
                      OurSizedBox(),
                      uploading == false
                          ? OurElevatedButton(
                              title: "Post",
                              function: () async {
                                if (file == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        "Picture not selected",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(15)),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      uploading = true;
                                    });
                                    await getUserLocation();
                                    await PostUpload().uploadPost(
                                        _caption_controller.text.trim(),
                                        file,
                                        context,
                                        currentAddress);
                                    setState(() {
                                      file = null;
                                      _caption_controller.clear();
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
            )));
  }
}
