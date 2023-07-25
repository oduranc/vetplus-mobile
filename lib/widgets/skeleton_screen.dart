import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({Key? key, required this.body}) : super(key: key);
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 15 : 35,
              vertical: 15,
            ),
            child: body,
          ),
        ),
      ),
    );
  }
}
