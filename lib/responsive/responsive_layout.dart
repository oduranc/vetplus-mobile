import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({Key? key, required this.mobile, required this.tablet})
      : super(key: key);
  final Widget mobile;
  final Widget tablet;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width >= 850) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
