import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/help_dto.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';

class HelpIndexScreen extends StatelessWidget {
  const HelpIndexScreen({super.key, required this.helpItem});

  final HelpDTO helpItem;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: isTablet ? 37 : 24.sp,
          right: isTablet ? 37 : 24.sp,
          bottom: isTablet ? 60 : 35.sp,
          top: isTablet ? 37 : 24.sp,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(helpItem.title, style: getCarouselTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 37 : 24.sp),
            Expanded(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style:
                      getFieldTextStyle(isTablet).copyWith(color: Colors.black),
                  child: helpItem.widget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
