import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({
    Key? key,
    required this.body,
    this.appBar,
    this.navBar,
    this.providedPadding,
    this.extendedBody = false,
  }) : super(key: key);
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? navBar;
  final EdgeInsetsGeometry? providedPadding;
  final bool extendedBody;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    EdgeInsetsGeometry padding = EdgeInsets.symmetric(
      horizontal: isTablet ? 37 : 24.sp,
    );

    if (providedPadding != null) {
      padding = providedPadding!;
    }

    return Scaffold(
      extendBodyBehindAppBar: extendedBody,
      appBar: appBar,
      bottomNavigationBar: navBar,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: padding,
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
