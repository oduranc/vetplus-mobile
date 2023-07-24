import 'package:flutter/material.dart';
import 'package:vetplus/theme/colors.dart';

TextTheme textTheme(bool isMobile) => TextTheme(
      titleSmall: _getTitleCarouselStyle(isMobile),
      bodySmall: _getBodyCarouselStyle(isMobile),
      labelMedium: _getBodyButtonStyle(isMobile),
    );

TextStyle _getTitleCarouselStyle(bool isMobile) {
  const baseTitleCarousel = TextStyle(
    color: Colors.black,
    fontSize: 28,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: -0.28,
  );

  return baseTitleCarousel.copyWith(
    fontSize: isMobile ? null : 33.60,
    letterSpacing: isMobile ? null : -0.34,
  );
}

TextStyle _getBodyCarouselStyle(bool isMobile) {
  final baseBodyCarousel = TextStyle(
    color: lightColorScheme.onSurfaceVariant,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w300,
    height: 1.5,
    letterSpacing: 0.50,
  );

  return baseBodyCarousel.copyWith(
    fontSize: isMobile ? null : 22,
    height: isMobile ? null : 30 / 22,
    letterSpacing: isMobile ? null : 0.33,
  );
}

TextStyle _getBodyButtonStyle(bool isMobile) {
  const baseBodyButton = TextStyle(
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.10,
  );

  return baseBodyButton.copyWith(
    fontSize: isMobile ? null : 22,
    height: isMobile ? null : 20 / 22,
    letterSpacing: isMobile ? null : 0.33,
  );
}
