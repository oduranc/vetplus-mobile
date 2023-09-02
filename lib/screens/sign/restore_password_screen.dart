import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/validation_utils.dart';
import 'package:vetplus/widgets/common/custom_form_field.dart';
import 'package:vetplus/widgets/common/custom_snack_bar.dart';
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
      title: AppLocalizations.of(context)!.restorePasswordTitle,
      buttonChild: Text(AppLocalizations.of(context)!.sendLink),
      onSubmit: () {
        _buildSnackBar(context, isTablet);
        Navigator.pop(context);
        _buildSecondRestorePasswordModal(context, isTablet);
      },
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.restorePasswordBody,
          style: getBottomSheetBodyStyle(isTablet),
          textAlign: TextAlign.justify,
        ),
        CustomFormField(
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          labelText: AppLocalizations.of(context)!.emailText,
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
      CustomSnackBar(
        icon: Icons.email_outlined,
        title: AppLocalizations.of(context)!.checkEmailTitle,
        body:
            AppLocalizations.of(context)!.checkEmailBody(emailController.text),
      ) as SnackBar,
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
          title: AppLocalizations.of(context)!.restorePasswordTitle,
          buttonChild: Text(AppLocalizations.of(context)!.update),
          onSubmit: () {
            Navigator.pop(context);
          },
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.secondRestorePasswordBody,
              style: getBottomSheetBodyStyle(isTablet),
              textAlign: TextAlign.justify,
            ),
            CustomFormField(
              controller: passwordController,
              labelText: AppLocalizations.of(context)!.password,
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: (value) {
                return validatePassword(value, context);
              },
            ),
            CustomFormField(
              labelText: AppLocalizations.of(context)!.confirmPassword,
              keyboardType: TextInputType.visiblePassword,
              isPasswordField: true,
              validator: (value) {
                return validatePasswordConfirmation(
                    value, passwordController, context);
              },
            ),
          ],
        );
      },
    );
  }
}
