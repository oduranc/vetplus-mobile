import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/appointments_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/appointment_utils.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class AppointmentsHistoryScreen extends StatelessWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appointmentsHistory),
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: AppointmentsService.getAppointments(
            Provider.of<UserProvider>(context, listen: false).accessToken!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: SeparatedListView(
                  isTablet: isTablet,
                  itemCount: 1,
                  separator: const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.black,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.black,
                            height: isTablet ? 16 : 14.sp,
                            width: isTablet ? 100 : 100.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: isTablet ? 12 : 10.sp,
                                bottom: isTablet ? 9 : 7.sp),
                            child: Container(
                              color: Colors.black,
                              height: isTablet ? 14 : 12.sp,
                              width: isTablet ? 100 : 200.sp,
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            height: isTablet ? 14 : 12.sp,
                            width: isTablet ? 100 : 150.sp,
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.internetConnection);
          } else {
            List<AppointmentDetails> appointments = [];
            if (snapshot.data!.data != null) {
              appointments = AppointmentList.fromJson(
                      snapshot.data!.data!, 'getAppointmentDetailAllRoles')
                  .getAppointmentDetails;
            }
            return SeparatedListView(
                isTablet: isTablet,
                itemCount: appointments.length,
                separator: const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: appointments[index].state !=
                            AppointmentState.FINISHED.name
                        ? null
                        : () {},
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                      backgroundColor: Color(0xFFDCDCDD),
                      foregroundColor: Color(0xFFFBFBFB),
                      backgroundImage: appointments[index].pet.image != null
                          ? NetworkImage(appointments[index].pet.image!)
                          : null,
                      child: appointments[index].pet.image != null
                          ? null
                          : Icon(Icons.pets,
                              size: Responsive.isTablet(context) ? 36 : 30.sp),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appointments[index].pet.name,
                          style: getSnackBarTitleStyle(isTablet),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: isTablet ? 6 : 4.sp,
                              bottom: isTablet ? 3 : 1.sp),
                          child: Text(
                            appointments[index].clinic.name,
                            style: getSnackBarBodyStyle(isTablet),
                          ),
                        ),
                        Text(
                          '${appointments[index].veterinarian.names} ${appointments[index].veterinarian.surnames ?? ''}',
                          style: getSnackBarBodyStyle(isTablet),
                        )
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appointments[index].state,
                          style: getSnackBarTitleStyle(isTablet).copyWith(
                              color: mapStateToColor(AppointmentState.values
                                  .where((element) =>
                                      element.name == appointments[index].state)
                                  .first)),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(appointments[index].startAt)),
                          style: getSnackBarBodyStyle(isTablet),
                        ),
                        Text(
                          DateFormat('h:mm a').format(
                              DateTime.parse(appointments[index].startAt)),
                          style: getSnackBarBodyStyle(isTablet),
                        )
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
