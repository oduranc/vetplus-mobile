import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/home/vet_list_item.dart';

class VetSection extends StatelessWidget {
  const VetSection({
    Key? key,
    required this.itemCount,
    required this.sectionTitle,
  }) : super(key: key);

  final int itemCount;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(sectionTitle, style: getSectionTitle(isTablet)),
        SizedBox(height: isTablet ? 14 : 14.sp),
        SingleChildScrollView(
          padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: isTablet ? 30 : 20.sp,
            children: [
              VetListItem(isTablet: isTablet),
              VetListItem(isTablet: isTablet),
              VetListItem(isTablet: isTablet),
              VetListItem(isTablet: isTablet),
            ],
          ),
        ),
      ],
    );
  }
}
