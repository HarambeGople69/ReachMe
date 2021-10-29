import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordForm extends StatelessWidget {
  final bool? see;
  final Function? changesee;
  final FocusNode? start;
  final FocusNode? end;
  final String? title;
  final Function(String)? validator;
  final int number;
  final Function(String)? onchange;

  final TextEditingController controller;

  const PasswordForm({
    Key? key,
    this.see,
    this.changesee,
    required this.controller,
    this.title,
    required this.validator,
    this.onchange,
    this.start,
    this.end,
    required this.number,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        focusNode: start,
        onEditingComplete: () {
          if (number == 0) {
            FocusScope.of(context).requestFocus(
              end,
            );
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        validator: (String? value) => validator!(value!),
        style: TextStyle(fontSize: ScreenUtil().setSp(15)),
        controller: controller,
        obscureText: see!,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(
            Icons.lock,
            size: ScreenUtil().setSp(20),
          ),
          suffixIcon: InkWell(
              onTap: () {
                changesee!();
              },
              child: !see!
                  ? Icon(
                      Icons.visibility_off,
                      size: ScreenUtil().setSp(20),
                    )
                  : (Icon(
                      Icons.visibility,
                      size: ScreenUtil().setSp(20),
                    ))),

          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(
                30,
              ),
            ),
          ),
          // labelStyle: paratext,
          errorStyle: TextStyle(
            fontSize: ScreenUtil().setSp(
              15,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(
              20,
            ),
          ),
        ));
  }
}
