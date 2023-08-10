import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/utils/password_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  static const String route = '/register';

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: FormTemplate(
        buttonText: 'Continuar',
        padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
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
            validator: validatePassword,
          ),
          CustomFormField(
            labelText: 'Confirmar contraseña',
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            validator: (value) {
              return validatePasswordConfirmation(value, _passwordController);
            },
          ),
        ],
      ),
    );
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
