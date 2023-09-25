import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/employee_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/clinics/shimmer_clinic_profile.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/widgets/clinics/clinic_comments_info.dart';
import 'package:vetplus/widgets/clinics/clinic_main_info.dart';
import 'package:vetplus/widgets/clinics/clinic_map_info.dart';
import 'package:vetplus/widgets/clinics/clinic_profile_appbar.dart';
import 'package:vetplus/widgets/clinics/clinic_services_info.dart';
import 'package:vetplus/widgets/clinics/clinic_veterinarians_info.dart';
import 'package:vetplus/widgets/clinics/schedule_button_footer.dart';

class ClinicProfile extends StatelessWidget {
  const ClinicProfile({super.key});

  static const route = 'clinic-route';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String clinicId = arguments['id'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ClinicProfileAppBar(),
      body: FutureBuilder(
        future: Future.wait([
          ClinicService.getClinicById(clinicId),
          ClinicService.getClinicEmployees(clinicId),
          ClinicService.getClinicComments(clinicId)
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerClinicProfile(isTablet: isTablet);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.serverFailedBody),
            );
          } else if (snapshot.data![0].hasException ||
              snapshot.data![1].hasException) {
            return Center(
              child: Text(AppLocalizations.of(context)!.internetConnection),
            );
          } else {
            final clinicJson = snapshot.data![0];
            ClinicModel clinic =
                ClinicModel.fromJson(clinicJson.data!['getClinicById']);

            final employeesJson = snapshot.data![1];
            List<EmployeeModel> employees =
                EmployeeList.fromJson(employeesJson.data!).list;

            // final commentsJson = snapshot.data![2];
            // List<CommentModel> comments =
            //     CommentList.fromJson(commentsJson.data!).list;

            final sectionsToShow = [
              ClinicMainInfo(isTablet: isTablet, clinic: clinic),
              if (employees.isNotEmpty)
                ClinicVeterinariansInfo(
                    isTablet: isTablet, employees: employees),
              ClinicServicesInfo(
                isTablet: isTablet,
                services: clinic.services,
              ),
              if (clinic.googleMapsUrl != null)
                ClinicMapInfo(
                  isTablet: isTablet,
                  mapsUrl: clinic.googleMapsUrl,
                ),
              ClinicCommentsInfo(isTablet: isTablet),
            ];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          clinic.image ??
                              'https://preyash2047.github.io/assets/img/no-preview-available.png?h=824917b166935ea4772542bec6e8f636',
                          fit: BoxFit.cover,
                          height: isTablet ? 296 : 246.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 37 : 24.sp,
                            vertical: isTablet ? 34 : 20.sp,
                          ),
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(height: isTablet ? 96 : 40.sp);
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sectionsToShow.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) =>
                                sectionsToShow[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ScheduleButtonFooter(isTablet: isTablet),
              ],
            );
          }
        },
      ),
    );
  }
}
