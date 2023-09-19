// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

Future<void> _tryLoginWithGoogle(BuildContext context) async {
  try {
    final result = await UserService.loginWithGoogle();
    final accessToken = result.data!['googleLogin']['access_token'];
    final user = await getUserProfile(accessToken);
    PetList pets = await getPets(context, accessToken);
    await navigateToHome(context, user, accessToken, pets);
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> trySignUpWithGoogle(BuildContext context) async {
  try {
    final result = await UserService.signUpWithGoogle();
    if (result.hasException) {
      await _tryLoginWithGoogle(context);
    } else {
      final accessToken = result.data!['googleLogin']['access_token'];
      final user = await getUserProfile(accessToken);
      PetList pets = await getPets(context, accessToken);
      await navigateToHome(context, user, accessToken, pets);
    }
  } catch (e) {
    if (e.toString() == 'Null check operator used on a null value') {
      _showCustomDialog(
        AppLocalizations.of(context)!.canceledAction,
        AppLocalizations.of(context)!.canceledGoogleLogin,
        Colors.blue,
        Icons.info_outline_rounded,
        context,
      );
    } else {
      await _showServerErrorDialog(context);
    }
  }
}

Future<void> tryLoginWithEmail(
    BuildContext context, String email, String password) async {
  try {
    final result = await UserService.loginWithEmail(email, password);

    if (result.hasException) {
      await showCredentialsErrorDialog(context);
    } else {
      final accessToken = result.data!['signInWithEmail']['access_token'];
      final user = await getUserProfile(accessToken);
      PetList pets = await getPets(context, accessToken);
      await navigateToHome(context, user, accessToken, pets);
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> trySignUpWithEmail(String name, String lastname, String email,
    String password, BuildContext context) async {
  try {
    final result =
        await UserService.signUpWithEmail(name, lastname, email, password);

    if (result.hasException) {
      await _showCustomDialog(
        AppLocalizations.of(context)!.usedEmailTitle,
        AppLocalizations.of(context)!.usedEmailBody,
        Theme.of(context).colorScheme.error,
        Icons.error_outline_outlined,
        context,
      );
    } else {
      await _showCustomDialog(
        AppLocalizations.of(context)!.createdAccountTitle,
        AppLocalizations.of(context)!.createdAccountBody,
        Colors.green,
        Icons.check_circle_outline_outlined,
        context,
      ).then((value) =>
          Navigator.pushReplacementNamed(context, LoginScreen.route));
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> showCredentialsErrorDialog(BuildContext context) {
  return _showCustomDialog(
      AppLocalizations.of(context)!.wrongCredentialsTitle,
      AppLocalizations.of(context)!.wrongCredentialsBody,
      Theme.of(context).colorScheme.error,
      Icons.error_outline_outlined,
      context);
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

Future<void> _showCustomDialog(String title, String body, Color color,
    IconData icon, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) =>
        CustomDialog(title: title, body: body, color: color, icon: icon),
  );
}

Future<void> navigateToHome(BuildContext context, UserModel user,
    String accessToken, PetList pets) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final petsProvider = Provider.of<PetsProvider>(context, listen: false);
  userProvider.setUser(user, accessToken);
  petsProvider.setPets(pets.list);

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const NavigationBarTemplate(index: 0),
    ),
    (route) => false,
  );
}
