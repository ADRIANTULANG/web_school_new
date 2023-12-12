import 'package:flutter/material.dart';

class CustomTypography {
  static TextTheme theme = const TextTheme(

    /// HEADLINE

    /// Rarely used but important for headlines
    headlineLarge: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    /// Default for headlines
    headlineMedium: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    headlineSmall: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    /// TITLE

    /// Used for more emphasis on top page text
    titleLarge: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    /// Default for top page text
    titleMedium: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    titleSmall: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    /// BODY

    bodyLarge: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.30,
    ),

    /// Default for regular text
    bodyMedium: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.30,
    ),

    /// Default for captions
    bodySmall: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.30,
    ),

    /// LABEL

    /// Default for buttons
    labelLarge: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    labelMedium: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),

    labelSmall: TextStyle(
      // fontFamily: "PlayfairDisplay",
      fontSize: 12.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.30,
    ),
  );
}