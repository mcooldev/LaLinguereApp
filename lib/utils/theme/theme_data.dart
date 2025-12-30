import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_linguere/utils/constants/app_colors.dart';

class AppTheme {
  final ThemeData theme = ThemeData().copyWith(
    /// color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff0090CF),
      //
      surface: Colors.white,
      onSurface: Colors.black,
      //
      primary: blueLinguere,
      onPrimary: Colors.white,
      //
      secondary: darkBlue,
      onSecondary: Colors.white,
      //
      tertiary: yellowLinguere,
      onTertiary: Colors.black,
    ),

    /// text theme
    textTheme: const TextTheme().copyWith(
      headlineLarge: GoogleFonts.manrope(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: bodyText,
      ),
      labelLarge: GoogleFonts.manrope(fontSize: 15, color: Colors.black),
      labelMedium: GoogleFonts.manrope(fontSize: 14, color: Colors.black),
      labelSmall: GoogleFonts.manrope(fontSize: 13, color: Colors.black),
    ),

    /// bottomSheet
    bottomSheetTheme: const BottomSheetThemeData().copyWith(
      backgroundColor: Colors.white,
      showDragHandle: true,
      dragHandleColor: strokeColor,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40)),
    ),

    ///
    scaffoldBackgroundColor: Colors.white,
    //
  );
}
