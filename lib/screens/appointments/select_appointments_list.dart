import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/appointments/appointments_history_screen.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class SelectAppointmentsList extends StatelessWidget {
  const SelectAppointmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final typesList = [
      AppointmentsType(
        name: AppLocalizations.of(context)!.petOwner,
        description: AppLocalizations.of(context)!.myAppointments,
        listRole: 'PET_OWNER',
        icon: Icons.pets_rounded,
      ),
      AppointmentsType(
        name: AppLocalizations.of(context)!.veterinarian,
        description: AppLocalizations.of(context)!.clientsAppointments,
        listRole: 'VETERINARIAN',
        icon: Icons.vaccines_rounded,
      ),
    ];

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appointmentsHistory),
        centerTitle: false,
      ),
      body: SeparatedListView(
        isTablet: isTablet,
        itemCount: 2,
        separator: const Divider(),
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AppointmentsHistoryScreen(
                    listRole: typesList[index].listRole),
              ),
            );
          },
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFF2F2F2),
            foregroundColor: const Color(0xFF8B8B8B),
            radius: isTablet ? 30 : 25.sp,
            child: Icon(typesList[index].icon),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                typesList[index].name,
                style: getBottomSheetTitleStyle(isTablet),
              ),
              SizedBox(height: isTablet ? 4 : 4.sp),
              Text(
                typesList[index].description,
                style: getCarouselBodyStyle(isTablet)
                    .copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.onInverseSurface,
            size: isTablet ? 35 : 25.sp,
          ),
        ),
      ),
    );
  }
}

class AppointmentsType {
  final String name;
  final String description;
  final String listRole;
  final IconData icon;

  AppointmentsType(
      {required this.name,
      required this.description,
      required this.listRole,
      required this.icon});
}
