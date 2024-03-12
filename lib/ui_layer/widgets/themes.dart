import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../buisness_logic_layer/theme/theme_cubit.dart';
import '../../constatns/colors.dart';
import '../../shared/methods.dart';

abstract class MyTheme {
    static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal,
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarColor,
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.teal,
    backgroundColor: Colors.white,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black12,
    ),
  );

  static TextStyle buildTextStyle1(context) {
    return GoogleFonts.artifika(
      fontSize: 25.spMin,
      fontWeight: FontWeight.w600,
      color: wasLight(context) ? titles : Colors.white,
    );
  }

  static TextStyle buildTextStyle2(context) {
    return GoogleFonts.adamina(
      fontSize: 20.spMin,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }
  static TextStyle buildTextStyle3(context) {
    return GoogleFonts.adamina(
      fontSize: 15.spMin,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }
  static TextStyle buildTextStyle4(context) {
    return GoogleFonts.adamina(
      fontSize: 10.spMin,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }
}
