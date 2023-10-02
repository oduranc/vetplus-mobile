import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/form_template.dart';

class LongBottomSheet extends StatelessWidget {
  const LongBottomSheet({
    super.key,
    required this.title,
    required this.buttonChild,
    required this.onSubmit,
    required this.children,
    this.formRunSpacing,
    this.btnActive = false,
    this.heightFactor = 0.9,
    this.footer,
  });
  final String title;
  final Widget buttonChild;
  final VoidCallback onSubmit;
  final List<Widget> children;
  final double? formRunSpacing;
  final bool btnActive;
  final double heightFactor;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isTablet ? 37 : 24.sp),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        iconSize: isTablet ? 26 : 20.sp,
                      ),
                      Center(
                        child: Text(
                          title,
                          style: getBottomSheetTitleStyle(isTablet),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                FormTemplate(
                  onSubmit: onSubmit,
                  buttonChild: buttonChild,
                  formRunSpacing: formRunSpacing,
                  btnActive: btnActive,
                  padding: EdgeInsets.only(
                    top: isTablet ? 43 : 30.sp,
                    left: isTablet ? 37 : 24.sp,
                    right: isTablet ? 37 : 24.sp,
                    bottom: isTablet ? 37 : 24.sp,
                  ),
                  children: children,
                ),
                if (footer != null)
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 37 : 24.sp),
                    child: footer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
