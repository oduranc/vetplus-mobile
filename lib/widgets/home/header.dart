import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/theme/typography.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return Padding(
      padding: EdgeInsets.only(
          right: isTablet ? 37 : 24.sp, top: isTablet ? 8 : 16.sp),
      child: Row(
        children: [
          CircleAvatar(
            radius: (isTablet ? 66 : 55.sp) / 2,
          ),
          SizedBox(width: isTablet ? 6 : 6.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Juan Pérez',
                  style: getButtonBodyStyle(isTablet),
                ),
                SizedBox(height: isTablet ? 4 : 4.sp),
                Text(
                  'Dueño de mascota',
                  style: getSnackBarBodyStyle(isTablet),
                ),
              ],
            ),
          ),
          Wrap(
            children: [
              IconButton(
                iconSize: isTablet ? 30 : 25.sp,
                onPressed: () {},
                icon: const Icon(Icons.favorite_border_rounded),
              ),
              IconButton(
                iconSize: isTablet ? 30 : 25.sp,
                onPressed: () {},
                icon: const Icon(Icons.receipt_long_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
