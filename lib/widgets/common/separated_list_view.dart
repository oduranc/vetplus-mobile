import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeparatedListView extends StatelessWidget {
  const SeparatedListView({
    super.key,
    required this.isTablet,
    required this.itemBuilder,
    required this.itemCount,
    required this.separator,
  });

  final bool isTablet;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: isTablet ? 37 : 24.sp),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) {
        return separator;
      },
    );
  }
}
