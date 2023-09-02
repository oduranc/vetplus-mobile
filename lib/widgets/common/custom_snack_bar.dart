import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title, body;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    return SnackBar(
      backgroundColor: const Color(0xFFFBFBFB),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: isTablet ? 37 : 24.sp,
        right: isTablet ? 37 : 24.sp,
        bottom: 20.sp,
      ),
      content: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            radius: isTablet ? 33.60 : 25.sp,
            child: Icon(icon, size: isTablet ? 33.60 : 25.sp),
          ),
          SizedBox(width: isTablet ? 22 : 14.sp),
          Expanded(
            child: Wrap(
              runSpacing: 4.sp,
              children: <Widget>[
                Text(
                  title,
                  style: getSnackBarTitleStyle(isTablet),
                ),
                Text(
                  body,
                  softWrap: true,
                  style: getSnackBarBodyStyle(isTablet),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
