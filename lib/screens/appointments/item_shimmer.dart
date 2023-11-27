import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';

class ItemShimmer extends StatelessWidget {
  const ItemShimmer({
    super.key,
    required this.isTablet,
  });

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SeparatedListView(
          isTablet: isTablet,
          itemCount: 1,
          separator: const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                backgroundColor: Colors.black,
                foregroundColor: Colors.black,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.black,
                    height: isTablet ? 16 : 14.sp,
                    width: isTablet ? 100 : 100.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: isTablet ? 12 : 10.sp,
                        bottom: isTablet ? 9 : 7.sp),
                    child: Container(
                      color: Colors.black,
                      height: isTablet ? 14 : 12.sp,
                      width: isTablet ? 100 : 200.sp,
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    height: isTablet ? 14 : 12.sp,
                    width: isTablet ? 100 : 150.sp,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
