import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/restore_password_screen.dart';
import 'package:vetplus/theme/typography.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FormTemplate(
            buttonText: 'Continuar',
            onSubmit: () {
              Navigator.pushNamedAndRemoveUntil(context,
                  NavigationBarTemplate.route, (Route<dynamic> route) => false);
            },
            padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
            children: [
              Center(
                child: Image.asset(
                  'assets/images/vetplus-logo.png',
                  height: MediaQuery.of(context).size.height * 0.0774,
                ),
              ),
              const CustomFormField(
                labelText: 'Correo',
                keyboardType: TextInputType.emailAddress,
              ),
              Wrap(
                runSpacing: isTablet ? 28 : 11.sp,
                alignment: WrapAlignment.end,
                children: <Widget>[
                  const CustomFormField(
                    labelText: 'Contraseña',
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
