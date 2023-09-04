import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/second_add_pet_screen.dart';
import 'package:vetplus/utils/image_utils.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/read_only_form_field.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/pets/add_pet_button.dart';

class FirstAddPetScreen extends StatefulWidget {
  const FirstAddPetScreen({super.key});
  static const route = 'first-add-pet-screen';

  @override
  State<FirstAddPetScreen> createState() => _FirstAddPetScreenState();
}

class _FirstAddPetScreenState extends State<FirstAddPetScreen> {
  String? breed;
  TextEditingController breedController = TextEditingController();
  File? _selectedImage;

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
                  action: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ButtonsBottomSheet(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                _selectedImage =
                                    await pickImage(ImageSource.gallery);
                                setState(() {});
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .selectFromGallery),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                              ),
                              onPressed: () async {
                                _selectedImage =
                                    await pickImage(ImageSource.camera);
                                setState(() {});
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.takeWithCamera),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  miniIcon: Icons.camera_alt,
                  miniButtonStyle: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFE8E8E8)),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onInverseSurface),
                  ),
                  width: isTablet ? 158 : 120.sp,
                  image: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
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
              ReadOnlyFormField(
                validator: (value) {
                  return validateBreed(value, context);
                },
                labelText: AppLocalizations.of(context)!.breed,
                controller: breedController,
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return LongBottomSheet(
                          title: AppLocalizations.of(context)!.breed,
                          buttonChild: Text(AppLocalizations.of(context)!.next),
                          btnActive: true,
                          formRunSpacing: isTablet ? 20 : 14.sp,
                          onSubmit: () {
                            Navigator.pop(context);
                          },
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  title: Text('Raza ${index + 1}'),
                                  value: "Raza ${index + 1}",
                                  groupValue: breed,
                                  onChanged: (value) {
                                    setState(() {
                                      breed = value.toString();
                                      breedController.text = breed!;
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: 12,
                            ),
                          ],
                        );
                      });
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
