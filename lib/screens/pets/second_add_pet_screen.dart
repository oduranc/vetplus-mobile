import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/pets/pet_form_fields.dart';

class SecondAddPetScreen extends StatefulWidget {
  const SecondAddPetScreen({super.key});
  static const route = 'second-add-pet-screen';

  @override
  State<SecondAddPetScreen> createState() => _SecondAddPetScreenState();
}

class _SecondAddPetScreenState extends State<SecondAddPetScreen> {
  bool _showDatePicker = false;
  final TextEditingController datePickerController = TextEditingController();
  late bool _castrated;
  String? _dateOfBirth;
  bool _isLoading = false;

  Future<void> _tryRegisterPet(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    await tryRegisterPet(args[0], args[1], args[2], args[3], args[4],
        _castrated, _dateOfBirth, context);

    setState(() {
      _isLoading = false;
    });
  }

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
            onSubmit: () {
              _tryRegisterPet(context);
            },
            buttonChild: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white))
                : Text(AppLocalizations.of(context)!.save),
            children: [
              buildPetCastratedFormField(context, (bool? value) {
                _castrated = value!;
              }, null),
              buildPetDobFormField(context, datePickerController, () {
                setState(() {
                  _showDatePicker = true;
                });
              }),
            ],
          ),
          if (_showDatePicker)
            buildCalendar(
              isTablet,
              now,
              minDate,
              null,
              (date) {
                if (date is DateRangePickerSelectionChangedArgs) {
                  date = date.value;
                }
                _dateOfBirth = date.toIso8601String();
                setState(
                  () {
                    datePickerController.text = DateFormat.yMMMMd(
                            Platform.localeName.startsWith('es')
                                ? 'es_US'
                                : 'en_US')
                        .format(date);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
