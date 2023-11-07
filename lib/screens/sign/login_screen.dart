import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/screens/sign/restore_password_screen.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/form_template.dart';

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

  Future<void> _tryLogin() async {
    setState(() {
      _isLoading = true;
    });

    await tryLoginWithEmail(
        context, _emailController.text, _passwordController.text, null);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 37 : 24.sp,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FormTemplate(
                      buttonChild: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white))
                          : Text(AppLocalizations.of(context)!.continueText),
                      onSubmit: _tryLogin,
                      padding:
                          EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/vetplus-logo.png',
                            height: MediaQuery.of(context).size.height * 0.0774,
                          ),
                        ),
                        CustomFormField(
                          labelText: AppLocalizations.of(context)!.emailText,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Wrap(
                          runSpacing: isTablet ? 28 : 11.sp,
                          alignment: WrapAlignment.end,
                          children: <Widget>[
                            CustomFormField(
                              labelText: AppLocalizations.of(context)!.password,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              isPasswordField: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: isTablet ? 28 : 11.sp),
                      child: TextButton(
                        onPressed: () {
                          _buildRestorePasswordModal(context, isTablet);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: getLinkTextStyle(isTablet),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
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
