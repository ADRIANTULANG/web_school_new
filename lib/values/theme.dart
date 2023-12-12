import 'package:flutter/material.dart';
import 'package:web_school/values/strings/colors.dart';
import 'package:web_school/values/strings/typography.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorTheme.primaryBlack,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorTheme.primaryRed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
      ),
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(

      ),
      contentTextStyle: TextStyle(
        fontSize: 14.0,
      ),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
      )
    ),

    textTheme: CustomTypography.theme,
  );
}