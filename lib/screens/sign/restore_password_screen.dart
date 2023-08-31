import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vetplus/responsive/responsive_layout.dart';
import 'package:vetplus/themes/typography.dart';
import 'package:vetplus/utils/validation_utils.dart';
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
      title: AppLocalizations.of(context)!.restorePasswordTitle,
      buttonText: AppLocalizations.of(context)!.sendLink,
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
                    AppLocalizations.of(context)!.checkEmailTitle,
                    style: getSnackBarTitleStyle(isTablet),
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .checkEmailBody(emailController.text),
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
          title: AppLocalizations.of(context)!.restorePasswordTitle,
          buttonText: AppLocalizations.of(context)!.update,
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
                return validatePasswordConfirmation(value, passwordController, context);
              },
            ),
          ],
        );
      },
    );
  }
}
