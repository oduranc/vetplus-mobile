import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/theme/colors.dart';

TextTheme textTheme(bool isTablet) => TextTheme(
      titleSmall: _getTitleCarouselStyle(isTablet),
      bodySmall: _getBodyCarouselStyle(isTablet),
      labelMedium: _getBodyButtonStyle(isTablet),
    );

TextStyle _getTitleCarouselStyle(bool isTablet) {
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

TextStyle _getBodyCarouselStyle(bool isTablet) {
  final baseBodyCarousel = TextStyle(
    color: lightColorScheme.onSurfaceVariant,
    fontSize: 15.sp,
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

TextStyle _getBodyButtonStyle(bool isTablet) {
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
