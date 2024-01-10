import 'package:davinci/core/davinci_capture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/pet_profile.dart';
import 'package:vetplus/services/appointments_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/pets/dashboard_app_bar_title.dart';
import 'package:vetplus/widgets/pets/latest_appointment_widget.dart';
import 'package:vetplus/widgets/pets/next_appointments_widget.dart';

class PetDashboard extends StatefulWidget {
  const PetDashboard({super.key});

  static const route = 'pet-dashboard';

  @override
  State<PetDashboard> createState() => _PetDashboardState();
}

class _PetDashboardState extends State<PetDashboard> {
  String _breedName = '';

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final PetModel pet = Provider.of<PetsProvider>(context)
        .pets!
        .where((pet) => pet.id == arguments['id'])
        .first;
    final bool isNotFromScanner = arguments['isNotFromScanner'] ?? true;
    final String age = getFormattedAge(pet, context);

    return SkeletonScreen(
      providedPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 37 : 24.sp,
        vertical: isTablet ? 60 : 35.sp,
      ),
      appBar: AppBar(
        toolbarHeight: isTablet ? 78 + 23 : (65 + 23).sp,
        titleSpacing: 0,
        actions: isNotFromScanner
            ? [
                _buildAppBarActions(isTablet, context, arguments, pet),
              ]
            : null,
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
            } else if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context)!.serverFailedBody),
              );
            } else {
              _breedName = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  _sendToPetProfile(
                      context, {...arguments, 'breed': _breedName});
                },
                child: DashboardAppBarTitle(
                  pet: pet,
                  isTablet: isTablet,
                  breedName: snapshot.data!,
                  age: age,
                ),
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
          _buildWellnessWidgets(isTablet, pet),
        ],
      ),
    );
  }

  Padding _buildAppBarActions(
      bool isTablet, BuildContext context, Map arguments, PetModel pet) {
    return Padding(
      padding: EdgeInsets.only(right: isTablet ? 37 : 24.sp),
      child: isTablet
          ? Row(
              children: [
                IconButton(
                  onPressed: () {
                    _sendToPetProfile(
                        context, {...arguments, 'breed': _breedName});
                  },
                  icon: const Icon(Icons.settings_outlined),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                IconButton(
                  onPressed: () {
                    _sharePetProfile(pet, context, isTablet);
                  },
                  icon: const Icon(Icons.send_outlined),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.insert_drive_file_outlined),
                //   color: Theme.of(context).colorScheme.onInverseSurface,
                // ),
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
                            _sendToPetProfile(
                                context, {...arguments, 'breed': _breedName});
                          },
                          child:
                              Text(AppLocalizations.of(context)!.viewProfile),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6EC6EB),
                          ),
                          onPressed: () {
                            _sharePetProfile(pet, context, isTablet);
                          },
                          child: Text(AppLocalizations.of(context)!.sendToVet),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child:
                        //       Text(AppLocalizations.of(context)!.createReport),
                        // ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_horiz),
            ),
    );
  }

  Future<void> _sharePetProfile(
      PetModel pet, BuildContext context, bool isTablet) async {
    try {
      // Generate QR
      final qr = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: (View.of(context).physicalSize /
                    View.of(context).devicePixelRatio)
                .height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.sharePetQrSubject(pet.name),
                    style: getClinicNameTextStyle(isTablet)),
                QrImageView(
                  data: pet.id,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
          ),
        ],
      );

      // Generate image
      final qrImage = await DavinciCapture.offStage(
        qr,
        context: context,
        fileName: pet.name,
        openFilePreview: false,
        returnImageUint8List: true,
      );

      if (qrImage != null) {
        final xFile = XFile.fromData(
          qrImage,
          name: '${pet.name}_profile.png',
          mimeType: 'image/png',
        );

        // Share image
        Share.shareXFiles(
          [xFile],
          // ignore: use_build_context_synchronously
          subject: AppLocalizations.of(context)!.sharePetQrSubject(pet.name),
          // ignore: use_build_context_synchronously
          text: AppLocalizations.of(context)!.sharePetQrBody(pet.name),
        );
      } else {}
    } catch (e) {}
  }

  void _sendToPetProfile(BuildContext context, Map arguments) {
    Navigator.pushNamed(context, PetProfile.route, arguments: arguments);
  }

  Widget _buildWellnessWidgets(bool isTablet, PetModel pet) {
    return FutureBuilder(
      future: AppointmentsService.getPetAppointments(
          Provider.of<UserProvider>(context, listen: false).accessToken!,
          pet.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        List<AppointmentDetails>? appointments = [];
        AppointmentDetails? latestAppointment;
        if (snapshot.data!.data != null) {
          appointments = AppointmentList.fromJson(
                  snapshot.data!.data!, 'getAppointmentPerPet')
              .getAppointmentDetails;
        }
        if (appointments.isNotEmpty) {
          appointments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          latestAppointment =
              appointments.where((element) => element.state == 'FINISHED').last;
        }
        return SizedBox(
          height: isTablet ? 410 : null,
          child: Flex(
            direction: isTablet ? Axis.horizontal : Axis.vertical,
            children: [
              if (latestAppointment != null)
                isTablet
                    ? Expanded(
                        child: LatestAppointmentWidget(
                            isTablet: isTablet,
                            latestAppointment: latestAppointment))
                    : LatestAppointmentWidget(
                        isTablet: isTablet,
                        latestAppointment: latestAppointment),
              SizedBox(width: isTablet ? 40 : 0, height: isTablet ? 0 : 20),
              isTablet
                  ? Expanded(
                      child: NextAppointmentsWidget(
                          isTablet: isTablet, appointments: appointments))
                  : NextAppointmentsWidget(
                      isTablet: isTablet, appointments: appointments),
            ],
          ),
        );
      },
    );
  }
}
