import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.outfitTextTheme(),
    colorScheme: const ColorScheme.dark(
      surface: Color(0xff0F0F0F),
      onSurface: Color(0xffFFFFFF),
      primary: Color(0xff7886C7),
      secondary: Color(0xFF2E2E2E),
      primaryContainer: Color(0xff151515),
      onPrimaryContainer: Color(0xFFC2C2C2),
    ));
