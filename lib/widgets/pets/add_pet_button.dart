import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class AddPetButton extends StatelessWidget {
  const AddPetButton({
    super.key,
    required this.foregroundColor,
    required this.backgroundColor,
    this.hasBorder = false,
    required this.action,
    required this.miniIcon,
    required this.miniButtonStyle,
    required this.width,
  });
  final Color foregroundColor, backgroundColor;
  final bool hasBorder;
  final VoidCallback action;
  final IconData miniIcon;
  final ButtonStyle miniButtonStyle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          Column(
            children: [
              hasBorder
                  ? DottedBorder(
                      dashPattern: [5, 5],
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 4,
                      padding: EdgeInsets.zero,
                      borderType: BorderType.Circle,
                      child: GestureDetector(
                        onTap: action,
                        child: CircleAvatar(
                          radius: Responsive.isTablet(context)
                              ? width + 4
                              : (width / 2).sp,
                          backgroundColor: backgroundColor,
                          foregroundColor: foregroundColor,
                          child: Icon(Icons.pets,
                              size: Responsive.isTablet(context)
                                  ? (width / 2) + 3.5
                                  : (width / 2).sp),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: action,
                      child: CircleAvatar(
                        radius: Responsive.isTablet(context)
                            ? width + 4
                            : (width / 2).sp,
                        backgroundColor: backgroundColor,
                        foregroundColor: foregroundColor,
                        child: Icon(Icons.pets,
                            size: Responsive.isTablet(context)
                                ? (width / 2) + 3.5
                                : (width / 2).sp),
                      ),
                    ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            heightFactor: 2.7,
            child: SizedBox(
              height: width / 2.6,
              width: width / 2.6,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: width / 5,
                onPressed: action,
                icon: Icon(miniIcon),
                style: miniButtonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}