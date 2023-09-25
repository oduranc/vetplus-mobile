import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/themes/typography.dart';

class ClinicServicesInfo extends StatelessWidget {
  const ClinicServicesInfo(
      {super.key, required this.isTablet, required this.services});

  final bool isTablet;
  final List<Object?>? services;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: isTablet ? 29 : 22.sp,
      children: [
        Text(
          AppLocalizations.of(context)!.services,
          style: getClinicTitleStyle(isTablet),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: isTablet ? 40 : 40.sp,
          ),
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: services!.length,
          itemBuilder: (context, index) {
            final alignment = index % 2 == 0 ? TextAlign.left : TextAlign.right;
            return Text(
              '• ${services!.elementAt(index).toString()}',
              style: getClinicDetailsTextStyle(isTablet)
                  .copyWith(color: Colors.black),
              textAlign: alignment,
            );
          },
        ),
      ],
    );
  }
}
