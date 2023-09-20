import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData icon;
  const DashboardCard({
    super.key,
    required this.child,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    return Container(
      margin: EdgeInsets.only(
        left: isTablet ? 0 : 10.sp,
        bottom: isTablet ? 40 : 30.sp,
        right: isTablet ? 0 : 10.sp,
      ),
      padding: EdgeInsets.all(isTablet ? 20 : 15.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66C4C4C4),
            blurRadius: 15,
            offset: Offset(0, 3),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: getSnackBarTitleStyle(isTablet).copyWith(
                    fontFamily: 'Roboto', height: 0, letterSpacing: 0.2),
              ),
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: isTablet ? 30 : 20.sp,
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
