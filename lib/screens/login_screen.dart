import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/custom_form_field.dart';
import 'package:vetplus/widgets/form_template.dart';
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
            children: [
              Center(
                child: Image.asset(
                  'assets/images/vetplus-logo.png',
                  height: MediaQuery.of(context).size.height * 0.0774,
                ),
              ),
              CustomFormField(
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
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                  Center(
                                    child: Text(
                                      'Restaurar Contraseña',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
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
}
