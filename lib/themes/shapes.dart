import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/colors.dart';
import 'package:vetplus/themes/typography.dart';

TextButtonThemeData textButtonTheme(bool isTablet) => TextButtonThemeData(
        style: TextButton.styleFrom(
      minimumSize: const Size.fromHeight(0),
      padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: getButtonBodyStyle(isTablet),
    ));

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

InputDecorationTheme inputDecorationTheme(bool isTablet) {
  final InputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 0.50,
      color: lightColorScheme.outlineVariant,
    ),
  );

  return InputDecorationTheme(
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
    errorBorder: textFieldBorder,
    focusedBorder: textFieldBorder,
    enabledBorder: textFieldBorder,
    focusedErrorBorder: textFieldBorder,
  );
}

AppBarTheme appBarTheme(bool isTablet) => AppBarTheme(
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: getAppbarTitleStyle(isTablet),
    iconTheme: const IconThemeData(color: Colors.black));

NavigationBarThemeData navigationBarTheme(bool isTablet) {
  return NavigationBarThemeData(
    height: isTablet ? 96 : 90.sp,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.black,
    indicatorColor: Colors.transparent,
    iconTheme: MaterialStateProperty.resolveWith((states) {
      double size = isTablet ? 34 : 28.sp;
      if (states.contains(MaterialState.selected)) {
        return IconThemeData(color: const Color(0xFF27AAE1), size: size);
      } else {
        return IconThemeData(color: const Color(0xFFACACAD), size: size);
      }
    }),
    labelTextStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return getNavBarTextStyle(isTablet).copyWith(
          color: const Color(0xFF27AAE1),
        );
      } else {
        return getNavBarTextStyle(isTablet);
      }
    }),
  );
}

SearchBarThemeData searchBarThemeData(bool isTablet) {
  final textStyle = TextStyle(
    color: Colors.black,
    fontSize: isTablet ? 20 : 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    height: 0,
  );

  return SearchBarThemeData(
    backgroundColor: const MaterialStatePropertyAll(Colors.white),
    shadowColor: const MaterialStatePropertyAll(Colors.white),
    surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
    elevation: const MaterialStatePropertyAll(2),
    padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: isTablet ? 20 : 15.sp)),
    textStyle: MaterialStatePropertyAll(textStyle),
    hintStyle: MaterialStatePropertyAll(
        textStyle.copyWith(color: const Color(0xFF858586))),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFF4F4F4)),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

CheckboxThemeData checkboxThemeData(bool isTablet) {
  return CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: const BorderSide(
      color: Color(0xFFACACAD),
    ),
    fillColor: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const Color(0xFF27AAE1)
          : Colors.white,
    ),
  );
}
