import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/themes/typography.dart';

class ClinicMainInfo extends StatefulWidget {
  const ClinicMainInfo({
    super.key,
    required this.isTablet,
    required this.clinic,
  });

  final bool isTablet;
  final ClinicModel clinic;

  @override
  State<ClinicMainInfo> createState() => _ClinicMainInfoState();
}

class _ClinicMainInfoState extends State<ClinicMainInfo> {
  bool _showSchedule = false;
  bool _showNonWorkingDays = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: widget.isTablet ? 13 : 5.sp,
      children: [
        SizedBox(
            width: double.infinity,
            child: Text(widget.clinic.name,
                style: getClinicNameTextStyle(widget.isTablet))),
        Text(
          ' ⭐ ${widget.clinic.clinicRating} • ${widget.clinic.clinicSummaryScore!.totalUsers} ${AppLocalizations.of(context)!.ratings}',
          style: getClinicDetailsTextStyle(widget.isTablet),
        ),
        SizedBox(
          width: double.infinity,
          child: Text(
            widget.clinic.address,
            style: getClinicDetailsTextStyle(widget.isTablet),
          ),
        ),
        if (widget.clinic.schedule != null)
          GestureDetector(
            onTap: () {
              setState(() {
                _showSchedule = !_showSchedule;
              });
            },
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.clinicSchedule,
                  style: getClinicDetailsTextStyle(widget.isTablet)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(
                  _showSchedule
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: Color(0xFF666666),
                ),
              ],
            ),
          ),
        if (widget.clinic.schedule != null && _showSchedule)
          ...widget.clinic.schedule!.workingDays.map(
            (e) => SizedBox(
              width: double.infinity,
              child: Text(
                '  • ${e.day}: ${e.startTime} - ${e.endTime}',
                style: getClinicDetailsTextStyle(widget.isTablet),
              ),
            ),
          ),
        if (widget.clinic.schedule != null)
          GestureDetector(
            onTap: () {
              setState(() {
                _showNonWorkingDays = !_showNonWorkingDays;
              });
            },
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.nonWorkingDays,
                  style: getClinicDetailsTextStyle(widget.isTablet)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(
                  _showNonWorkingDays
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: Color(0xFF666666),
                ),
              ],
            ),
          ),
        if (widget.clinic.schedule != null && _showNonWorkingDays)
          ...widget.clinic.schedule!.nonWorkingDays.map(
            (e) => Text(
              '  • ${e.toString()}',
              style: getClinicDetailsTextStyle(widget.isTablet),
            ),
          ),
      ],
    );
  }
}
