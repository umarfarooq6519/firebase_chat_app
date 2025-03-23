import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'General Sans',
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.black.withValues(alpha: 0.6),
  ),
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: Color(0xffd0e9bc),
    secondary: Color(0xffFFEDFA),
    surface: Color(0xffFDF8F9),
    onSurface: Colors.black.withValues(alpha: 0.8),
  ),
);

ThemeData darkMode = ThemeData(
  fontFamily: 'General Sans',
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.black.withValues(alpha: 0.6),
  ),
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Color(0xffd0e9bc),
    secondary: Color(0xffFFEDFA),
    surface: Color(0xff1A1A1A),
    onSurface: Color(0xffFDF8F9),
  ),
);
