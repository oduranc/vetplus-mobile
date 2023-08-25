// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vetplus/models/user_model.dart';
import 'package:vetplus/providers/user_provider.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/utils/user_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';

Future<void> _tryLoginWithGoogle(BuildContext context) async {
  try {
    final result = await UserService.loginWithGoogle();
    final user =
        await getUserProfile(result.data!['googleLogin']['access_token']);
    await _navigateToHome(context, user);
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
      final user =
          await getUserProfile(result.data!['googleLogin']['access_token']);
      await _navigateToHome(context, user);
    }
  } catch (e) {
    await _showServerErrorDialog(context);
  }
}

Future<void> tryLoginWithEmail(
    BuildContext context, String email, String password) async {
  try {
    final result = await UserService.loginWithEmail(email, password);

    if (result.hasException) {
      await showCredentialsErrorDialog(context);
    } else {
      final user =
          await getUserProfile(result.data!['signInWithEmail']['access_token']);
      await _navigateToHome(context, user);
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
        'Correo en uso',
        'El correo proporcionado ya se ha registrado. Intenta iniciar sesión o usar otro correo.',
        Theme.of(context).colorScheme.error,
        Icons.error_outline_outlined,
        context,
      );
    } else {
      await _showCustomDialog(
        'Cuenta creada',
        '¡Cuenta creada de manera exitosa!',
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
      'Credenciales incorrectas',
      'Las credenciales ingresadas no son correctas. Revise e intente nuevamente.',
      Theme.of(context).colorScheme.error,
      Icons.error_outline_outlined,
      context);
}

Future<void> _showServerErrorDialog(BuildContext context) {
  return _showCustomDialog(
    'Fallo en servidor',
    'Error en el servidor. Intenta luego, por favor.',
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

Future<void> _navigateToHome(BuildContext context, UserModel user) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.setUser(user);

  Navigator.pushNamedAndRemoveUntil(
    context,
    NavigationBarTemplate.route,
    (Route<dynamic> route) => false,
  );
}
