import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/employee_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/appointments_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/custom_calendar.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class ScheduleAppointmentScreen extends StatefulWidget {
  const ScheduleAppointmentScreen({
    super.key,
    required this.clinic,
    required this.user,
    required this.employees,
  });

  final ClinicModel clinic;
  final UserModel user;
  final List<EmployeeModel>? employees;

  @override
  State<ScheduleAppointmentScreen> createState() =>
      _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  EmployeeModel? selectedEmployee;
  String? selectedDate;
  TimeOfDay? selectedTime;
  List<String?> selectedServices = [];
  PetModel? selectedPet;

  List<bool?>? _checkedList;

  @override
  void initState() {
    _checkedList =
        _checkedList ?? widget.clinic.services!.map((e) => false).toList();
    selectedEmployee = widget.employees?.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    List<PetModel>? pets = Provider.of<PetsProvider>(context).pets;

    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);

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
              _buildEmployeeSelector(isTablet),
              _buildDatePicker(context, isTablet),
              SizedBox(
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.time,
                    style: getClinicTitleStyle(isTablet)),
              ),
              SizedBox(
                height: isTablet ? 95 : 55.sp,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 45,
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
                        text: updatedStartTime.format(context),
                        selectedTime: selectedTime != null
                            ? selectedTime!.format(context)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(AppLocalizations.of(context)!.services,
                    style: getClinicTitleStyle(isTablet)),
              ),
              ListView.separated(
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
                            ? selectedServices.add(widget
                                .clinic.services![index]
                                .toString()
                                .toLowerCase()
                                .trim())
                            : selectedServices.remove(widget
                                .clinic.services![index]
                                .toString()
                                .toLowerCase()
                                .trim());
                      });
                    },
                  );
                },
              ),
              Text(AppLocalizations.of(context)!.myPets,
                  style: getClinicTitleStyle(isTablet)),
              if (pets != null)
                SizedBox(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 25 : 20.sp),
                                child: SizedBox(
                                  width: isTablet ? 220 : 180.sp,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: Responsive.isTablet(context)
                                            ? 39
                                            : 32.5.sp,
                                        backgroundColor: Color(0xFFDCDCDD),
                                        foregroundColor: Color(0xFFFBFBFB),
                                        backgroundImage: pets[index].image !=
                                                null
                                            ? NetworkImage(pets[index].image!)
                                            : null,
                                        child: pets[index].image != null
                                            ? null
                                            : Icon(Icons.pets,
                                                size:
                                                    Responsive.isTablet(context)
                                                        ? 36
                                                        : 30.sp),
                                      ),
                                      SizedBox(width: isTablet ? 15 : 10.sp),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pets[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                getSnackBarTitleStyle(isTablet),
                                          ),
                                          if (pets[index].age != '')
                                            Text(
                                              getFormattedAge(
                                                  pets[index], context),
                                              overflow: TextOverflow.ellipsis,
                                              style: getSnackBarBodyStyle(
                                                  isTablet),
                                            ),
                                          if (pets[index].castrated == true)
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .castrated,
                                              overflow: TextOverflow.ellipsis,
                                              style: getSnackBarBodyStyle(
                                                  isTablet),
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
                ),
              ElevatedButton(
                onPressed: selectedDate == null ||
                        selectedTime == null ||
                        selectedServices.isEmpty ||
                        selectedPet == null
                    ? null
                    : () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return LongBottomSheet(
                              title: AppLocalizations.of(context)!.confirmation,
                              heightFactor: 0.7,
                              btnActive: true,
                              formRunSpacing: isTablet ? 10 : 5.sp,
                              buttonChild: Text(AppLocalizations.of(context)!
                                  .confirmAppointment),
                              onSubmit: () async {
                                await AppointmentsService.scheduleAppointment(
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .accessToken!,
                                  selectedEmployee!.idEmployee,
                                  selectedPet!.id,
                                  selectedServices,
                                  widget.clinic.id,
                                  DateFormat('yyyy-MM-dd, h:mm a')
                                      .parse(
                                          '${selectedDate!.substring(0, 10)}, ${selectedTime!.format(context)}')
                                      .toIso8601String(),
                                );
                              },
                              children: [
                                buildConfirmationDetail(
                                  context,
                                  isTablet,
                                  AppLocalizations.of(context)!.clinic,
                                  [widget.clinic.name],
                                ),
                                Divider(),
                                buildConfirmationDetail(
                                  context,
                                  isTablet,
                                  AppLocalizations.of(context)!.veterinarian,
                                  [selectedEmployee!.employee.names],
                                ),
                                Divider(),
                                buildConfirmationDetail(
                                  context,
                                  isTablet,
                                  AppLocalizations.of(context)!.date,
                                  [
                                    '${selectedDate!.substring(0, 10)}, ${selectedTime!.format(context)}'
                                  ],
                                ),
                                Divider(),
                                buildConfirmationDetail(
                                  context,
                                  isTablet,
                                  AppLocalizations.of(context)!.services,
                                  selectedServices
                                      .map((e) => e!.toUpperCase())
                                      .toList(),
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
                          },
                        );
                      },
                child: Text(AppLocalizations.of(context)!.schedule),
              ),
            ],
          ),
        ),
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

  SizedBox _buildDatePicker(BuildContext context, bool isTablet) {
    return SizedBox(
      height: isTablet ? 409 : 356.sp,
      child: Row(
        children: [
          CustomCalendar(
            minDate: DateTime.now(),
            initialDate: DateTime.now(),
            isTablet: isTablet,
            onChanged: (date) async {
              if (date is DateRangePickerSelectionChangedArgs) {
                date = date.value;
              }
              selectedDate = date.toIso8601String();
            },
          ),
        ],
      ),
    );
  }

  DropdownButtonFormField<String> _buildEmployeeSelector(bool isTablet) {
    return DropdownButtonFormField(
      value: selectedEmployee!.idEmployee,
      isDense: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 14 : 12.sp,
          vertical: isTablet ? 14 : 12.sp,
        ),
      ),
      items: widget.employees
          ?.map(
            (e) => DropdownMenuItem(
              value: e.idEmployee,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isTablet ? 32.5 : 32.5.sp,
                      backgroundImage: e.employee.image != null
                          ? NetworkImage(e.employee.image!)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: isTablet ? 14 : 12.sp),
                    Text(
                      '${e.employee.names} ${e.employee.surnames ?? ''}',
                      style: getClinicDetailsTextStyle(isTablet).copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        selectedEmployee = widget.employees!
            .where((element) => element.idEmployee == newValue)
            .first;
      },
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
          : Color(0xFFFAFAFA),
      surfaceTintColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : Color(0xFFFAFAFA),
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
