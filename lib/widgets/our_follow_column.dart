import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurFollowersColumn extends StatelessWidget {
  final int number;
  final String title;
  final Function function;
  const OurFollowersColumn({
    Key? key,
    required this.number,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Column(
        children: [
          Text(
            number.toString(),
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17.5),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
