import 'package:flutter/material.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';
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

  Future<void> _showCustomDialog(
      String title, String body, Color color, IconData icon) async {
    await showDialog(
      context: context,
      builder: (context) =>
          CustomDialog(title: title, body: body, color: color, icon: icon),
    );
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await UserService.signUp(
          _nameController.text,
          _lastnameController.text,
          _emailController.text,
          _passwordController.text);

      if (result.hasException) {
        await _showCustomDialog(
          'Correo en uso',
          'El correo proporcionado ya se ha registrado. Intenta iniciar sesión o usar otro correo.',
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
        );
      } else {
        await _showCustomDialog(
          'Cuenta creada',
          '¡Cuenta creada de manera exitosa!',
          Colors.green,
          Icons.check_circle_outline_outlined,
        ).then((value) =>
            Navigator.pushReplacementNamed(context, LoginScreen.route));
      }
    } catch (e) {
      await _showCustomDialog(
        'Fallo en servidor',
        'Error en el servidor. Intenta luego, por favor.',
        Theme.of(context).colorScheme.error,
        Icons.error_outline_outlined,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        onSubmit: _submitForm,
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
