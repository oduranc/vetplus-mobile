import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/register_screen.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/sign/social_button.dart';
import 'package:vetplus/widgets/sign/welcome_carousel.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/images/vetplus-logo.png',
            height: MediaQuery.of(context).size.height * 0.0774,
          ),
          const WelcomeCarousel(),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _buildSignInModal(context, isTablet, false);
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ),
              SizedBox(
                width: isTablet ? 60 : 20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _buildSignInModal(context, isTablet, true);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _buildSignInModal(
      BuildContext context, bool isTablet, bool isRegister) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 41, right: 24, left: 24),
          child: Wrap(
            runSpacing: 22,
            children: <Widget>[
              const Divider(
                indent: 100,
                endIndent: 100,
                thickness: 4,
              ),
              // SocialButton(
              //   iconData: Icon(
              //     FontAwesomeIcons.facebookF,
              //     size: isTablet ? 20 : 20.sp,
              //   ),
              //   text: 'Continuar con Facebook',
              //   backgroundColor: Theme.of(context).colorScheme.surfaceTint,
              //   onPressed: () {},
              // ),
              SocialButton(
                iconData: Image.asset(
                  'assets/images/google-logo.png',
                  width: isTablet ? 20 : 20.sp,
                ),
                text: 'Continuar con Google',
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                textColor: Theme.of(context).colorScheme.outline,
                onPressed: () {},
              ),
              SocialButton(
                iconData: Icon(
                  Icons.email_outlined,
                  size: isTablet ? 20 : 20.sp,
                ),
                text: 'Continuar con Email',
                backgroundColor: Colors.white,
                textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                hasBorder: true,
                onPressed: () {
                  Navigator.pushReplacementNamed(context,
                      isRegister ? RegisterScreen.route : LoginScreen.route);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
