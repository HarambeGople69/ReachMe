import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle boldText = TextStyle(
  fontSize: ScreenUtil().setSp(30),
  fontWeight: FontWeight.bold,
);

TextStyle MediumText = TextStyle(
  fontSize: ScreenUtil().setSp(
    17.5,
  ),
);

TextStyle AppBarText = TextStyle(
  fontSize: ScreenUtil().setSp(30),
);

TextStyle SmallText = TextStyle(
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w400,
);

TextStyle TimeAgoText = TextStyle(
    color: Colors.grey[200],
    fontSize: ScreenUtil().setSp(
      12.5,
    ));
