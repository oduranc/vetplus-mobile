import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
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
    final PetModel pet = arguments['pet'];
    final String age = arguments['age'];
    final String breedName = arguments['breedName'];

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        toolbarHeight: isTablet ? 78 + 23 : (65 + 23).sp,
        titleSpacing: 0,
        actions: [
          _buildAppBarActions(isTablet, context),
        ],
        title: DashboardAppBarTitle(
            pet: pet, isTablet: isTablet, breedName: breedName, age: age),
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

  Padding _buildAppBarActions(bool isTablet, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      child: isTablet
          ? Row(
              children: [
                IconButton(
                  onPressed: () {},
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
                          onPressed: () {},
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
}
