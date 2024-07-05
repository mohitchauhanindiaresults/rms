import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2B2626);
const Color secondaryColor = Color(0xFFF5F5F5);
const Color accentColor = Color(0xFFeb3254);

final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  backgroundColor: accentColor,
  scaffoldBackgroundColor: secondaryColor,
  textTheme: TextTheme(
    bodyText1: TextStyle(fontFamily: 'Gilroy', color: primaryColor),
    bodyText2: TextStyle(fontFamily: 'Gilroy', color: primaryColor),
    headline6: TextStyle(fontFamily: 'Gilroy', color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: primaryColor, fontFamily: 'Gilroy'),
    prefixIconColor: primaryColor,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    filled: true,
    fillColor: secondaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // Set the text color to white
       foregroundColor: Colors.white,
    ),
  ),

);
