// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/screens/pets/my_pets_screen.dart';
import 'package:vetplus/screens/profile/personal_information_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
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
            onPressed: () async {
              await GoogleSignIn().signOut();
              Provider.of<UserProvider>(context, listen: false).clearUser();
              Provider.of<PetsProvider>(context, listen: false).clearPets();
              Navigator.pushNamedAndRemoveUntil(
                  context, WelcomeScreen.route, (route) => false);
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
