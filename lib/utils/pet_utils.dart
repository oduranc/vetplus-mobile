// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/breed_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/services/breed_service.dart';
import 'package:vetplus/services/pet_service.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

Future<void> tryRegisterPet(File? image, String name, String gender, int specie,
    int breed, bool castrated, String? dob, BuildContext context) async {
  try {
    final accessToken =
        Provider.of<UserProvider>(context, listen: false).accessToken!;
    final result = await PetService.registerPet(
        image, name, gender, specie, breed, castrated, dob, accessToken);

    if (!result.hasException) {
      await _showCustomDialog(
        AppLocalizations.of(context)!.registeredPetTitle,
        AppLocalizations.of(context)!.registeredPetBody,
        Colors.green,
        Icons.check_circle_outline_outlined,
        context,
      ).then((value) async {
        final pets = await getPets(context, accessToken);
        final user = await getUserProfile(accessToken);
        final favorites = await getFavorites(context, accessToken);
        navigateToHome(context, user, accessToken, pets, favorites);
      });
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> _showCustomDialog(String title, String body, Color color,
    IconData icon, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return FutureBuilder(
        future:
            Future.delayed(const Duration(seconds: 2)).then((value) => true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Navigator.of(context).pop();
          }
          return CustomDialog(
              title: title, body: body, color: color, icon: icon);
        },
      );
    },
  );
}

Future<void> _showServerErrorDialog(BuildContext context) {
  return _showCustomDialog(
    AppLocalizations.of(context)!.serverFailedTitle,
    AppLocalizations.of(context)!.serverFailedBody,
    Theme.of(context).colorScheme.error,
    Icons.error_outline_outlined,
    context,
  );
}

Future<PetList> getPets(BuildContext context, accessToken) async {
  final petsResult = await PetService.getMyPets(accessToken);
  final petsJson = petsResult.data!;
  final pets = PetList.fromJson(petsJson);
  return pets;
}

Future<String> getBreedName(PetModel pet, BuildContext context) async {
  final snapshot = await BreedService.getAllBreeds(
      Provider.of<UserProvider>(context, listen: false).accessToken!);
  BreedList breeds = BreedList.fromJson(snapshot.data!);
  final breedName =
      breeds.list.where((breed) => breed.id == pet.idBreed).first.name;
  return breedName;
}

String getFormattedAge(PetModel pet, BuildContext context) {
  String ageUnit;
  String age = '';
  if (pet.age != '') {
    if (pet.age.split(' ')[1] == AgeUnit.years.toString()) {
      ageUnit = AppLocalizations.of(context)!.years;
    } else if (pet.age.split(' ')[1] == AgeUnit.months.toString()) {
      ageUnit = AppLocalizations.of(context)!.months;
    } else {
      ageUnit = AppLocalizations.of(context)!.days;
    }
    age = '${pet.age.split(' ')[0]} $ageUnit';
  }
  return age;
}

Future<void> editPetProfile(String accessToken, Map<String, dynamic> values,
    BuildContext context, PetModel pet) async {
  final res = await PetService.editPetProfile(accessToken, values, pet);

  final pets = await getPets(context, accessToken);
  final petsProvider = Provider.of<PetsProvider>(context, listen: false);
  petsProvider.setPets(pets.list);
}
