// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/screens/pets/my_pets_screen.dart';
import 'package:vetplus/screens/profile/personal_information_screen.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';

class ProfileDetailsDTO {
  final IconData leadingIcon;
  final String name;
  final Future<dynamic> Function(BuildContext) action;

  ProfileDetailsDTO(
      {required this.leadingIcon, required this.name, required this.action});
}

List<ProfileDetailsDTO> getItems(BuildContext context) {
  return [
    ProfileDetailsDTO(
      leadingIcon: Icons.account_circle_outlined,
      name: AppLocalizations.of(context)!.personalInformation,
      action: pushPersonalInformationScreen,
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.pets,
      name: AppLocalizations.of(context)!.myPets,
      action: pushMyPetsScreen,
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.logout_outlined,
      name: AppLocalizations.of(context)!.logout,
      action: buildLogoutSheet,
    )
  ];
}

Future<dynamic> pushPersonalInformationScreen(BuildContext context) {
  return Navigator.pushNamed(context, PersonalInformationScreen.route);
}

Future<dynamic> pushMyPetsScreen(BuildContext context) {
  return Navigator.pushNamed(context, MyPetsScreen.route);
}

Future<dynamic> buildLogoutSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return ButtonsBottomSheet(
        children: [
          ElevatedButton(
            onPressed: () {
              signOut(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.logout),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      );
    },
  );
}
