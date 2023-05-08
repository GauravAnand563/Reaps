import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appThemeData = ThemeData(
  fontFamily: 'Montserrat',
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyText2: TextStyle(
      color: AppColors.primary600,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.accent200,
  ),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      statusBarColor: AppColors.primary400,
    ),
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: AppColors.primary400,
  ),
);

final kh1 = GoogleFonts.roboto(
    color: Colors.white,
    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
final kh2 = GoogleFonts.poppins(
    color: Colors.white,
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
final kh3 = GoogleFonts.sourceSansPro(
    color: Colors.white,
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300));
final kh4 = GoogleFonts.notoSans(
    color: Colors.white,
    textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500));
    final  kh5 = GoogleFonts.notoSans(
    color: Colors.green.shade100,
    textStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.green.shade100,));

const kScaffoldBackgroundColor = Color(0xff191A19);
