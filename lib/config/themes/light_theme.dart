import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(),
    colorScheme: const ColorScheme.light(
        surface: Color(0xffF5F5F5),
        onSurface: Color(0xff303030),
        primary: Color(0xff7886C7),
        secondary: Color.fromARGB(255, 179, 189, 231),
        primaryContainer: Color(0xffFFFFFF),
        onPrimary: Color(0xffffffff),
        onPrimaryContainer: Color(0xFFC1C1C1)
        ));
