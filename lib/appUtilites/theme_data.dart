import 'package:flutter/material.dart';

import 'app_colors.dart';

class ThemeClass {

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: whiteColor,
    brightness: Brightness.light,
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: blackColor),
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(color: blackColor),
      color: grayShade100,
      titleTextStyle: TextStyle(color: blackColor,fontSize: 20),
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: blackColor,
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: ColorScheme.dark(), // Set primary color for dark mode
    iconTheme: IconThemeData(color: whiteColor),
    appBarTheme: AppBarTheme(
      color: whiteColor12,
      elevation: 0,
    ),
  );

}

