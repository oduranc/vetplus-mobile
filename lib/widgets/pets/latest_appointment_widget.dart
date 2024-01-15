import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/utils/date_utils.dart';
import 'package:vetplus/widgets/pets/dashboard_card.dart';

class LatestAppointmentWidget extends StatelessWidget {
  const LatestAppointmentWidget({
    super.key,
    required this.isTablet,
    required this.latestAppointment,
  });

  final bool isTablet;
  final AppointmentDetails? latestAppointment;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: AppLocalizations.of(context)!.latestAppointment,
      icon: Icons.vaccines_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12.sp),
          Text(
            AppLocalizations.of(context)!.diagnostics,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: isTablet ? 16 : 14.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.sp),
          for (var item in latestAppointment!.observations!.suffering!)
            Text(
              item,
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 16 : 14.sp,
                fontFamily: 'Inter',
              ),
            ),
          SizedBox(height: 12.sp),
          Text(
            AppLocalizations.of(context)!.treatment,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: isTablet ? 16 : 14.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
              latestAppointment!.observations!.treatment! == ''
                  ? 'N/A'
                  : latestAppointment!.observations!.treatment!,
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 16 : 14.sp,
                fontFamily: 'Inter',
              )),
          SizedBox(height: 12.sp),
          Text(
            AppLocalizations.of(context)!.feed,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: isTablet ? 16 : 14.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
              latestAppointment!.observations!.feed! == ''
                  ? 'N/A'
                  : latestAppointment!.observations!.feed!,
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 16 : 14.sp,
                fontFamily: 'Inter',
              )),
          SizedBox(height: 12.sp),
          Text(
            AppLocalizations.of(context)!.vaccines,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: isTablet ? 16 : 14.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.date,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                latestAppointment!.observations!.vaccines!.date == null ||
                        latestAppointment!.observations!.vaccines!.date! == ''
                    ? 'N/A'
                    : formatDateTime(
                        latestAppointment!.observations!.vaccines!.date!),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.vaccineBrand,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                latestAppointment!.observations!.vaccines!.vaccineBrand! == ''
                    ? 'N/A'
                    : latestAppointment!.observations!.vaccines!.vaccineBrand!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.vaccineBatch,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                latestAppointment!.observations!.vaccines!.vaccineBatch! == ''
                    ? 'N/A'
                    : latestAppointment!.observations!.vaccines!.vaccineBatch!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? 16 : 14.sp,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
