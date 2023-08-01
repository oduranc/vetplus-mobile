import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/widgets/skeleton_screen.dart';
import 'package:vetplus/widgets/social_button.dart';
import 'package:vetplus/widgets/welcome_carousel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                    buildSignInModal(context, isTablet);
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
                    buildSignInModal(context, isTablet);
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

  Future<dynamic> buildSignInModal(BuildContext context, bool isTablet) {
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
              const Divider(indent: 100, endIndent: 100),
              SocialButton(
                iconData: Icon(
                  FontAwesomeIcons.facebookF,
                  size: isTablet ? 20 : 20.sp,
                ),
                text: 'Continuar con Facebook',
                backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                onPressed: () {},
                isTablet: isTablet,
              ),
              SocialButton(
                iconData: Image.asset(
                  'assets/images/google-logo.png',
                  width: isTablet ? 20 : 20.sp,
                ),
                text: 'Continuar con Google',
                onPressed: () {},
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                textColor: Theme.of(context).colorScheme.outline,
                isTablet: isTablet,
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
                onPressed: () {},
                isTablet: isTablet,
              ),
            ],
          ),
        );
      },
    );
  }
}
