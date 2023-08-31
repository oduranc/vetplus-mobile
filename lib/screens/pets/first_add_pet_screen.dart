import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/second_add_pet_screen.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/pets/add_pet_button.dart';

class FirstAddPetScreen extends StatelessWidget {
  const FirstAddPetScreen({super.key});
  static const route = 'first-add-pet-screen';

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
            onSubmit: () {
              Navigator.pushNamed(context, SecondAddPetScreen.route);
            },
            buttonChild: Text(AppLocalizations.of(context)!.next),
            children: [
              Align(
                alignment: Alignment.center,
                child: AddPetButton(
                  foregroundColor: Color(0xFFFBFBFB),
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  action: () {},
                  miniIcon: Icons.camera_alt,
                  miniButtonStyle: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFE8E8E8)),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onInverseSurface),
                  ),
                  width: isTablet ? 158 : 120.sp,
                ),
              ),
              CustomFormField(
                keyboardType: TextInputType.name,
                labelText: AppLocalizations.of(context)!.nameText,
                validator: (value) {
                  return validateName(value, context);
                },
              ),
              DropdownButtonFormField(
                validator: (value) {
                  return validateSex(value, context);
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.sex)),
                items: const [
                  DropdownMenuItem(
                    child: Text('Masculino'),
                    value: 'M',
                  ),
                  DropdownMenuItem(
                    child: Text('Femenino'),
                    value: 'F',
                  ),
                ],
                onChanged: (String? value) {},
              ),
              DropdownButtonFormField(
                validator: (value) {
                  return validateSpecie(value, context);
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.specie)),
                items: const [
                  DropdownMenuItem(
                    child: Text('Perro'),
                    value: 'P',
                  ),
                  DropdownMenuItem(
                    child: Text('Gato'),
                    value: 'G',
                  ),
                ],
                onChanged: (String? value) {},
              ),
              DropdownButtonFormField(
                validator: (value) {
                  return validateBreed(value, context);
                },
                decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.breed)),
                items: const [
                  DropdownMenuItem(
                    child: Text('Perro'),
                    value: 'P',
                  ),
                  DropdownMenuItem(
                    child: Text('Gato'),
                    value: 'G',
                  ),
                ],
                onChanged: (String? value) {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
