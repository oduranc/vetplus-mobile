import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/theme/typography.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.iconData,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.textColor,
    this.hasBorder,
  });
  final Widget iconData;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final bool? hasBorder;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: textTheme(isTablet).labelMedium,
        padding: EdgeInsets.all(isTablet ? 18 : 15),
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: hasBorder == true
              ? BorderSide(color: Theme.of(context).colorScheme.outline)
              : BorderSide.none,
        ),
      ),
      child: Stack(
        children: <Widget>[
          iconData,
          Center(child: Text(text)),
        ],
      ),
    );
  }
}
