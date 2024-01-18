import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql/src/core/query_result.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/comment_model.dart';
import 'package:vetplus/models/employee_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
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
    final UserModel? user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ClinicProfileAppBar(id: clinicId),
      body: FutureBuilder(
        future: _fetchClinicData(clinicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerClinicProfile(isTablet: isTablet);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(
                AppLocalizations.of(context)!.serverFailedBody);
          } else if (snapshot.data![0].hasException) {
            return _buildErrorWidget(
                AppLocalizations.of(context)!.internetConnection);
          } else {
            ClinicModel clinic =
                ClinicModel.fromJson(snapshot.data![0].data!['getClinicById']);

            List<EmployeeModel>? employees = [];
            if (snapshot.data![1].data != null) {
              employees = EmployeeList.fromJson(snapshot.data![1].data!)
                  .list
                  .where((element) => element.status != false)
                  .toList();
            }

            List<CommentModel>? comments = [];
            if (snapshot.data![2].data != null) {
              comments = CommentList.fromJson(snapshot.data![2].data!).list;
              comments.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            }

            final sectionsToShow =
                _buildSections(isTablet, clinic, employees, comments, clinicId);
            return _buildClinicProfileContent(
                clinic, isTablet, sectionsToShow, user, employees);
          }
        },
      ),
    );
  }

  List<Widget> _buildSections(
      bool isTablet,
      ClinicModel clinic,
      List<EmployeeModel> employees,
      List<CommentModel> comments,
      String clinicId) {
    final googleMapsRegex = RegExp(r'@([0-9.-]+),([0-9.-]+)');
    print(clinic.googleMapsUrl);
    print(clinic.services);
    return [
      ClinicMainInfo(isTablet: isTablet, clinic: clinic),
      if (employees.isNotEmpty)
        ClinicVeterinariansInfo(isTablet: isTablet, employees: employees),
      if (clinic.services != null)
        ClinicServicesInfo(
          isTablet: isTablet,
          services: clinic.services,
        ),
      if (clinic.googleMapsUrl != null &&
          googleMapsRegex.hasMatch(clinic.googleMapsUrl!))
        ClinicMapInfo(
          isTablet: isTablet,
          mapsUrl: clinic.googleMapsUrl,
        ),
      ClinicCommentsInfo(isTablet: isTablet, comments: comments, id: clinicId),
    ];
  }

  Future<List<QueryResult<Object?>>> _fetchClinicData(String clinicId) {
    return Future.wait([
      ClinicService.getClinicById(clinicId),
      ClinicService.getClinicEmployees(clinicId),
      ClinicService.getClinicComments(clinicId)
    ]);
  }

  Column _buildClinicProfileContent(
      ClinicModel clinic,
      bool isTablet,
      List<Widget> sectionsToShow,
      UserModel? user,
      List<EmployeeModel>? employees) {
    print('IMAGEN: ${clinic.image}');
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
                  child: _buildSectionsListView(isTablet, sectionsToShow),
                ),
              ],
            ),
          ),
        ),
        if (user != null &&
            clinic.services != null &&
            clinic.services!.isNotEmpty)
          ScheduleButtonFooter(
            isTablet: isTablet,
            clinic: clinic,
            user: user,
          ),
      ],
    );
  }

  ListView _buildSectionsListView(bool isTablet, List<Widget> sectionsToShow) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(height: isTablet ? 96 : 40.sp);
      },
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sectionsToShow.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => sectionsToShow[index],
    );
  }

  Center _buildErrorWidget(String message) {
    return Center(child: Text(message));
  }
}
