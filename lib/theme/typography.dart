import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/theme/colors.dart';

TextTheme textTheme(bool isTablet) => TextTheme(
      titleLarge: _getAppbarTitleStyle(isTablet),
      titleSmall: _getCarouselTitleStyle(isTablet),
      displaySmall: _getBottomSheetTitleStyle(isTablet),
      bodyMedium: _getCarouselBodyStyle(isTablet),
      labelMedium: _getButtonBodyStyle(isTablet),
      labelSmall: _getFieldTextStyle(isTablet),
    );

TextStyle _getAppbarTitleStyle(bool isTablet) {
  final baseTitleButton = TextStyle(
    fontSize: 22.sp,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -0.12,
  );

  return baseTitleButton.copyWith(
    fontSize: isTablet ? 28 : null,
    height: isTablet ? 0.86 : null,
    letterSpacing: isTablet ? -0.28 : null,
  );
}

TextStyle _getCarouselTitleStyle(bool isTablet) {
  final baseTitleCarousel = TextStyle(
    color: Colors.black,
    fontSize: 25.sp,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -0.28,
  );

  return baseTitleCarousel.copyWith(
    fontSize: isTablet ? 33.60 : null,
    letterSpacing: isTablet ? -0.34 : null,
  );
}

TextStyle _getCarouselBodyStyle(bool isTablet) {
  final baseBodyCarousel = TextStyle(
    color: lightColorScheme.onSurfaceVariant,
    fontSize: 14.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w300,
    height: 1.5,
    letterSpacing: 0.50,
  );

  return baseBodyCarousel.copyWith(
    fontSize: isTablet ? 22 : null,
    height: isTablet ? 30 / 22 : null,
    letterSpacing: isTablet ? 0.33 : null,
  );
}

TextStyle _getButtonBodyStyle(bool isTablet) {
  final baseBodyButton = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.10,
  );

  return baseBodyButton.copyWith(
    fontSize: isTablet ? 22 : null,
    height: isTablet ? 20 / 22 : null,
    letterSpacing: isTablet ? 0.33 : null,
  );
}

TextStyle _getFieldTextStyle(bool isTablet) {
  final baseFieldText = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );

  return baseFieldText.copyWith(
    fontSize: isTablet ? 20 : null,
  );
}

TextStyle _getBottomSheetTitleStyle(bool isTablet) {
  final baseSheetTitle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.18,
  );

  return baseSheetTitle.copyWith(
    fontSize: isTablet ? 24 : null,
    height: isTablet ? 1 : null,
    letterSpacing: isTablet ? -0.24 : null,
  );
}
