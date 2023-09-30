import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? validateEmail(value, context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.emailText);
  }
  return null;
}

String? validateLastname(value, context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.surnameText);
  }
  return null;
}

String? validateName(value, context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.nameText);
  }
  return null;
}

String? validateSex(value, context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.sex);
  }
  return null;
}

String? validateSpecie(value, context) {
  if (value == null) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.specie);
  }
  return null;
}

String? validateBreed(value, context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.breed);
  }
  return null;
}

String? validateCastrated(value, context) {
  if (value == null) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.castrated);
  }
  return null;
}

String? validatePassword(value, context) {
  String response = '';
  if (value == null || value.isEmpty) {
    response +=
        '${AppLocalizations.of(context)!.isRequired(AppLocalizations.of(context)!.password)}\n';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value!)) {
    response += '${AppLocalizations.of(context)!.capitalLetterValidation}\n';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    response += '${AppLocalizations.of(context)!.lowercaseLetterValidation}\n';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    response += '${AppLocalizations.of(context)!.numberValidation}\n';
  }
  if (!RegExp(r'[!@#\\$&*~]').hasMatch(value)) {
    response += '${AppLocalizations.of(context)!.specialCharValidation}\n';
  }
  if (value.length < 12) {
    response += AppLocalizations.of(context)!.lengthValidation;
  }
  if (response != '') {
    return response;
  }
  return null;
}

String? validatePasswordConfirmation(value, passwordController, context) {
  if (value != passwordController.text) {
    return AppLocalizations.of(context)!.passwordMatch;
  }
  return null;
}

String? validateComment(String? value, context) {
  int maxLength = 150;
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!
        .isRequired(AppLocalizations.of(context)!.comments);
  }
  if (value.length > maxLength) {
    return AppLocalizations.of(context)!
        .textLengthExceeded(value.length - maxLength);
  }
  return null;
}
