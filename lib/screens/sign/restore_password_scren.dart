import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/theme/typography.dart';
import 'package:vetplus/utils/password_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/long_bottom_sheet.dart';

class RestorePasswordScreen extends StatelessWidget {
  const RestorePasswordScreen({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return LongBottomSheet(
      title: 'Restaurar Contraseña',
      buttonText: 'Enviar enlace',
      onSubmit: () {
        _buildSnackBar(context, isTablet);
        Navigator.pop(context);
        _buildSecondRestorePasswordModal(context, isTablet);
      },
      children: <Widget>[
        Text(
          'Ingresa tu dirección de correo electrónico asociada a tu cuenta para que puedas restablecer tu contraseña',
          style: getBottomSheetBodyStyle(isTablet),
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
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _buildSnackBar(
      BuildContext context, bool isTablet) {
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
                    style: getSnackBarTitleStyle(isTablet),
                  ),
                  Text(
                    'Un enlace para restaurar tu contraseña ha sido enviado a ${emailController.text}',
                    softWrap: true,
                    style: getSnackBarBodyStyle(isTablet),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buildSecondRestorePasswordModal(BuildContext context, bool isTablet) {
    final TextEditingController passwordController = TextEditingController();

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
              style: getBottomSheetBodyStyle(isTablet),
              textAlign: TextAlign.justify,
            ),
            CustomFormField(
              controller: passwordController,
              labelText: 'Contraseña',
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: validatePassword,
            ),
            CustomFormField(
              labelText: 'Confirmar contraseña',
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: (value) {
                return validatePasswordConfirmation(value, passwordController);
              },
            ),
          ],
        );
      },
    );
  }
}
