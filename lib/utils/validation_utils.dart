String? validateEmail(value) {
  if (value == null || value.isEmpty) {
    return 'Correo es requerido';
  }
  return null;
}

String? validateLastname(value) {
  if (value == null || value.isEmpty) {
    return 'Apellido es requerido';
  }
  return null;
}

String? validateName(value) {
  if (value == null || value.isEmpty) {
    return 'Nombre es requerido';
  }
  return null;
}

String? validatePassword(value) {
  String response = '';
  if (value == null || value.isEmpty) {
    response += 'Contraseña es requerida\n';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value!)) {
    response += 'Debe tener al menos una letra mayúscula\n';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    response += 'Debe tener al menos una letra minúscula\n';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    response += 'Debe tener al menos un número\n';
  }
  if (!RegExp(r'[!@#\\$&*~]').hasMatch(value)) {
    response += 'Debe tener al menos un caracter especial\n';
  }
  if (value.length < 12) {
    response += 'Debe tener al menos 12 caracteres';
  }
  if (response != '') {
    return response;
  }
  return null;
}

String? validatePasswordConfirmation(value, passwordController) {
  if (value != passwordController.text) {
    return 'Las contraseñas no coinciden';
  }
  return null;
}
