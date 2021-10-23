import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurOutlineButton extends StatelessWidget {
  final String title;
  final Function function;
  const OurOutlineButton({Key? key,required this.title,required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          function();
        },
        child: Text(title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(17.5),
            )),
      ),
    );
  }
}
