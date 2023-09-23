// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
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
import 'package:vetplus/widgets/images/pet_image_screen.dart';

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

    Map<String, String> editableFields = {
      appLocalizations.nameText: pet.name,
      appLocalizations.sex:
          pet.gender == 'M' ? appLocalizations.male : appLocalizations.female,
      appLocalizations.specie:
          pet.idSpecie == 1 ? appLocalizations.dog : appLocalizations.cat,
      appLocalizations.breed: pet.idBreed.toString(),
      appLocalizations.dateOfBirth: pet.dob ?? appLocalizations.add,
      appLocalizations.castrated: pet.castrated ? appLocalizations.yes : 'No',
      appLocalizations.observations: pet.observations ?? appLocalizations.add,
    };

    return SkeletonScreen(
      appBar: AppBar(title: Text(appLocalizations.petProfile)),
      body: Column(
        children: [
          Padding(
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
                  PetImageScreen.route,
                  arguments: {
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
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.sp),
              child: Text(appLocalizations.generalInformation,
                  style: getSectionTitle(isTablet)),
            ),
          ),
          SeparatedListView(
            isTablet: isTablet,
            itemCount: editableFields.length,
            separator: const Divider(),
            itemBuilder: (context, index) {
              return Builder(builder: (context) {
                return ListTile(
                  onTap: () {
                    _buildEditInfoScreen(
                        context, editableFields, index, pet, appLocalizations);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        editableFields.keys.elementAt(index),
                        style: getBottomSheetTitleStyle(isTablet),
                      ),
                      SizedBox(height: isTablet ? 4 : 4.sp),
                      Text(
                        editableFields.values.elementAt(index),
                        style: getCarouselBodyStyle(isTablet).copyWith(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    size: isTablet ? 35 : 25.sp,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updatePetImage(BuildContext context, PetModel pet) async {
    if (_selectedImage != null) {
      final token =
          Provider.of<UserProvider>(context, listen: false).accessToken!;
      QueryResult imageResult =
          await ImageService.uploadImage(token, _selectedImage!, true);
      Map<String, dynamic> values = {
        'id': pet.id,
        'id_specie': pet.idSpecie,
        'id_breed': pet.idBreed,
        'name': pet.name,
        'url_current_image': pet.image,
        'url_new_image': imageResult.data!['savePetImage']['image'],
        'gender': pet.gender,
        'castrated': pet.castrated,
        'dob': pet.dob,
        'observations': pet.observations,
      };
      await editPetProfile(token, values, context);
    }
  }

  Future<dynamic> _buildEditInfoScreen(
      BuildContext context,
      Map<String, String> editableFields,
      int index,
      PetModel pet,
      AppLocalizations appLocalizations) {
    TextEditingController editFieldController = TextEditingController();
    editFieldController.text =
        editableFields.values.elementAt(index) == appLocalizations.add
            ? ''
            : editableFields.values.elementAt(index);
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return LongBottomSheet(
            title: appLocalizations.editInfoScreenTitle(
                editableFields.keys.elementAt(index).toLowerCase()),
            buttonChild: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(appLocalizations.update),
            onSubmit: () async {
              setState(() {
                _isLoading = true;
              });
              await _tryEditField(pet, editableFields, index,
                  editFieldController, context, appLocalizations);
              setState(() {
                _isLoading = false;
              });
            },
            children: [
              CustomFormField(
                controller: editFieldController,
                keyboardType: TextInputType.text,
                labelText: editableFields.keys.elementAt(index),
              )
            ],
          );
        });
      },
    );
  }

  Future<void> _tryEditField(
      PetModel pet,
      Map<String, String> editableFields,
      int index,
      TextEditingController editFieldController,
      BuildContext context,
      AppLocalizations appLocalizations) async {
    try {
      Map<String, dynamic> values = {
        'id': pet.id,
        'id_specie': pet.idSpecie,
        'id_breed': pet.idBreed,
        'name': pet.name,
        'gender': pet.gender,
        'castrated': pet.castrated,
        'dob': pet.dob,
        'observations': pet.observations,
      };
      final target = editableFields.keys.elementAt(index);
      Map<String, String> targetToKey = {
        appLocalizations.nameText: 'name',
        appLocalizations.sex: 'gender',
        appLocalizations.specie: 'id_specie',
        appLocalizations.breed: 'id_breed',
        appLocalizations.dateOfBirth: 'dob',
        appLocalizations.castrated: 'castrated',
        appLocalizations.observations: 'observations',
      };
      if (targetToKey.containsKey(target)) {
        values[targetToKey[target]!] = editFieldController.text;
      }
      await editPetProfile(
          Provider.of<UserProvider>(context, listen: false).accessToken!,
          values,
          context);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                title: appLocalizations.successEditDialogTitle,
                body: appLocalizations.successEditDialogBody(
                    editableFields.keys.elementAt(index)),
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.check_circle_outline);
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: appLocalizations.errorEditDialogTitle,
            body: appLocalizations
                .errorEditDialogBody(editableFields.keys.elementAt(index)),
            color: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        },
      );
    }
  }
}
