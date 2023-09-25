import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerClinicProfile extends StatelessWidget {
  const ShimmerClinicProfile({
    super.key,
    required this.isTablet,
  });

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: 250,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 37 : 24.sp,
              vertical: isTablet ? 34 : 20.sp,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Wrap(
                direction: Axis.vertical,
                spacing: isTablet ? 20 : 15.sp,
                children: [
                  Container(
                    color: Colors.black,
                    width: isTablet ? 250 : 250.sp,
                    height: isTablet ? 35 : 30,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                  SizedBox(height: isTablet ? 15 : 10),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 140 : 140.sp,
                    height: isTablet ? 25 : 20,
                  ),
                  Wrap(
                    spacing: isTablet ? 15 : 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(radius: isTablet ? 32.5 : 32.5.sp),
                      Container(
                        color: Colors.black,
                        width: isTablet ? 150 : 150.sp,
                        height: isTablet ? 19 : 14,
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 15 : 10),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 140 : 140.sp,
                    height: isTablet ? 25 : 20,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                  Container(
                    color: Colors.black,
                    width: isTablet ? 100 : 100.sp,
                    height: isTablet ? 17 : 12,
                  ),
                ],
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: 200.sp,
            ),
          ),
        ],
      ),
    );
  }
}
