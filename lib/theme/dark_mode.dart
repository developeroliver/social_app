import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade500,
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.grey[300],
        displayColor: Colors.white,
      ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.grey.shade300,
      fontSize: 16,
    ),
    iconTheme: IconThemeData(
      color: Colors.grey.shade300,
    ),
  ),
);
