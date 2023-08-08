import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/typography.dart';

final InputBorder _textFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    width: 0.50,
    color: lightColorScheme.outlineVariant,
  ),
);

ElevatedButtonThemeData elevatedButtonTheme(bool isTablet) =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(0),
        foregroundColor: Colors.white,
        backgroundColor: lightColorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: getButtonBodyStyle(isTablet),
      ),
    );

InputDecorationTheme inputDecorationTheme(bool isTablet) =>
    InputDecorationTheme(
      labelStyle: getFieldTextStyle(isTablet)
          .copyWith(color: lightColorScheme.onInverseSurface),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
      errorStyle: TextStyle(
        color: const Color(0xFFD4322E),
        fontSize: isTablet ? 16 : 12.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: isTablet ? 2 : 1.50,
        letterSpacing: 0.50,
      ),
      errorBorder: _textFieldBorder,
      focusedBorder: _textFieldBorder,
      enabledBorder: _textFieldBorder,
      focusedErrorBorder: _textFieldBorder,
    );
