import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/restore_password_screen.dart';
import 'package:vetplus/services/user_service.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/widgets/common/custom_dialog.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      final result = await UserService.login(
          _emailController.text, _passwordController.text);

      if (result.hasException) {
        await _showCustomDialog(
          'Credenciales incorrectas',
          'Las credenciales ingresadas no son correctas. Revise e intente nuevamente.',
          Theme.of(context).colorScheme.error,
          Icons.error_outline_outlined,
        );
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context,
              NavigationBarTemplate.route, (Route<dynamic> route) => false);
        }
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
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormTemplate(
            buttonChild: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Continuar'),
            onSubmit: _submitForm,
            padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
            children: [
              Center(
                child: Image.asset(
                  'assets/images/vetplus-logo.png',
                  height: MediaQuery.of(context).size.height * 0.0774,
                ),
              ),
              CustomFormField(
                labelText: 'Correo',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              Wrap(
                runSpacing: isTablet ? 28 : 11.sp,
                alignment: WrapAlignment.end,
                children: <Widget>[
                  CustomFormField(
                    labelText: 'Contraseña',
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isPasswordField: true,
                  ),
                  GestureDetector(
                    onTap: () {
                      _buildRestorePasswordModal(context, isTablet);
                    },
                    child: Text(
                      '¿Has olvidado tu contraseña?',
                      style: getLinkTextStyle(isTablet),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _buildRestorePasswordModal(BuildContext context, bool isTablet) {
    TextEditingController emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return RestorePasswordScreen(emailController: emailController);
      },
    );
  }
}
