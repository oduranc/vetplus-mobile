import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/theme/typography.dart';

class VetListItem extends StatelessWidget {
  const VetListItem({
    super.key,
    required this.isTablet,
  });

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isTablet ? 245 : 150.sp,
      width: isTablet ? 418 : 245.sp,
      child: Card(
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.network(
                    'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
                    height: isTablet ? 140 : 83.sp,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 8.sp,
                    top: isTablet ? 11 : 6.sp,
                    child: Container(
                      width: isTablet ? 63 : 50.sp,
                      height: isTablet ? 25 : 21.sp,
                      padding: const EdgeInsets.only(left: 4, right: 5),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFFFC529),
                            size: isTablet ? 18 : 15.sp,
                          ),
                          SizedBox(width: isTablet ? 2 : 2.sp),
                          Text(
                            '4.5',
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: isTablet ? 16 : 13.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1,
                              letterSpacing: 0.16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: isTablet
                  ? const EdgeInsets.symmetric(vertical: 18, horizontal: 16)
                  : EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
              child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                spacing: Responsive.isTablet(context) ? 6 : 2.sp,
                children: [
                  Text(
                    'Centro veterinario',
                    style: getSnackBarTitleStyle(Responsive.isTablet(context)),
                  ),
                  Text(
                    'Evaristo Morales, Distrito Nacional',
                    style: getSnackBarBodyStyle(Responsive.isTablet(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
