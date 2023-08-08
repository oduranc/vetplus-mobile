import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/custom_form_field.dart';
import 'package:vetplus/widgets/form_template.dart';
import 'package:vetplus/widgets/long_bottom_sheet.dart';
import 'package:vetplus/widgets/skeleton_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String route = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            onSubmit: () {},
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isTablet ? 16 : 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: isTablet ? 1.25 : 1.43,
                        letterSpacing: isTablet ? 0.24 : 0.21,
                      ),
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
        return LongBottomSheet(
          title: 'Restaurar Contraseña',
          buttonText: 'Enviar enlace',
          onSubmit: () {
            _showSnackBar(context, isTablet, emailController);
          },
          children: <Widget>[
            Text(
              'Ingresa tu dirección de correo electrónico asociada a tu cuenta para que puedas restablecer tu contraseña',
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: isTablet ? 21 : 13.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.14,
                letterSpacing: 0.14,
              ),
              textAlign: TextAlign.justify,
            ),
            CustomFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              labelText: 'Correo',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  void _buildSecondRestorePasswordModal(BuildContext context, bool isTablet) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return LongBottomSheet(
          title: 'Restaurar Contraseña',
          buttonText: 'Actualizar',
          onSubmit: () {},
          children: <Widget>[
            Text(
              'Debe incluir al menos 12 dígitos, un carácter especial, una letra mayúscula, una minúscula y un número.',
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: isTablet ? 21 : 13.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.14,
                letterSpacing: 0.14,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        );
      },
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(
      BuildContext context,
      bool isTablet,
      TextEditingController emailController) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFBFBFB),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          left: isTablet ? 37 : 24.sp,
          right: isTablet ? 37 : 24.sp,
          bottom: 20.sp,
        ),
        content: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              radius: isTablet ? 33.60 : 25.sp,
              child: Icon(Icons.email_outlined, size: isTablet ? 33.60 : 25.sp),
            ),
            SizedBox(width: isTablet ? 22 : 14.sp),
            Expanded(
              child: Wrap(
                runSpacing: 4.sp,
                children: <Widget>[
                  Text(
                    'Revisa tu bandeja de entrada',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isTablet ? 22 : 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.14,
                      letterSpacing: 0.50,
                    ),
                  ),
                  Text(
                    'Un enlace para restaurar tu contraseña ha sido enviado a ${emailController.text}',
                    softWrap: true,
                    style: TextStyle(
                      color: const Color(0xFF666666),
                      fontSize: isTablet ? 20 : 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                      height: 1.33,
                      letterSpacing: 0.50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
