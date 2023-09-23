import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/utils/sign_utils.dart';
import 'package:vetplus/utils/validation_utils.dart';
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

  Future<void> _tryRegister(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await trySignUpWithEmail(_nameController.text, _lastnameController.text,
        _emailController.text, _passwordController.text, context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return SkeletonScreen(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: FormTemplate(
        buttonChild: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white))
            : Text(AppLocalizations.of(context)!.continueText),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 99 : 15),
        onSubmit: () {
          _tryRegister(context);
        },
        children: <Widget>[
          CustomFormField(
            labelText: AppLocalizations.of(context)!.nameText,
            controller: _nameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return validateName(value, context);
            },
          ),
          CustomFormField(
            labelText: AppLocalizations.of(context)!.surnameText,
            controller: _lastnameController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return validateLastname(value, context);
            },
          ),
          CustomFormField(
            labelText: AppLocalizations.of(context)!.emailText,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return validateEmail(value, context);
            },
          ),
          CustomFormField(
            labelText: AppLocalizations.of(context)!.password,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            validator: (value) {
              return validatePassword(value, context);
            },
          ),
          CustomFormField(
            labelText: AppLocalizations.of(context)!.confirmPassword,
            controller: _confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            isPasswordField: true,
            validator: (value) {
              return validatePasswordConfirmation(
                  value, _passwordController, context);
            },
          ),
        ],
      ),
    );
  }
}
