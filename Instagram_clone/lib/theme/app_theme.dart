import 'package:flutter/material.dart';
import 'package:instagram/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.mobileBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.mobileBackgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
    ),
  );
}
