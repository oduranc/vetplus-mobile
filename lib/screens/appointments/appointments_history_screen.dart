import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/appointments_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/appointments/item_shimmer.dart';
import 'package:vetplus/services/appointments_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/appointment_utils.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class AppointmentsHistoryScreen extends StatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  State<AppointmentsHistoryScreen> createState() =>
      _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState extends State<AppointmentsHistoryScreen> {
  final List<String?> _filtersList = [];
  List<bool?>? _checkedList;

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
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 37 : 24.sp),
            child: _buildFilterIconButton(context, isTablet),
          )
        ],
      ),
      body: FutureBuilder(
        future: AppointmentsService.getAppointments(
            Provider.of<UserProvider>(context, listen: false).accessToken!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ItemShimmer(isTablet: isTablet);
          } else if (snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.internetConnection);
          } else {
            List<AppointmentDetails> appointments = [];
            if (snapshot.data!.data != null) {
              appointments = AppointmentList.fromJson(
                      snapshot.data!.data!, 'getAppointmentDetailAllRoles')
                  .getAppointmentDetails;
            }
            appointments.sort((a, b) => a.startAt.compareTo(b.startAt));

            if (_filtersList.isNotEmpty) {
              appointments = appointments.where((element) {
                return _filtersList.any((filter) {
                  return (element.state == 'PENDING'
                          ? element.appointmentStatus ?? element.state
                          : element.state)
                      .contains(filter!);
                });
              }).toList();
            }

            return SeparatedListView(
                isTablet: isTablet,
                itemCount: appointments.length,
                separator: const Divider(),
                itemBuilder: (context, index) {
                  final String appointmentState =
                      appointments[index].state == 'PENDING'
                          ? appointments[index].appointmentStatus ??
                              appointments[index].state
                          : appointments[index].state;
                  return ListTile(
                    onTap: appointmentState != AppointmentState.FINISHED.name
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
                          appointmentState,
                          style: getSnackBarTitleStyle(isTablet).copyWith(
                              color: mapStateToColor(AppointmentState.values
                                  .where((element) =>
                                      element.name == appointmentState)
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

  IconButton _buildFilterIconButton(BuildContext context, bool isTablet) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            _checkedList = _checkedList ??
                AppointmentState.values.map((e) => false).toList();
            return _buildAppointmentFilterContent(isTablet);
          },
        ).then((value) => setState(() {}));
      },
      icon: const Icon(
        Icons.filter_list_outlined,
        color: Colors.black,
      ),
    );
  }

  StatefulBuilder _buildAppointmentFilterContent(bool isTablet) {
    return StatefulBuilder(builder: (context, setState) {
      return LongBottomSheet(
        title: AppLocalizations.of(context)!.filters,
        buttonChild: Text(AppLocalizations.of(context)!.apply),
        btnActive: true,
        heightFactor: 0.7,
        onSubmit: () {
          Navigator.pop(context);
        },
        formRunSpacing: 0,
        children: [
          Text(
            AppLocalizations.of(context)!.states,
            style: getSectionTitle(isTablet),
          ),
          _buildAppointmentCheckboxes(isTablet, setState),
        ],
      );
    });
  }

  ListView _buildAppointmentCheckboxes(bool isTablet, StateSetter setState) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top: isTablet ? 42 : 20.sp,
        bottom: isTablet ? 70 : 51.sp,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppointmentState.values.length,
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(
            AppointmentState.values[index].name,
            style: getSnackBarTitleStyle(isTablet).copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          value: _checkedList![index],
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          onChanged: (value) {
            setState(() {
              _checkedList![index] = value;
              value!
                  ? _filtersList.add(AppointmentState.values[index].name.trim())
                  : _filtersList
                      .remove(AppointmentState.values[index].name.trim());
            });
          },
        );
      },
    );
  }
}
