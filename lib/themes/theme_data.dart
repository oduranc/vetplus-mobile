import 'package:flutter/material.dart';
import 'package:vetplus/themes/colors.dart';
import 'package:vetplus/themes/shapes.dart';

ThemeData buildAppTheme(bool isTablet) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    elevatedButtonTheme: elevatedButtonTheme(isTablet),
    textButtonTheme: textButtonTheme(isTablet),
    inputDecorationTheme: inputDecorationTheme(isTablet),
    appBarTheme: appBarTheme(isTablet),
    dividerColor: const Color(0xFFDCDCDD),
    navigationBarTheme: navigationBarTheme(isTablet),
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: lightColorScheme.primary),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFFACACAD)),
      ),
    ),
    searchBarTheme: searchBarThemeData(isTablet),
    checkboxTheme: checkboxThemeData(isTablet),
  );
}
