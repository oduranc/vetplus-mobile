import 'package:flutter/material.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/typography.dart';

ElevatedButtonThemeData elevatedButtonTheme(bool isMobile) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: lightColorScheme.primary,
        minimumSize: Size(isMobile ? 140 : 350, 0),
        padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: textTheme(isMobile).labelMedium,
      ),
    );
