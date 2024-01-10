import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/date_utils.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class AppointmentObservationsScreen extends StatelessWidget {
  const AppointmentObservationsScreen({
    super.key,
    required this.appointment,
    this.names,
    this.surnames,
    required this.listRole,
  });

  final AppointmentDetails appointment;
  final String? names;
  final String? surnames;
  final String listRole;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appointmentDetails),
        centerTitle: true,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: buildChildren(context, isTablet).length,
        separator: Divider(height: isTablet ? 44 : 40.sp),
        itemBuilder: (context, index) =>
            buildChildren(context, isTablet)[index],
      ),
    );
  }

  List<Widget> buildChildren(BuildContext context, bool isTablet) {
    return [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  listRole == 'VETERINARIAN'
                      ? AppLocalizations.of(context)!.petOwner
                      : AppLocalizations.of(context)!.veterinarian,
                  style: getClinicTitleStyle(isTablet)),
              Text(
                '$names ${surnames ?? ''}',
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      if (appointment.observations!.suffering != null &&
          appointment.observations!.suffering!.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.diagnostics,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            for (var item in appointment.observations!.suffering!)
              Text(
                item,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black, height: 2),
              )
          ],
        ),
      if (appointment.observations!.treatment != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.treatment,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Text(
                appointment.observations!.treatment! == ''
                    ? 'N/A'
                    : appointment.observations!.treatment!,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black)),
          ],
        ),
      if (appointment.observations!.feed != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.feed,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Text(
                appointment.observations!.feed! == ''
                    ? 'N/A'
                    : appointment.observations!.feed!,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black)),
          ],
        ),
      if (appointment.observations!.deworming != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.deworming,
              style: getClinicTitleStyle(isTablet),
            ),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appointment.observations!.deworming!.product! == ''
                    ? 'N/A'
                    : appointment.observations!.deworming!.product!),
                Text(appointment.observations!.deworming!.date == null ||
                        appointment.observations!.deworming!.date! == ''
                    ? 'N/A'
                    : formatDateTime(
                        appointment.observations!.deworming!.date!)),
              ],
            ),
          ],
        ),
      if (appointment.observations!.vaccines != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.vaccines,
              style: getClinicTitleStyle(isTablet),
            ),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.date,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.vaccines!.date == null ||
                        appointment.observations!.vaccines!.date! == ''
                    ? 'N/A'
                    : formatDateTime(
                        appointment.observations!.vaccines!.date!)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.vaccineBrand,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.vaccines!.vaccineBrand! == ''
                    ? 'N/A'
                    : appointment.observations!.vaccines!.vaccineBrand!),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.vaccineBatch,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.vaccines!.vaccineBatch! == ''
                    ? 'N/A'
                    : appointment.observations!.vaccines!.vaccineBatch!),
              ],
            ),
          ],
        ),
      if (appointment.observations!.reproductiveTimeline != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.reproductiveTimeline,
              style: getClinicTitleStyle(isTablet),
            ),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.dateLastHeat,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.reproductiveTimeline!
                                .dateLastHeat ==
                            null ||
                        appointment.observations!.reproductiveTimeline!
                                .dateLastHeat ==
                            ''
                    ? 'N/A'
                    : formatDateTime(appointment
                        .observations!.reproductiveTimeline!.dateLastHeat!)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.dateLastBirth,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.reproductiveTimeline!
                                .dateLastBirth ==
                            null ||
                        appointment.observations!.reproductiveTimeline!
                                .dateLastBirth! ==
                            ''
                    ? 'N/A'
                    : formatDateTime(appointment
                        .observations!.reproductiveTimeline!.dateLastBirth!)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.reproductiveHistory,
                    style: const TextStyle()
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(appointment.observations!.reproductiveTimeline!
                                .reproductiveHistory ==
                            null ||
                        appointment.observations!.reproductiveTimeline!
                                .reproductiveHistory! ==
                            ''
                    ? 'N/A'
                    : appointment.observations!.reproductiveTimeline!
                        .reproductiveHistory!),
              ],
            ),
          ],
        ),
    ];
  }
}
