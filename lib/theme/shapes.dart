import 'package:flutter/material.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/typography.dart';

ElevatedButtonThemeData elevatedButtonTheme(bool isTablet) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: lightColorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: textTheme(isTablet).labelMedium,
      ),
    );
