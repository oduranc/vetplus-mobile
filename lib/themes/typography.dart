import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/colors.dart';

TextStyle getAppbarTitleStyle(bool isTablet) {
  final baseTitleButton = TextStyle(
    color: Colors.black,
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

TextStyle getCarouselTitleStyle(bool isTablet) {
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

TextStyle getCarouselBodyStyle(bool isTablet) {
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

TextStyle getButtonBodyStyle(bool isTablet) {
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

TextStyle getFieldTextStyle(bool isTablet) {
  final baseFieldText = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );

  return baseFieldText.copyWith(
    fontSize: isTablet ? 20 : null,
  );
}

TextStyle getBottomSheetTitleStyle(bool isTablet) {
  final baseSheetTitle = TextStyle(
    fontSize: 16.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.18,
  );

  return baseSheetTitle.copyWith(
    fontSize: isTablet ? 22 : null,
    height: isTablet ? 1 : null,
    letterSpacing: isTablet ? -0.24 : null,
  );
}

TextStyle getBottomSheetBodyStyle(bool isTablet) {
  final baseSheetBody = TextStyle(
    color: const Color(0xFF666666),
    fontSize: 13.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    height: 1.14,
    letterSpacing: 0.14,
  );

  return baseSheetBody.copyWith(fontSize: isTablet ? 21 : null);
}

TextStyle getLinkTextStyle(bool isTablet) {
  final baseLinkText = TextStyle(
    color: lightColorScheme.primary,
    fontSize: 14.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.21,
  );

  return baseLinkText.copyWith(
    fontSize: isTablet ? 16 : null,
    height: isTablet ? 1.25 : null,
    letterSpacing: isTablet ? 0.24 : null,
  );
}

TextStyle getSnackBarTitleStyle(bool isTablet) {
  final baseSnackBarTitle = TextStyle(
    color: Colors.black,
    fontSize: 14.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.14,
    letterSpacing: 0.50,
  );

  return baseSnackBarTitle.copyWith(fontSize: isTablet ? 22 : null);
}

TextStyle getSnackBarBodyStyle(bool isTablet) {
  final baseSnackBarBody = TextStyle(
    color: const Color(0xFF666666),
    fontSize: 12.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w300,
    height: 1.50,
    letterSpacing: 0.50,
  );

  return baseSnackBarBody.copyWith(fontSize: isTablet ? 20 : null);
}

TextStyle getNavBarTextStyle(bool isTablet) {
  final baseSnackBarBody = TextStyle(
    color: lightColorScheme.onInverseSurface,
    fontSize: 10.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    height: 1.33,
    letterSpacing: 0.5,
  );

  return baseSnackBarBody.copyWith(fontSize: isTablet ? 14 : null);
}

TextStyle getSectionTitle(bool isTablet) {
  final baseSnackBarBody = TextStyle(
    color: Color(0xFF010E16),
    fontSize: 18.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.27,
  );

  return baseSnackBarBody.copyWith(
    fontSize: isTablet ? 22 : null,
    letterSpacing: isTablet ? 0.33 : null,
  );
}
