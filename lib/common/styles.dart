import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColorWhite = Color(0xFFFFFFFF);
const Color orangeColor = Color(0xFFFE724C);
const Color textColor = Colors.black;

final TextTheme textTheme = GoogleFonts.poppinsTextTheme();

const AppBarTheme darkAppBarTheme = AppBarTheme(
  centerTitle: true,
  color: darkPrimaryColor,
  titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: primaryColorWhite,
      overflow: TextOverflow.ellipsis),
  iconTheme: IconThemeData(
    color: primaryColorWhite,
    size: 26,
  ),
);

const AppBarTheme lightAppBarTheme = AppBarTheme(
  centerTitle: true,
  color: primaryColorWhite,
  titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      overflow: TextOverflow.ellipsis),
  iconTheme: IconThemeData(
    color: darkPrimaryColor,
    size: 26,
  ),
);

final ElevatedButtonThemeData buttonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 5,
    backgroundColor: orangeColor,
    foregroundColor: primaryColorWhite,
    textStyle: const TextStyle(
      fontWeight: FontWeight.w500,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColorWhite,
        onPrimary: Colors.black,
        secondary: orangeColor,
      ),
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: textTheme,
  appBarTheme: lightAppBarTheme,
  elevatedButtonTheme: buttonThemeData,
);

const Color darkPrimaryColor = Color(0xFF000000);

ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: darkPrimaryColor,
          onPrimary: primaryColorWhite,
          secondary: orangeColor,
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: textTheme,
    appBarTheme: darkAppBarTheme,
    elevatedButtonTheme: buttonThemeData);
