// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vetplus/models/breed_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/services/breed_service.dart';
import 'package:vetplus/services/image_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/image_utils.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';
import 'package:vetplus/widgets/common/separated_list_view.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/home/add_image_button.dart';
import 'package:vetplus/widgets/images/image_screen.dart';
import 'package:vetplus/widgets/pets/pet_form_fields.dart';

class PetProfile extends StatefulWidget {
  const PetProfile({super.key});
  static const route = 'pet-profile';

  @override
  State<PetProfile> createState() => _PetProfileState();
}

class _PetProfileState extends State<PetProfile> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final PetModel pet = Provider.of<PetsProvider>(context)
        .pets!
        .where((pet) => pet.id == arguments['id'])
        .first;
    final appLocalizations = AppLocalizations.of(context)!;

    return SkeletonScreen(
      appBar: AppBar(title: Text(appLocalizations.petProfile)),
      body: Column(
        children: [
          _buildImageButton(isTablet, pet, context),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.sp),
              child: Text(appLocalizations.generalInformation,
                  style: getSectionTitle(isTablet)),
            ),
          ),
          FutureBuilder(
            future: getBreedName(pet, context),
            builder: (context, snapshot) {
              Map<String, String> editableFields = {
                appLocalizations.nameText: pet.name,
                appLocalizations.sex: pet.gender == 'M'
                    ? appLocalizations.male
                    : appLocalizations.female,
                appLocalizations.breed: snapshot.data ?? appLocalizations.add,
                appLocalizations.dateOfBirth: pet.dob != null
                    ? DateFormat.yMMMMd(Platform.localeName.startsWith('es')
                            ? 'es_US'
                            : 'en_US')
                        .format(DateTime.parse(pet.dob!))
                    : appLocalizations.add,
                appLocalizations.castrated:
                    pet.castrated ? appLocalizations.yes : 'No',
                appLocalizations.observations:
                    pet.observations ?? appLocalizations.add,
              };
              return SeparatedListView(
                isTablet: isTablet,
                itemCount: editableFields.length,
                separator: const Divider(),
                itemBuilder: (context, index) {
                  final field = editableFields.entries.elementAt(index);
                  return _buildEditableField(
                      context, field, pet, appLocalizations);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildEditableField(
    BuildContext context,
    MapEntry field,
    PetModel pet,
    AppLocalizations appLocalizations,
  ) {
    bool isTablet = Responsive.isTablet(context);

    return ListTile(
      onTap: () {
        _buildEditInfoScreen(context, field, pet, appLocalizations);
      },
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.key,
            style: getBottomSheetTitleStyle(isTablet),
          ),
          SizedBox(height: isTablet ? 4 : 4.sp),
          Text(
            field.value ?? appLocalizations.add,
            style: getCarouselBodyStyle(isTablet)
                .copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.onInverseSurface,
        size: isTablet ? 35 : 25.sp,
      ),
    );
  }

  Padding _buildImageButton(bool isTablet, PetModel pet, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: isTablet ? 114 : 43.sp, bottom: isTablet ? 166 : 55.sp),
      child: AddImageButton(
        primaryIcon: Icons.pets,
        image: pet.image != null ? NetworkImage(pet.image!) : null,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        bigButtonAction: () {
          Navigator.pushNamed(
            context,
            ImageScreen.route,
            arguments: {
              'isPet': true,
              'id': pet.id,
            },
          );
        },
        action: () {
          buildPickImageModal(
            context,
            () async {
              _selectedImage = await pickImage(ImageSource.gallery);
              setState(() {});
              await _updatePetImage(context, pet);
            },
            () async {
              _selectedImage = await pickImage(ImageSource.camera);
              setState(() {});
              await _updatePetImage(context, pet);
            },
          );
        },
        miniIcon: Icons.camera_alt,
        miniButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFE8E8E8)),
          foregroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.onInverseSurface),
        ),
        width: (isTablet ? 84 : 70.sp) * 2,
      ),
    );
  }

  Future<void> _updatePetImage(BuildContext context, PetModel pet) async {
    if (_selectedImage == null) {
      return;
    }
    final token =
        Provider.of<UserProvider>(context, listen: false).accessToken!;

    QueryResult imageResult =
        await ImageService.uploadImage(token, _selectedImage!, true);
    final newImage = imageResult.data!['savePetImage']['image'];

    Map<String, dynamic> values = {
      'url_current_image': pet.image,
      'url_new_image': newImage,
    };
    await editPetProfile(token, values, context, pet);
  }

  Future<void> _buildEditInfoScreen(
    BuildContext context,
    MapEntry field,
    PetModel pet,
    AppLocalizations appLocalizations,
  ) async {
    dynamic updatedValue;
    String sex = pet.gender;
    int breedId = pet.idBreed;
    bool showDatePicker = false;
    bool castrated = pet.castrated;
    String? dateOfBirth = pet.dob;

    final DateTime now = DateTime.now();
    final DateTime minDate = DateTime(now.year - 100, now.month, now.day);

    bool isTablet = Responsive.isTablet(context);

    final fieldName = field.key.toString().toLowerCase();
    TextEditingController editFieldController = TextEditingController();
    editFieldController.text =
        field.value != appLocalizations.add ? field.value : '';

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          Map<String, Widget> targetToFormField = {
            appLocalizations.nameText: CustomFormField(
              controller: editFieldController,
              keyboardType: TextInputType.text,
              labelText: field.key,
            ),
            appLocalizations.sex:
                buildPetGenderFormField(context, (String? value) {
              sex = value!;
              updatedValue = sex;
            }, sex[0].toUpperCase()),
            appLocalizations.breed:
                buildPetBreedFormField(context, editFieldController, () async {
              breedId = await buildSpeciesBottomSheet(
                  context, isTablet, pet, editFieldController, breedId);
              updatedValue = breedId;
            }),
            appLocalizations.dateOfBirth:
                buildPetDobFormField(context, editFieldController, () {
              setState(() {
                showDatePicker = true;
              });
            }),
            appLocalizations.castrated:
                buildPetCastratedFormField(context, (bool? value) {
              castrated = value!;
              updatedValue = castrated;
            }, castrated),
            appLocalizations.observations: CustomFormField(
              controller: editFieldController,
              keyboardType: TextInputType.text,
              labelText: field.key,
            ),
          };

          return LongBottomSheet(
            title: appLocalizations.editInfoScreenTitle(fieldName),
            buttonChild: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text(appLocalizations.update),
            onSubmit: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    updatedValue ??= editFieldController.text == ''
                        ? null
                        : editFieldController.text;
                    final fieldName = field.key;
                    await _tryEditField(pet, fieldName, updatedValue, context,
                        appLocalizations);
                    setState(() {
                      _isLoading = false;
                    });
                  },
            footer: showDatePicker
                ? buildCalendar(
                    isTablet,
                    now,
                    minDate,
                    dateOfBirth != null ? DateTime.parse(dateOfBirth!) : null,
                    (date) {
                      if (date is DateRangePickerSelectionChangedArgs) {
                        date = date.value;
                      }
                      dateOfBirth = date.toIso8601String();
                      updatedValue = dateOfBirth;
                      setState(
                        () {
                          editFieldController.text = DateFormat.yMMMMd(
                                  Platform.localeName.startsWith('es')
                                      ? 'es_US'
                                      : 'en_US')
                              .format(date);
                        },
                      );
                    },
                  )
                : null,
            children: [
              targetToFormField[field.key]!,
            ],
          );
        });
      },
    );
  }

  Future<void> _tryEditField(
    PetModel pet,
    String fieldName,
    dynamic updatedValue,
    BuildContext context,
    AppLocalizations appLocalizations,
  ) async {
    try {
      final accessToken =
          Provider.of<UserProvider>(context, listen: false).accessToken!;

      Map<String, String> targetToKey = {
        appLocalizations.nameText: 'name',
        appLocalizations.sex: 'gender',
        appLocalizations.specie: 'id_specie',
        appLocalizations.breed: 'id_breed',
        appLocalizations.dateOfBirth: 'dob',
        appLocalizations.castrated: 'castrated',
        appLocalizations.observations: 'observations',
      };

      final key = targetToKey[fieldName] ?? fieldName;

      await editPetProfile(accessToken, {key: updatedValue}, context, pet);
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.successEditDialogTitle,
            body: appLocalizations.successEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.check_circle_outline,
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.errorEditDialogTitle,
            body: appLocalizations.errorEditDialogBody(fieldName),
            color: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        },
      );
    }
  }

  Future<int> buildSpeciesBottomSheet(
    BuildContext context,
    bool isTablet,
    PetModel pet,
    TextEditingController editFieldController,
    int breedIndex,
  ) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        int specie = pet.idSpecie;

        return FutureBuilder(
            future: BreedService.getAllBreeds(
                Provider.of<UserProvider>(context, listen: false).accessToken!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.serverFailedBody),
                  ),
                );
              } else if (snapshot.data!.hasException) {
                return FractionallySizedBox(
                  heightFactor: 0.5,
                  child: Center(
                    child:
                        Text(AppLocalizations.of(context)!.internetConnection),
                  ),
                );
              } else {
                final breedsJson = snapshot.data!;
                BreedList breeds = BreedList.fromJson(breedsJson.data!);
                breeds.list = breeds.list
                    .where((breed) => breed.idSpecie == specie)
                    .toList();
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
                          final selectedBreed = breeds.list
                              .where((element) => element.id == breedIndex)
                              .first;
                          return RadioListTile(
                            title: Text(breeds.list[index].name),
                            value: breeds.list[index].name,
                            groupValue: selectedBreed.name,
                            onChanged: (value) {
                              setState(() {
                                breedIndex = breeds.list[index].id;
                                editFieldController.text =
                                    breeds.list[index].name;
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
    return breedIndex;
  }
}
