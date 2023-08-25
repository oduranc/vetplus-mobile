// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/providers/user_provider.dart';
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

final items = [
  ProfileDetailsDTO(
    leadingIcon: Icons.account_circle_outlined,
    name: 'Información personal',
    action: pushPersonalInformationScreen,
  ),
  ProfileDetailsDTO(
    leadingIcon: Icons.pets,
    name: 'Mis mascotas',
    action: buildLogoutSheet,
  ),
  ProfileDetailsDTO(
    leadingIcon: Icons.logout_outlined,
    name: 'Cerrar sesión',
    action: buildLogoutSheet,
  )
];

Future<dynamic> pushPersonalInformationScreen(BuildContext context) {
  return Navigator.pushNamed(context, PersonalInformationScreen.route);
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
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.clearUser();
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
            child: const Text('Cerrar sesión'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}
