import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/date_picker_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class SecondAddPetScreen extends StatelessWidget {
  const SecondAddPetScreen({super.key});
  static const route = 'second-add-pet-screen';

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerPet),
        centerTitle: true,
      ),
      body: Column(
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
              DatePickerFormField(
                controller: TextEditingController(),
                labelText: AppLocalizations.of(context)!.dateOfBirth,
                initialDate: DateTime.now(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
