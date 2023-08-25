import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  static const String route = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _tryRegister(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await trySignUpWithEmail(_nameController.text, _lastnameController.text,
        _emailController.text, _passwordController.text, context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: FormTemplate(
        buttonChild: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Continuar'),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
        onSubmit: () {
          _tryRegister(context);
        },
        children: <Widget>[
          CustomFormField(
            labelText: 'Nombre',
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: validateName,
          ),
          CustomFormField(
            labelText: 'Apellido',
            controller: _lastnameController,
            keyboardType: TextInputType.name,
            validator: validateLastname,
          ),
          CustomFormField(
            labelText: 'Correo',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
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
            controller: _confirmPasswordController,
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
}
