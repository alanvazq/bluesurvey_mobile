import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.outfitTextTheme(),
    colorScheme: const ColorScheme.light(
        surface: Color(0xffF5F5F5),
        onSurface: Color(0xff303030),
        primary: Color(0xff537fe7),
        secondary: Color(0xFFffffff),
        primaryContainer: Color(0xffFFFFFF),
        onPrimary: Color(0xffffffff),
        onSecondary: Color(0xff537fe7),
        onPrimaryContainer: Color(0xFFC1C1C1),
        tertiaryContainer: Color(0xFFEAEAEA),
        onTertiaryContainer: Color(0xFFABABAB),
        onSurfaceVariant: Color(0xFFABABAB),
        
        ));
