import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_calendar.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/read_only_form_field.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class SecondAddPetScreen extends StatefulWidget {
  const SecondAddPetScreen({super.key});
  static const route = 'second-add-pet-screen';

  @override
  State<SecondAddPetScreen> createState() => _SecondAddPetScreenState();
}

class _SecondAddPetScreenState extends State<SecondAddPetScreen> {
  bool _showDatePicker = false;
  final TextEditingController datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final DateTime now = DateTime.now();
    final DateTime minDate = DateTime(now.year - 100, now.month, now.day);

    return SkeletonScreen(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerPet),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FormTemplate(
            onSubmit: () {},
            buttonChild: Text(AppLocalizations.of(context)!.save),
            children: [
              DropdownButtonFormField(
                validator: (value) {
                  return validateCastrated(value, context);
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.castrated)),
                items: [
                  DropdownMenuItem(
                    value: 'true',
                    child: Text(AppLocalizations.of(context)!.yes),
                  ),
                  const DropdownMenuItem(
                    value: 'false',
                    child: Text('No'),
                  ),
                ],
                onChanged: (String? value) {},
              ),
              ReadOnlyFormField(
                controller: datePickerController,
                labelText: AppLocalizations.of(context)!.dateOfBirth,
                onTap: () {
                  setState(() {
                    _showDatePicker = true;
                  });
                },
              ),
            ],
          ),
          if (_showDatePicker)
            SizedBox(
              height: isTablet ? 409 : 356.sp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(),
                  CustomCalendar(
                    now: now,
                    minDate: minDate,
                    isTablet: isTablet,
                    onChanged: (date) {
                      if (date is DateRangePickerSelectionChangedArgs) {
                        date = date.value;
                      }
                      setState(() {
                        datePickerController.text = DateFormat.yMMMMd(
                                Platform.localeName.startsWith('es')
                                    ? 'es_US'
                                    : 'en_US')
                            .format(date);
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
