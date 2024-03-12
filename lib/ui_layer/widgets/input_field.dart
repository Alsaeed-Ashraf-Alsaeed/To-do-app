import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/constatns/colors.dart';

import '../../shared/methods.dart';

class InputField extends StatelessWidget {
  InputField({
    required this.hint,
    required this.inputFieldController,
    this.enabled,
    this.suffix,
    this.width,
    this.onFieldSubmitted,
  });

  TextEditingController? inputFieldController;

  String hint;
  Widget? suffix;
  bool? enabled;
  double? width ;
  Function(String txt)? onFieldSubmitted ;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width==null?380.w:width,
      height: 60.h,
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        style: TextStyle(
          fontWeight:FontWeight.w500,
          fontSize: 16.spMin,
          color: wasLight(context) ? Colors.black : Colors.white,
        ),
        controller: inputFieldController,
        autofocus: false,
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: TextStyle(
            fontSize: 17.spMin,
            fontWeight: FontWeight.w500,
            color: wasLight(context) ? Colors.teal : Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              width: 2.w,
              color: wasLight(context) ? Colors.teal : Colors.white,
            ),
          ),
          disabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 2.w,
              color: wasLight(context) ? Colors.teal : Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: wasLight(context) ? Colors.teal : Colors.white,
            ),
          ),
          suffixIcon: suffix,
          suffixIconColor: wasLight(context) ? Colors.teal : Colors.white,
        ),
      ),
    );
  }
}
