import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/pet_profile.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/pets/dashboard_app_bar_title.dart';
import 'package:vetplus/widgets/pets/next_appointments_widget.dart';
import 'package:vetplus/widgets/pets/weight_widget.dart';

class PetDashboard extends StatelessWidget {
  const PetDashboard({super.key});

  static const route = 'pet-dashboard';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final PetModel pet = Provider.of<PetsProvider>(context)
        .pets!
        .where((pet) => pet.id == arguments['id'])
        .first;
    final String age = getFormattedAge(pet, context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        toolbarHeight: isTablet ? 78 + 23 : (65 + 23).sp,
        titleSpacing: 0,
        actions: [
          _buildAppBarActions(isTablet, context, arguments),
        ],
        title: FutureBuilder(
          future: getBreedName(pet, context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: CircleAvatar(
                      radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.black,
                          width: 100,
                          height: 14,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.black,
                          width: 100,
                          height: 12,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          color: Colors.black,
                          width: 100,
                          height: 12,
                        ),
                      )
                    ],
                  )
                ],
              );
            } else {
              return DashboardAppBarTitle(
                pet: pet,
                isTablet: isTablet,
                breedName: snapshot.data!,
                age: age,
              );
            }
          },
        ),
      ),
      body: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: isTablet ? 14 : 14.sp,
        children: [
          Text(
            AppLocalizations.of(context)!.wellnessPanel,
            style: getSectionTitle(isTablet).copyWith(fontFamily: 'Roboto'),
          ),
          _buildWellnessWidgets(isTablet),
          Text(
            AppLocalizations.of(context)!.careHistory,
            style: getSectionTitle(isTablet).copyWith(fontFamily: 'Roboto'),
          ),
          _buildWellnessWidgets(isTablet),
        ],
      ),
    );
  }

  Padding _buildAppBarActions(
      bool isTablet, BuildContext context, Map arguments) {
    return Padding(
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      child: isTablet
          ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    _sendToPetProfile(context, arguments);
                  },
                  icon: const Icon(Icons.settings_outlined),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send_outlined),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.insert_drive_file_outlined),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ],
            )
          : IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ButtonsBottomSheet(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                Theme.of(context).colorScheme.primary,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            _sendToPetProfile(context, arguments);
                          },
                          child:
                              Text(AppLocalizations.of(context)!.viewProfile),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6EC6EB),
                          ),
                          onPressed: () {},
                          child: Text(AppLocalizations.of(context)!.sendToVet),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child:
                              Text(AppLocalizations.of(context)!.createReport),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_horiz),
            ),
    );
  }

  SizedBox _buildWellnessWidgets(bool isTablet) {
    return SizedBox(
      height: isTablet ? 410 : null,
      child: Flex(
        direction: isTablet ? Axis.horizontal : Axis.vertical,
        children: [
          isTablet
              ? Expanded(child: WeightWidget(isTablet: isTablet))
              : WeightWidget(isTablet: isTablet),
          SizedBox(width: isTablet ? 40 : 0, height: isTablet ? 0 : 20),
          isTablet
              ? Expanded(child: NextAppointmentsWidget(isTablet: isTablet))
              : NextAppointmentsWidget(isTablet: isTablet),
        ],
      ),
    );
  }

  void _sendToPetProfile(BuildContext context, Map arguments) {
    Navigator.pushNamed(context, PetProfile.route, arguments: arguments);
  }
}
