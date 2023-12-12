// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/navigation_bar_template.dart';
import 'package:vetplus/screens/sign/login_screen.dart';
import 'package:vetplus/screens/sign/register_screen.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/skeleton_screen.dart';
import 'package:vetplus/widgets/sign/social_button.dart';
import 'package:vetplus/widgets/sign/welcome_carousel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const String route = '/';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

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
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _buildSignInModal(context, isTablet, false);
                      },
                      child: Text(AppLocalizations.of(context)!.login),
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
                      child: Text(AppLocalizations.of(context)!.register),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const NavigationBarTemplate(index: 0),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.skipForNow),
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
              SocialButton(
                iconData: Icon(
                  FontAwesomeIcons.google,
                  size: isTablet ? 20 : 20.sp,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                onPressed: _isLoading ? null : _tryGoogleLogin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white))
                    : Text(AppLocalizations.of(context)!.googleButton),
              ),
              SocialButton(
                iconData: Icon(
                  Icons.email_outlined,
                  size: isTablet ? 20 : 20.sp,
                ),
                backgroundColor: Colors.white,
                textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                hasBorder: true,
                onPressed: () {
                  Navigator.pushReplacementNamed(context,
                      isRegister ? RegisterScreen.route : LoginScreen.route);
                },
                child: Text(AppLocalizations.of(context)!.emailButton),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _tryGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await trySignUpWithGoogle(context);

    setState(() {
      _isLoading = false;
    });
  }
}
