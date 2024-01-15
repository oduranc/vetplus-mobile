// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/appointments/appointments_history_screen.dart';
import 'package:vetplus/services/appointments_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/custom_calendar.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  const ScheduleAppointmentScreen({
    super.key,
    required this.clinic,
    required this.user,
  });

  final ClinicModel clinic;
  final UserModel user;

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  String? selectedDate = DateTime.now().weekday != 7
      ? DateTime.now().toIso8601String()
      : DateTime.now().add(const Duration(days: 1)).toIso8601String();
  int weekDay = DateTime.now().weekday != 7 ? DateTime.now().weekday : 1;
  TimeOfDay? selectedTime;
  List<String?> selectedServices = [];
  PetModel? selectedPet;

  List<bool?>? _checkedList;
  bool isLoading = false;

  String getFormattedTime(TimeOfDay time) {
    DateTime dateTime = DateTime(2000, 12, 12, time.hour, time.minute);
    return DateFormat('h:mm a', 'en_US').format(dateTime);
  }

  @override
  void initState() {
    _checkedList =
        _checkedList ?? widget.clinic.services!.map((e) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    List<PetModel>? pets = Provider.of<PetsProvider>(context).pets;

    TimeOfDay startTime;
    TimeOfDay endTime;

    if (widget.clinic.schedule != null) {
      startTime = TimeOfDay(
        hour: int.parse(
          widget.clinic.schedule!.workingDays[weekDay - 1].startTime
              .split(":")[0],
        ),
        minute: int.parse(
          widget.clinic.schedule!.workingDays[weekDay - 1].startTime
              .split(":")[1],
        ),
      );

      endTime = TimeOfDay(
        hour: int.parse(
          widget.clinic.schedule!.workingDays[weekDay - 1].endTime
              .split(":")[0],
        ),
        minute: int.parse(
          widget.clinic.schedule!.workingDays[weekDay - 1].endTime
              .split(":")[1],
        ),
      );
    } else {
      startTime = const TimeOfDay(hour: 8, minute: 0);
      endTime = const TimeOfDay(hour: 17, minute: 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appointments),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 37 : 24.sp,
            vertical: isTablet ? 60 : 35.sp,
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: isTablet ? 30 : 23.sp,
            children: [
              Text(widget.clinic.name, style: getClinicTitleStyle(isTablet)),
              _buildDatePicker(context, isTablet, widget.clinic.schedule),
              SizedBox(
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.time,
                    style: getClinicTitleStyle(isTablet)),
              ),
              _buildTimePicker(isTablet, startTime, endTime),
              SizedBox(
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.services,
                    style: getClinicTitleStyle(isTablet)),
              ),
              _buildServicesList(isTablet),
              SizedBox(
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.myPets,
                    style: getClinicTitleStyle(isTablet)),
              ),
              if (pets != null) _buildPetsList(isTablet, pets),
              ElevatedButton(
                onPressed: selectedDate == null ||
                        selectedTime == null ||
                        selectedServices.isEmpty ||
                        selectedPet == null
                    ? null
                    : () {
                        showConfirmationBottomSheet(context, isTablet);
                      },
                child: Text(AppLocalizations.of(context)!.schedule),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showConfirmationBottomSheet(
      BuildContext context, bool isTablet) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return LongBottomSheet(
            title: AppLocalizations.of(context)!.confirmation,
            heightFactor: 0.7,
            btnActive: true,
            formRunSpacing: isTablet ? 10 : 5.sp,
            buttonChild: Text(AppLocalizations.of(context)!.confirmAppointment),
            onSubmit: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    final result =
                        await AppointmentsService.scheduleAppointment(
                      Provider.of<UserProvider>(context, listen: false)
                          .accessToken!,
                      widget.clinic.idOwner,
                      selectedPet!.id,
                      selectedServices,
                      widget.clinic.id,
                      DateFormat('yyyy-MM-dd, h:mm a')
                          .parse(
                              '${selectedDate!.substring(0, 10)}, ${getFormattedTime(selectedTime!)}')
                          .toIso8601String(),
                    );
                    if (result.data != null &&
                        result.data!['scheduleAppoinment']['result'] ==
                            'COMPLETED') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder(
                              future: Future.delayed(const Duration(seconds: 2))
                                  .then((value) => true),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Navigator.of(context).pop();
                                }
                                return CustomDialog(
                                  title: AppLocalizations.of(context)!
                                      .confirmation,
                                  body: AppLocalizations.of(context)!
                                      .appointmentScheduledBody,
                                  color: Colors.green,
                                  icon: Icons.check_circle_outline,
                                );
                              });
                        },
                      ).then((value) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AppointmentsHistoryScreen(
                              listRole: 'PET_OWNER',
                            ),
                          ),
                        );
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            title: AppLocalizations.of(context)!.confirmation,
                            body: AppLocalizations.of(context)!
                                .errorAppointmentScheduledBody,
                            color: Colors.red,
                            icon: Icons.error_outline,
                          );
                        },
                      );
                    }
                  },
            children: [
              buildConfirmationDetail(
                context,
                isTablet,
                AppLocalizations.of(context)!.clinic,
                [widget.clinic.name],
              ),
              const Divider(),
              buildConfirmationDetail(
                context,
                isTablet,
                AppLocalizations.of(context)!.date,
                [
                  '${selectedDate!.substring(0, 10)}, ${getFormattedTime(selectedTime!)}'
                ],
              ),
              Divider(),
              buildConfirmationDetail(
                context,
                isTablet,
                AppLocalizations.of(context)!.services,
                selectedServices.map((e) => e!.toUpperCase()).toList(),
              ),
              Divider(),
              buildConfirmationDetail(
                context,
                isTablet,
                AppLocalizations.of(context)!.pet,
                [selectedPet!.name],
              ),
            ],
          );
        });
      },
    );
  }

  SizedBox _buildPetsList(bool isTablet, List<PetModel> pets) {
    return SizedBox(
      height: isTablet ? 150 : 110.sp,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPet = pets[index];
              });
            },
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 3,
              margin: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 4,
                right: isTablet ? 40 : 36.sp,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isTablet ? 25 : 20.sp),
                    child: SizedBox(
                      width: isTablet ? 220 : 180.sp,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Responsive.isTablet(context) ? 39 : 32.5.sp,
                            backgroundColor: const Color(0xFFDCDCDD),
                            foregroundColor: const Color(0xFFFBFBFB),
                            backgroundImage: pets[index].image != null
                                ? NetworkImage(pets[index].image!)
                                : null,
                            child: pets[index].image != null
                                ? null
                                : Icon(Icons.pets,
                                    size: Responsive.isTablet(context)
                                        ? 36
                                        : 30.sp),
                          ),
                          SizedBox(width: isTablet ? 15 : 10.sp),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pets[index].name,
                                overflow: TextOverflow.ellipsis,
                                style: getSnackBarTitleStyle(isTablet),
                              ),
                              if (pets[index].age != '')
                                Text(
                                  getFormattedAge(pets[index], context),
                                  overflow: TextOverflow.ellipsis,
                                  style: getSnackBarBodyStyle(isTablet),
                                ),
                              if (pets[index].castrated == true)
                                Text(
                                  AppLocalizations.of(context)!.castrated,
                                  overflow: TextOverflow.ellipsis,
                                  style: getSnackBarBodyStyle(isTablet),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Checkbox(
                        value: selectedPet != null &&
                            selectedPet!.name == pets[index].name,
                        onChanged: (value) {
                          setState(() {
                            selectedPet = pets[index];
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ListView _buildServicesList(bool isTablet) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.clinic.services!.length,
      separatorBuilder: (context, index) {
        return const SizedBox();
      },
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(
            widget.clinic.services![index].toString(),
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
                  ? selectedServices.add(widget.clinic.services![index]
                      .toString()
                      .toLowerCase()
                      .trim())
                  : selectedServices.remove(widget.clinic.services![index]
                      .toString()
                      .toLowerCase()
                      .trim());
            });
          },
        );
      },
    );
  }

  SizedBox _buildTimePicker(
      bool isTablet, TimeOfDay startTime, TimeOfDay endTime) {
    final itemCount = (endTime.hour - startTime.hour) * 4;
    return SizedBox(
      height: isTablet ? 95 : 55.sp,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          int updatedHour = startTime.hour;
          int updatedMinute = startTime.minute + 15 * index;

          if (updatedMinute >= 60) {
            updatedHour += updatedMinute ~/ 60;
            updatedMinute = updatedMinute % 60;
          }

          TimeOfDay updatedStartTime =
              TimeOfDay(hour: updatedHour, minute: updatedMinute);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTime = updatedStartTime;
              });
            },
            child: TimeCard(
              isTablet: isTablet,
              text: DateFormat('h:mm a')
                  .format(DateTime(2000, 12, 12, updatedHour, updatedMinute)),
              selectedTime:
                  selectedTime != null ? getFormattedTime(selectedTime!) : null,
            ),
          );
        },
      ),
    );
  }

  Column buildConfirmationDetail(
      BuildContext context, bool isTablet, String title, List<String> body) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: getClinicTitleStyle(isTablet),
          ),
        ),
        SizedBox(height: isTablet ? 5 : 2.sp),
        ...body.map(
          (e) => SizedBox(
            width: double.infinity,
            child: Text(
              e.toUpperCase(),
              style: getCarouselBodyStyle(isTablet),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox _buildDatePicker(
      BuildContext context, bool isTablet, Schedule? schedule) {
    if (schedule != null) {
      schedule.nonWorkingDays.forEach((element) {
        DateTime.parse(element.toString());
      });
    }
    return SizedBox(
      height: isTablet ? 409 : 356.sp,
      child: Row(
        children: [
          CustomCalendar(
            minDate: DateTime.now(),
            initialDate: DateTime.now().weekday != 7
                ? DateTime.now()
                : DateTime.now().add(const Duration(days: 1)),
            isTablet: isTablet,
            onChanged: (date) async {
              if (date is DateRangePickerSelectionChangedArgs) {
                date = date.value;
              }
              setState(() {
                selectedDate = date.toIso8601String();
                weekDay = date.weekday;
              });
            },
            selectableDayPredicate: (DateTime date) {
              if (date.weekday == DateTime.sunday) {
                return false;
              }
              if (schedule != null &&
                  schedule.nonWorkingDays
                      .contains(DateFormat('yyyy-MM-dd').format(date))) {
                return false;
              }
              return true;
            },
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard(
      {super.key,
      required this.isTablet,
      required this.text,
      required this.selectedTime});

  final bool isTablet;
  final String text;
  final String? selectedTime;

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedTime == text;

    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : const Color(0xFFFAFAFA),
      surfaceTintColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : const Color(0xFFFAFAFA),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 14.sp,
          horizontal: isTablet ? 15 : 13.sp,
        ),
        child: Text(
          text,
          style: getSnackBarTitleStyle(isTablet)
              .copyWith(color: isSelected ? Colors.white : null),
        ),
      ),
    );
  }
}
