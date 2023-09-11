import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    super.key,
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
    this.actions,
  });
  final String title, body;
  final Color color;
  final IconData icon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return AlertDialog(
      actions: actions,
      title: Text(title,
          style: getBottomSheetTitleStyle(isTablet),
          textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            const Divider(),
            Icon(
              icon,
              color: color,
              size: isTablet ? 50 : 40.sp,
            ),
            SizedBox(height: isTablet ? 30 : 11.sp),
            Text(body,
                style: getBottomSheetBodyStyle(isTablet),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
