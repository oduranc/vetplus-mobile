import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({Key? key, required this.body, this.appBar})
      : super(key: key);
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 37 : 24.sp,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
