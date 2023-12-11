// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/favorite_clinic_model.dart';
import 'package:vetplus/models/pet_model.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/favorites_provider.dart';
import 'package:vetplus/providers/pets_provider.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/auth_code_screen.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/welcome_screen.dart';
import 'package:vetplus/services/clinic_service.dart';
import 'package:vetplus/services/firebase_service.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/pet_utils.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

Future<void> tryLoginWithGoogle(BuildContext context) async {
  try {
    final result = await UserService.loginWithGoogle();
    final token = result.data!['googleLogin']['access_token'];
    final user = await getUserProfile(token!);
    await FirebaseService().initNotifications(token, user);
    PetList pets = await getPets(context, token);
    FavoriteClinicList favorites = await getFavorites(context, token);
    await navigateToHome(context, user, token, pets, favorites);
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> trySignUpWithGoogle(BuildContext context) async {
  try {
    final result = await UserService.signUpWithGoogle();
    if (result.hasException) {
      await tryLoginWithGoogle(context);
    } else {
      final accessToken = result.data!['googleLogin']['access_token'];
      final user = await getUserProfile(accessToken);
      PetList pets = await getPets(context, accessToken);
      FavoriteClinicList favorites = await getFavorites(context, accessToken);
      await navigateToHome(context, user, accessToken, pets, favorites);
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

Future<FavoriteClinicList> getFavorites(
    BuildContext context, accessToken) async {
  final favoritesResult = await ClinicService.getFavoriteClinics(accessToken);
  final favoritesJson = favoritesResult.data!;
  final favorites = FavoriteClinicList.fromJson(favoritesJson);
  return favorites;
}

Future<void> tryLoginWithEmail(
    BuildContext context, String? email, String? password) async {
  try {
    final result = await UserService.loginWithEmail(email!, password!);

    if (result.hasException) {
      await showCredentialsErrorDialog(context);
    } else {
      final token = result.data!['signInWithEmail']['access_token'];
      final user = await getUserProfile(token!);
      await FirebaseService().initNotifications(token, user);
      PetList pets = await getPets(context, token);
      FavoriteClinicList favorites = await getFavorites(context, token);
      await navigateToHome(context, user, token, pets, favorites);
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<String?> recoverWithCode(
    int code, String room, BuildContext context) async {
  try {
    final result = await UserService.recoverPassword(code, room);

    if (result.hasException) {
      await _showServerErrorDialog(context);
    } else {
      final token = result.data!['recoveryAccount']['access_token'];

      return token;
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
  return null;
}

Future<void> signUpWithCode(int code, String room, BuildContext context) async {
  try {
    final result = await UserService.signUp(code, room);

    if (result.hasException) {
      if (result.exception!.graphqlErrors[0].message == 'EMAIL_EXIST') {
        await _showCustomDialog(
          AppLocalizations.of(context)!.usedEmailTitle,
          AppLocalizations.of(context)!.usedEmailBody,
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
          context,
        );
      } else {
        await _showServerErrorDialog(context);
      }
    } else {
      final res = result.data!['signUp']['result'];
      final message = result.data!['signUp']['message'];

      if (res == 'FAILED') {
        _showCustomDialog(
          AppLocalizations.of(context)!.wrongCodeTitle,
          AppLocalizations.of(context)!.wrongCodeBody,
          Colors.red,
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
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<String?> tryRecoverPassword(String email, BuildContext context) async {
  try {
    final result = await UserService.recoverPasswordVerificationCode(email);

    if (result.hasException) {
      if (result.exception!.graphqlErrors[0].message ==
          'VALIDATION_FIELDS_FAIL') {
        await _showCustomDialog(
          AppLocalizations.of(context)!.wrongEmailFormatTitle,
          AppLocalizations.of(context)!.wrongEmailFormatBody,
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
          context,
        );
      } else {
        await _showCustomDialog(
          AppLocalizations.of(context)!.usedEmailTitle,
          AppLocalizations.of(context)!.usedEmailBody,
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
          context,
        );
      }
    } else {
      final room = result.data!['recoveryPasswordSendVerificationCode']['room'];
      return room;
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
  return null;
}

Future<void> trySignUpWithEmail(String name, String lastname, String email,
    String password, BuildContext context) async {
  try {
    final result = await UserService.signUpVerificationCode(
        name, lastname, email, password);

    if (result.hasException) {
      if (result.exception!.graphqlErrors[0].message ==
          'VALIDATION_FIELDS_FAIL') {
        await _showCustomDialog(
          AppLocalizations.of(context)!.wrongEmailFormatTitle,
          AppLocalizations.of(context)!.wrongEmailFormatBody,
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
          context,
        );
      } else {
        await _showCustomDialog(
          AppLocalizations.of(context)!.usedEmailTitle,
          AppLocalizations.of(context)!.usedEmailBody,
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
          context,
        );
      }
    } else {
      final room = result.data!['signUpVerificationCode']['room'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthCodeScreen(
            room: room,
            name: name,
            lastname: lastname,
            email: email,
            password: password,
          ),
        ),
      );
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
    builder: (context) => FutureBuilder(
        future:
            Future.delayed(const Duration(seconds: 2)).then((value) => true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Navigator.of(context).pop();
          }
          return CustomDialog(
              title: title, body: body, color: color, icon: icon);
        }),
  );
}

Future<void> navigateToHome(BuildContext context, UserModel user,
    String accessToken, PetList pets, FavoriteClinicList favorites) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final petsProvider = Provider.of<PetsProvider>(context, listen: false);
  final favoritesProvider =
      Provider.of<FavoritesProvider>(context, listen: false);
  userProvider.setUser(user, accessToken);
  petsProvider.setPets(pets.list);
  favoritesProvider.setFavorites(favorites.list);

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const NavigationBarTemplate(index: 0),
    ),
    (route) => false,
  );
}

String secondsToMinutes(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

String extractNumericPart(String input) {
  RegExp regex = RegExp(r'\d+');
  Match? match = regex.firstMatch(input);
  if (match != null) {
    return match.group(0)!;
  } else {
    return '';
  }
}

void signOut(BuildContext context) async {
  await GoogleSignIn().signOut();
  Provider.of<UserProvider>(context, listen: false).clearUser();
  Provider.of<PetsProvider>(context, listen: false).clearPets();
  Provider.of<FavoritesProvider>(context, listen: false).clearFavorites();
  Navigator.pushNamedAndRemoveUntil(
      context, WelcomeScreen.route, (route) => false);
}

Form buildCodeForm(
  bool isTablet,
  bool isBottomSheet,
  BuildContext context,
  Key formKey,
  String email,
  Widget Function(int) generator,
  String? timeRemaining,
  Future<void> Function()? onPressResend,
  Future<void> Function()? onPressConfirm,
  Widget confirmChild,
) {
  return Form(
    key: formKey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Wrap(
          runSpacing: isTablet ? 60 : 40.sp,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isBottomSheet)
                  Image.asset(
                    'assets/images/vetplus-logo.png',
                    height: MediaQuery.of(context).size.height * 0.0774,
                  ),
              ],
            ),
            if (!isBottomSheet)
              Text(AppLocalizations.of(context)!.verificationCode,
                  style: getAppbarTitleStyle(isTablet)),
            RichText(
              text: TextSpan(
                style: getCarouselBodyStyle(isTablet),
                children: <TextSpan>[
                  TextSpan(
                      text: '${AppLocalizations.of(context)!.weSentCode}\n'),
                  TextSpan(
                    text: email,
                    style: getCarouselBodyStyle(isTablet).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, generator),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: getCarouselBodyStyle(isTablet),
                    children: <TextSpan>[
                      TextSpan(text: AppLocalizations.of(context)!.resendCode),
                      TextSpan(
                        text: timeRemaining,
                        style: getCarouselBodyStyle(isTablet).copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(height: isTablet ? 40 : 35.sp),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onPressResend,
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Text(AppLocalizations.of(context)!.resend),
              ),
            ),
            SizedBox(
              width: isTablet ? 60 : 20,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: onPressConfirm,
                child: confirmChild,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
