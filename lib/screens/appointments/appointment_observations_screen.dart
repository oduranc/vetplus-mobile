import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class AppointmentObservationsScreen extends StatelessWidget {
  const AppointmentObservationsScreen({super.key, required this.appointment});

  final AppointmentDetails appointment;

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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.veterinarian,
              style: getClinicTitleStyle(isTablet)),
          Text(
            '${appointment.veterinarian.names} ${appointment.veterinarian.surnames ?? ''}',
            style: getClinicDetailsTextStyle(isTablet)
                .copyWith(color: Colors.black),
          ),
        ],
      ),
      if (appointment.observations.suffering != null &&
          appointment.observations.suffering!.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.diagnostics,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            for (var item in appointment.observations.suffering!)
              Text(
                item,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black, height: 2),
              )
          ],
        ),
      if (appointment.observations.treatment != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.treatment,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Text(appointment.observations.treatment!,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black)),
          ],
        ),
      if (appointment.observations.feed != null)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context)!.feed,
                style: getClinicTitleStyle(isTablet)),
            SizedBox(height: isTablet ? 22 : 18.sp),
            Text(appointment.observations.feed!,
                style: getClinicDetailsTextStyle(isTablet)
                    .copyWith(color: Colors.black)),
          ],
        ),
    ];
  }
}
