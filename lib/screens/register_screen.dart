import 'package:flutter/material.dart';
import 'package:vetplus/screens/login_screen.dart';
import 'package:vetplus/widgets/custom_form_field.dart';
import 'package:vetplus/widgets/form_template.dart';
import 'package:vetplus/widgets/skeleton_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  static const String route = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SkeletonScreen(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: FormTemplate(
        buttonText: 'Continuar',
        onSubmit: () {
          Navigator.pushNamed(context, LoginScreen.route);
        },
        children: <Widget>[
          CustomFormField(
            labelText: 'Nombre',
            keyboardType: TextInputType.name,
            validator: _validateName,
          ),
          CustomFormField(
            labelText: 'Apellido',
            keyboardType: TextInputType.name,
            validator: _validateLastname,
          ),
          CustomFormField(
            labelText: 'Correo',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          CustomFormField(
            labelText: 'Contraseña',
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            validator: _validatePassword,
          ),
          CustomFormField(
            labelText: 'Confirmar contraseña',
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            validator: _validatePasswordConfirmation,
          ),
        ],
      ),
    );
  }

  String? _validatePassword(value) {
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

  String? _validatePasswordConfirmation(value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  String? _validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'Correo es requerido';
    }
    return null;
  }

  String? _validateLastname(value) {
    if (value == null || value.isEmpty) {
      return 'Apellido es requerido';
    }
    return null;
  }

  String? _validateName(value) {
    if (value == null || value.isEmpty) {
      return 'Nombre es requerido';
    }
    return null;
  }
}
