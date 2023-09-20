// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/breed_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/services/pet_service.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

Future<void> tryRegisterPet(File? image, String name, String gender, int specie,
    int breed, bool castrated, String dob, BuildContext context) async {
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
        navigateToHome(context, user, accessToken, pets);
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
    builder: (context) =>
        CustomDialog(title: title, body: body, color: color, icon: icon),
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

String getBreedName(BreedList breeds, List<PetModel> pets, int index) {
  final breedName =
      breeds.list.where((breed) => breed.id == pets[index].idBreed).first.name;
  return breedName;
}

String getFormattedAge(List<PetModel> pets, int index, BuildContext context) {
  String ageUnit;
  if (pets[index].age.split(' ')[1] == AgeUnit.years.toString()) {
    ageUnit = AppLocalizations.of(context)!.years;
  } else if (pets[index].age.split(' ')[1] == AgeUnit.months.toString()) {
    ageUnit = AppLocalizations.of(context)!.months;
  } else {
    ageUnit = AppLocalizations.of(context)!.days;
  }
  final age = '${pets[index].age.split(' ')[0]} $ageUnit';
  return age;
}
