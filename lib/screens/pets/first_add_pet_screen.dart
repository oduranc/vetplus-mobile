import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/breed_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/pets/second_add_pet_screen.dart';
import 'package:vetplus/services/breed_service.dart';
import 'package:vetplus/utils/image_utils.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/add_image_button.dart';
import 'package:vetplus/widgets/pets/pet_form_fields.dart';

class FirstAddPetScreen extends StatefulWidget {
  const FirstAddPetScreen({super.key});
  static const route = 'first-add-pet-screen';

  @override
  State<FirstAddPetScreen> createState() => _FirstAddPetScreenState();
}

class _FirstAddPetScreenState extends State<FirstAddPetScreen> {
  String? _sex;
  int? _specie;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  BreedModel? _selectedBreed;
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
              Navigator.pushNamed(context, SecondAddPetScreen.route,
                  arguments: [
                    _selectedImage,
                    _nameController.text,
                    _sex,
                    _specie,
                    _selectedBreed!.id
                  ]);
            },
            buttonChild: Text(AppLocalizations.of(context)!.next),
            children: [
              Align(
                alignment: Alignment.center,
                child: AddImageButton(
                  primaryIcon: Icons.pets,
                  foregroundColor: Color(0xFFFBFBFB),
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  action: () {
                    buildPickImageModal(
                      context,
                      () async {
                        _selectedImage = await pickImage(ImageSource.gallery);
                        setState(() {});
                      },
                      () async {
                        _selectedImage = await pickImage(ImageSource.camera);
                        setState(() {});
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
              PetNameFormField(nameController: _nameController),
              buildPetGenderFormField(context, (String? value) {
                _sex = value;
              }),
              buildPetSpecieFormField(context, (int? value) {
                _specie = value;
                _selectedBreed = null;
                _breedController.text = '';
              }),
              buildPetBreedFormField(context, _breedController, () {
                buildSpeciesBottomSheet(context, isTablet);
              }),
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> buildSpeciesBottomSheet(
    BuildContext context,
    bool isTablet,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: BreedService.getAllBreeds(
                Provider.of<UserProvider>(context, listen: false).accessToken!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.serverFailedBody),
                );
              } else {
                final breedsJson = snapshot.data!;
                BreedList breeds = BreedList.fromJson(breedsJson.data!);
                print(_specie);
                breeds.list = _specie != null
                    ? breeds.list
                        .where((breed) => breed.idSpecie == _specie)
                        .toList()
                    : breeds.list;
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
                            title: Text(breeds.list[index].name),
                            value: breeds.list[index].name,
                            groupValue: _selectedBreed?.name,
                            onChanged: (value) {
                              setState(() {
                                _selectedBreed = breeds.list[index];
                                _breedController.text = _selectedBreed!.name;
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: breeds.list.length,
                      ),
                    ],
                  );
                });
              }
            });
      },
    );
  }
}
