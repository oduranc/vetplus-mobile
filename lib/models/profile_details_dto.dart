// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/models/help_dto.dart';
import 'package:vetplus/screens/pets/my_pets_screen.dart';
import 'package:vetplus/screens/profile/help_index_screen.dart';
import 'package:vetplus/screens/profile/help_screen.dart';
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

List<ProfileDetailsDTO> getHelpItems(BuildContext context) {
  return [
    ProfileDetailsDTO(
      leadingIcon: Icons.emoji_people_outlined,
      name: AppLocalizations.of(context)!.help1,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 0, AppLocalizations.of(context)!.help1);
      },
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.store_mall_directory_outlined,
      name: AppLocalizations.of(context)!.help2,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 1, AppLocalizations.of(context)!.help2);
      },
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.insert_drive_file_outlined,
      name: AppLocalizations.of(context)!.help3,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 2, AppLocalizations.of(context)!.help3);
      },
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.event_outlined,
      name: AppLocalizations.of(context)!.help4,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 3, AppLocalizations.of(context)!.help4);
      },
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.receipt_long_outlined,
      name: AppLocalizations.of(context)!.help5,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 4, AppLocalizations.of(context)!.help5);
      },
    ),
    ProfileDetailsDTO(
      leadingIcon: Icons.grid_view_outlined,
      name: AppLocalizations.of(context)!.help6,
      action: (BuildContext context) async {
        pushHelpIndexScreen(context, 5, AppLocalizations.of(context)!.help6);
      },
    ),
  ];
}

List<ProfileDetailsDTO> getProfileItems(BuildContext context) {
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
      leadingIcon: Icons.help_outline_outlined,
      name: AppLocalizations.of(context)!.help,
      action: pushHelpScreen,
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

Future<dynamic> pushHelpScreen(BuildContext context) {
  return Navigator.pushNamed(context, HelpScreen.route);
}

dynamic pushHelpIndexScreen(BuildContext context, int index, String title) {
  final items = getHelpDtoItems(context, title);

  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HelpIndexScreen(helpItem: items[index]),
    ),
  );
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
