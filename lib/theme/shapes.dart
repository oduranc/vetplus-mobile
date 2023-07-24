import 'package:flutter/material.dart';
import 'package:vetplus/theme/colors.dart';
import 'package:vetplus/theme/typography.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: lightColorScheme.primary,
    minimumSize: const Size(165, 0),
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: bodyButton,
  ),
);

final secondaryElevatedButton = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: lightColorScheme.onSurfaceVariant,
    backgroundColor: lightColorScheme.surfaceVariant,
    minimumSize: const Size(165, 0),
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: bodyButton,
  ),
);
