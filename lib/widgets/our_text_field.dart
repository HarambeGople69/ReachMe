import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? start;
  final FocusNode? end;
  final Function(String) validator;
  final Function(String)? onchange;
  final IconData? icon;
  final TextInputType type;
  final String title;
  final int? length;
  final int number;
  final String? initialValue;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.validator,
    this.icon,
    this.onchange,
    required this.title,
    required this.type,
    this.length,
    this.start,
    this.end,
    required this.number,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.start,
      onEditingComplete: () {
        if (widget.number == 0) {
          FocusScope.of(context).requestFocus(
            widget.end,
          );
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      // onChanged: (String value) => widget.onchange!(value),
      validator: (String? value) => widget.validator(value!),
      style: TextStyle(fontSize: ScreenUtil().setSp(15)),
      keyboardType: widget.type,
      maxLines: widget.length,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.title,
        // enabledBorder: InputBorder.none,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setSp(
              30,
            ),
          ),
        ),

        labelStyle: TextStyle(
          fontSize: ScreenUtil().setSp(
            20,
          ),
        ),
        prefixIcon: Icon(
          widget.icon,
          size: ScreenUtil().setSp(20),
        ),

        // labelStyle: paratext,
        errorStyle: TextStyle(
          fontSize: ScreenUtil().setSp(
            15,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// // ignore: must_be_immutable
// class CustomLabelTextField extends StatefulWidget {
//   CustomLabelTextField(
//       {Key? key,
//       required this.controller,
//       this.obscureText = false,
//       this.hintText,
//       this.focusNode,
//       this.nextNode,
//       this.onFieldSubmitted,
//       this.textInputAction,
//       this.textInputType,
//       this.length,
//       this.onTap,
//       this.textCapitalization,
//       this.labelText,
//       this.inputFormatters})
//       : super(key: key);
//   final TextEditingController controller;
//   bool obscureText;
//   final String? hintText;
//   final FocusNode? focusNode;
//   final FocusNode? nextNode;
//   final TextInputAction? textInputAction;
//   final TextInputType? textInputType;
//   final Function()? onTap;
//   final TextCapitalization? textCapitalization;
//   final List<TextInputFormatter>? inputFormatters;
//   final void Function(String value)? onFieldSubmitted;
//   final int? length;
//   final String? labelText;

//   @override
//   _CustomLabelTextFieldState createState() => _CustomLabelTextFieldState();
// }

// class _CustomLabelTextFieldState extends State<CustomLabelTextField> {
//   final controller = TextEditingController();
//   @override
//   void initState() {
//     focusNode.addListener(_focusNodeListner);
//     super.initState();
//   }

//   Future<void> _focusNodeListner() async {
//     if (focusNode.hasFocus) {
//       print('text field got focus');
//     } else {
//       print('text field lost focus');
//     }
//   }

//   FocusNode focusNode = FocusNode();
//   bool hasFocus = false;
//   @override
//   Widget build(BuildContext context) {
//     void _onFieldSubmitted(String text) {
//       widget.onFieldSubmitted?.call(text);
//       if (widget.nextNode != null) {
//         widget.nextNode!.requestFocus();
//       } else {
//         FocusScope.of(context).unfocus();
//       }
//     }

//     return Container(
      // alignment: Alignment.topLeft,
      // height: 60,
      // padding: const EdgeInsets.symmetric(vertical: 05, horizontal: 10),
      // margin: EdgeInsets.symmetric(vertical: 5),
      
//       child: TextFormField(
//         onFieldSubmitted: _onFieldSubmitted,
//         validator: (value) {
//           if (value == null || value == '') {
//             return '${widget.hintText} is required.';
//           }
//         },
//         focusNode: focusNode,
//         textCapitalization:
//             widget.textCapitalization ?? TextCapitalization.none,
//         onTap: widget.onTap,
//         controller: widget.controller,
//         inputFormatters: widget.inputFormatters ?? [],
//         keyboardType: widget.textInputType,
//         textInputAction: widget.textInputAction ??
//             (widget.nextNode == null
//                 ? TextInputAction.done
//                 : TextInputAction.next),
//         cursorColor: Colors.red,
//         obscureText: widget.obscureText,
//         decoration: InputDecoration(
//           isDense: true,
//           labelText: widget.hintText,
          // enabledBorder: InputBorder.none,
          // border: InputBorder.none,
          // errorBorder: InputBorder.none,
          // focusedBorder: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
