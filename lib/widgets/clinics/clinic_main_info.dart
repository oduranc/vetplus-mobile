import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/themes/typography.dart';

class ClinicMainInfo extends StatelessWidget {
  const ClinicMainInfo({
    super.key,
    required this.isTablet,
    required this.clinic,
  });

  final bool isTablet;
  final ClinicModel clinic;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: isTablet ? 13 : 5.sp,
      children: [
        SizedBox(
            width: double.infinity,
            child: Text(clinic.name, style: getClinicNameTextStyle(isTablet))),
        Text(
          ' ⭐ ${clinic.clinicRating} • ${clinic.clinicSummaryScore!.totalUsers} ${AppLocalizations.of(context)!.ratings}',
          style: getClinicDetailsTextStyle(isTablet),
        ),
        Text(
          clinic.address,
          style: getClinicDetailsTextStyle(isTablet),
        ),
        if (clinic.schedule != null)
          SizedBox(
            width: double.infinity,
            child: Text(
              AppLocalizations.of(context)!.nonWorkingDays,
              style: getClinicDetailsTextStyle(isTablet),
            ),
          ),
        if (clinic.schedule != null)
          ...clinic.schedule!.nonWorkingDays.map(
            (e) => Text(
              '  • ${e.toString()}',
              style: getClinicDetailsTextStyle(isTablet),
            ),
          ),
      ],
    );
  }
}
